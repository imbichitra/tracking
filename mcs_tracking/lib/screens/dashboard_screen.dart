import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/graph/distanceByDateAndVehicle.dart';
import 'package:mcs_tracking/Models/pinPillModel.dart';
import 'package:mcs_tracking/Models/token.dart';
import 'package:mcs_tracking/Models/vehicle_detail.dart';
import 'package:mcs_tracking/StateManagement/Device/device_provider.dart';
import 'package:mcs_tracking/StateManagement/Driver/driver_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/analytics_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/distanceByDateAndVehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/graph_provider.dart';
import 'package:mcs_tracking/StateManagement/Organization/organization_provider.dart';
import 'package:mcs_tracking/StateManagement/Trip/trip_provider..dart';
import 'package:mcs_tracking/StateManagement/User/user_provider.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/auth/auth_state.dart';
import 'package:mcs_tracking/api/current-user/current_user_repository.dart';
import 'package:mcs_tracking/api/last-location/last_location_repository.dart';
import 'package:mcs_tracking/components/categories_scroller%20.dart';
import 'package:mcs_tracking/components/custom_AlertDialog.dart';
import 'package:mcs_tracking/components/custom_drawer/custom_drawer.dart';
import 'package:mcs_tracking/components/map_pin_pill.dart';
import 'package:mcs_tracking/global.dart';

import 'package:mcs_tracking/utils/services/google_map_services.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../loading.dart';
import 'Report/report_screen.dart';


double lat;
double long;

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

// getting current user and last location
  CurrentUserRepository currentUserRepository;
  LastLocationRepository lastLocationRepository;

  // Markers variable
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var currentLocation;
  bool mapToggle = false;
  Map<dynamic, dynamic> livedata;

  Future<Token> tokenObject;

  bool isLoading = true;
  Token tokenObj;
  String token;
  String refreshToken;
  String role;

// socket variable
  StompClient client;
  static double latitude;
  static double longitude;
  Map newResult;
  StompClient stompClient;
  PersistentBottomSheetController bottomSheetController;

  double pinPillPosition = -120;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      location: LatLng(0, 0),
      deviceImei: '',
      drivername: '',
      vehicleNumber: '',
      labelColor: Colors.grey);

  bool isCurrent = false;

// maps
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 15.4746,
  );

  // Map controller
  double lastlocationLatitude;
  double lastlocationLongitude;
  int _markerIdCounter = 0;
  List<VehicleDetail> vehicleDetail = new List<VehicleDetail>();
  VehicleDetail currentVehicle;
  bool isAlreadySubscribeToVehicle = false;
  var currentSubscribedVehicleNo;
  var unsubscribeFn;

  bool isCategoriesScrollerVisible = false;
  CurrentUser currentUser;

  // Marker Animation variables
  LatLngInterpolationStream _latLngStream = LatLngInterpolationStream(
    movementDuration: Duration(milliseconds: 2000),
  );
  StreamSubscription<LatLngDelta> subscription;
  LatLng initialPositin; //19.450285, 84.673330
  LatLng currentPositin;
  GoogleMapServices _googleMapsServices = GoogleMapServices();
  List<LatLng> result = <LatLng>[];
  MarkerId sourceId = MarkerId("SourcePin");
  LatLng lastPosition;
  MarkerId markerId;
  bool isSubscribed;
  BitmapDescriptor pinLocationIcon;

  //on back button click
  DateTime currentBackPressTime;



  void ShowWidget() {
    setState(() {
      isCategoriesScrollerVisible = true;
      print("Work");
    });
  }

  void createMapMarker() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/car_icon.png');
  }

  @override
  void initState() {
    super.initState();
    createMapMarker();
    getCurrentUser();
    initSocket();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    callingAllTheRestApi();
  }

  @override
  void dispose() {
    client.deactivate();
    super.dispose();
  }
  void setMapBoundary()async{
    GoogleMapController controller = await _controller.future;
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(boundsFromLatLngList(),50);
    controller.animateCamera(u2).then((void v){
      check(u2,controller);
    });
  }
  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
      check(u, c);
  }
  LatLngBounds boundsFromLatLngList() {
    assert(vehicleDetail.isNotEmpty);
    double x0, x1, y0, y1;
    for (VehicleDetail latLng in vehicleDetail) {
      if (x0 == null) {
        x0 = x1 = latLng.lat;
        y0 = y1 = latLng.lng;
      } else {
        if (latLng.lat > x1) x1 = latLng.lat;
        if (latLng.lat < x0) x0 = latLng.lat;
        if (latLng.lng > y1) y1 = latLng.lng;
        if (latLng.lng < y0) y0 = latLng.lng;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
  void getCurrentUser() async {
    currentUserRepository = CurrentUserRepository();
    CurrentUser data = await currentUserRepository.getCurrentUser();
    if (data != null) {
      setState(() {
        currentUser = data;
        user = data;
        CurrentUserSingleton(data);
      });
      // print(data.orgRefName);
      getLastLocationVehicle();
    }

/*
    loginController.getCurrentUser(accessGlobalToken).then((data)async{
      if(data != null){
        setState(() {
          currentUser = data;
          user=data;
        });

        print("User ref name= "+data.getorgRefName);
        //print("User ref name= "+currentUser.orgRefName);
        getLastLocationVehicle();
      }
    });

 */
  }

  void getLastLocationVehicle() async {
    lastLocationRepository = LastLocationRepository();
    lastLocationRepository
        .getLastLocation(currentUser.orgRefName)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value != null) {
        ShowWidget();
        setState(() {
          vehicleDetail = value;
        });
        print(value.length);
        print("OBJECT NO " + value.length.toString());
        for (int i = 0; i < vehicleDetail.length; i++) {
          addLastLocationVehicle(vehicleDetail[i]);
        }
        setMapBoundary();
      }
    }).catchError((e) => print(e));
  }

  //returnType : void
  //name : _addMarker
  //parameters : None
  //description : This function helps to add marker to the map. Markers are taking the vehicles latitude & longitude

  void addLastLocationVehicle(VehicleDetail obj) async {
    var markerVal = obj.vehicleNumber;
    MarkerId merkarId = MarkerId(markerVal);
    latitude = obj.lat;
    longitude = obj.lng;
    print("latitude=" +
        latitude.toString() +
        " longitude=" +
        longitude.toString());

    Marker marker = Marker(
        markerId: merkarId,
        icon: obj.currentFlag
            ? await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(devicePixelRatio: 0.0), 'images/car.png')
            : await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(devicePixelRatio: 0.0),
                'images/car_red.png'),
        position: LatLng(obj.lat, obj.lng),
        onTap: () {
          print("***************************************************");
          print("clicked");
          setState(() {
            markers.clear();
            currentVehicle = obj;
            _addMarker();
          });
          subscribeToVehicle(obj.vehicleNumber, obj);
        });
    Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      markers[merkarId] = marker;
    });
  }

  //returnType : void
  //name : _addMarker
  //parameters : None
  //description : This function helps to add marker to the map
  void _addMarker() async {
    var markerIdVal = currentVehicle.vehicleNumber;
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    latitude = currentVehicle.lat;
    longitude = currentVehicle.lng;

    final Marker marker = Marker(
      markerId: markerId,
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'images/car.png'),
      position: LatLng(currentVehicle.lat, currentVehicle.lng),
      // infoWindow: InfoWindow(title: object["vehicleNumber"].toString(), snippet:"Device Imei : "+object["imeiNumber"].toString()+"\n"+"Driver Name: "+object["driverName"]),
      onTap: () {
        String location = '$latitude , $longitude';
        print("HELLOq");
        print(location);
        bottomSheetController =
            _scaffoldKey.currentState.showBottomSheet((context) => Container(
                  child: getBottomSheet(location),
                  height: 400.0,
                  color: Colors.transparent,
                ));
      },
    );
    Future.delayed(Duration(seconds: 1), () async {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 17.0,
          ),
        ),
      );
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
      print("inside addmarker total markers length");
      print(markers..length);
    });

    // print(markers);
  }

  void _updateMarker(VehicleDetail obj) async {
    // print(object);
    print("inside update marker function --------------->");
    var markerIdVal = obj.vehicleNumber;
    final MarkerId markerId = MarkerId(markerIdVal);
    print("DATE" + obj.dateTimestamp);
    // creating a new MARKER
    latitude = obj.lat;
    longitude = obj.lng;
    Marker marker = markers[markerId];

    Marker updatedMarker = marker.copyWith(
      positionParam: LatLng(latitude, longitude),
      // iconParam: obj.currentFlag?await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.0), 'images/car.png')
      //     :await BitmapDescriptor.fromAssetImage(
      //     ImageConfiguration(devicePixelRatio: 0.0), 'images/car_red.png'),
    );
    Future.delayed(Duration(seconds: 1), () async {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 17.0,
          ),
        ),
      );
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      // adding a new marker to map
      markers[markerId] = updatedMarker;
      print("total markers are================>");
      print(markers.length);
    });

    // print(markers);
  }

  //returnType : Widget
  //name : getBottomSheet
  //parameters : String location
  //description :  This function return a BottomSheet widget which contains the information of a particular vehicle
  Widget getBottomSheet(String location) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 32),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Vehicle Id :",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            currentVehicle.vehicleNumber.toString() ??
                                "Loading....",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Name :",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            currentVehicle.driverName.toString() ??
                                "Loading....",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Last Time :",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            currentVehicle.dateTimestamp.toString() ??
                                "Loading....",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      location,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      currentVehicle.driverContact.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Top Speed : " + currentVehicle.topSpeed.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Average Speed : " +
                          currentVehicle.averageSpeed.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Current Speed  : " + currentVehicle.speed.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Fuel : " + currentVehicle.fuel.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Distance Travelled : " +
                          currentVehicle.distance.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        )
      ],
    );
  }

  //returnType : dynamic
  //name : onConnect
  //parameters : StompClient object, StrompFrame object
  //description :  This function helps to subscribe to a url and throw socket data
  dynamic onConnect(StompClient client, StompFrame frame) {
    print("SOCKET CONNECTED");
    stompClient = client;
    stompClient.subscribe(
        destination: '/topic/${currentUser.orgRefName}',
        callback: (StompFrame frame) {
          newResult = json.decode(frame.body);
          print(newResult.toString());
          print(currentUser.orgRefName);
          var data = VehicleDetail.fromJsonSocket(newResult);
          //var existingItem = vehicleDetail.firstWhere((itemToCheck) => itemToCheck.vehicleNumber == data.vehicleNumber, orElse: () => null);
          //print("CHECKED DATA "+existingItem.toString());

          if (vehicleDetail != null) {
            setState(() {
              int index = vehicleDetail.indexWhere(
                  (element) => element.vehicleNumber == data.vehicleNumber);

              if (index != -1) {
                print("index is" + index.toString());
                vehicleDetail[index] = data;
              }
              print("--------------------------------->");
              print("length " + vehicleDetail.length.toString());
            });
          } else {
            /*ShowWidget();
            setState(() {

              vehicleDetail.add(data);
            });*/
          }
        });
  }

  //returnType : void
  //name : unSubscribe
  //parameters : None
  //description :  it unsubscribe the socket connection and other resources, which is already subscribe by one vehicle
  void unSubscribe() {
    if (isAlreadySubscribeToVehicle) {
      print("inside unSubscribe function: 2");
      unsubscribeFn(unsubscribeHeaders: {"id": "hello"});
    }
    if (subscription != null) {
      print("yes 2");
      subscription.cancel();
    }

    _latLngStream = LatLngInterpolationStream(
      movementDuration: Duration(milliseconds: 2000),
    );
  }

  //returnType : void
  //name : subscribeToVehicle
  //parameters : vehicle Number, Vehicle object
  //description :  when clicking on a marker it subscribe to the particular vehicle and it gives that vehicle latitude and longitude by socket connection
  void subscribeToVehicle(var vehicleNo, VehicleDetail obj) {
    print("inside subscribe vehicle function" + vehicleNo);
    unSubscribe();
    setState(() {
      currentSubscribedVehicleNo = vehicleNo;
    });

    _addSelectedMarker(obj);

    if (initialPositin == null || currentPositin == null) {
      initialPositin = LatLng(obj.lat, obj.lng);
      // currentPositin = LatLng(obj.lat,obj.lng);
    }

    subscribeLatLngStream();

    print("working");
    // subscribeFun(vehicleNo);
    unsubscribeFn = stompClient.subscribe(
      destination: '/topic/' + vehicleNo,
      callback: (StompFrame frame) {
        print("working 2");
        newResult = json.decode(frame.body);
        print("data" + newResult.toString());
        latitude = newResult["lat"];
        longitude = newResult["lng"];
        print("data" + newResult.toString());
        var data = VehicleDetail.updateObject(currentVehicle, newResult);
        if (bottomSheetController != null &&
            currentSubscribedVehicleNo == data.vehicleNumber) {
          bottomSheetController.setState(() {
            currentVehicle = data;
          });
        }
        if (currentSubscribedVehicleNo == data.vehicleNumber) {
          setState(() {
            currentPositin = LatLng(latitude, longitude);
            isAlreadySubscribeToVehicle = true;
            //currentVehicle = VehicleDetail.updateObject(currentVehicle,newResult);
            // _updateMarker(data);
            getGoogleRoutes();
            // subscription.resume();
          });
        }
      },
      headers: {"id": "hello"},
    );

    print("End here");
  }

  //returnType : void
  //name : getGoogleRoutes
  //parameters : None
  //description :  Get  the google routes from initial position to current postion
  void getGoogleRoutes() async {
    String route = await _googleMapsServices.getRouteCoordinate(
        initialPositin, currentPositin);
    _convertToLatLng(_decodePoly(route));
    updateMarkerPosition();
    initialPositin = currentPositin;
    currentPositin = null;
    // subscription.pause();
  }

  //returnType : void
  //name : moveCamera
  //parameters : LatLng
  //description : on marker move it moves the maps
  void subscribeLatLngStream() {
    subscription =
        _latLngStream.getLatLngInterpolation().listen((LatLngDelta delta) {
      setState(() {
        Marker sourceMarker = Marker(
          // markerId: sourceId,
          markerId: markerId,
          rotation: delta.rotation + 130,
          icon: pinLocationIcon,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          position: LatLng(
            delta.from.latitude,
            delta.from.longitude,
          ),
        );

        markers[markerId] = sourceMarker;
      });

      lastPosition = delta.to;
      print("last position is -----------------> $lastPosition");
      Future.delayed(Duration(seconds: 5), () async {
        moveCamera(lastPosition);
      });
    });
  }

  //returnType : void
  //name : moveCamera
  //parameters : LatLng
  //description : on marker move it moves the maps
  void moveCamera(LatLng to) async {
    // print("inside move camera function");
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      tilt: 0,
      target: to,
      zoom: 17.0,
    )));
  }

  //returnType : void
  //name : _addSelectedMarker
  //parameters : Vehicle Object(VehicleDetail Class Object)
  //description : On Tap of a marker we clear all the marker from maps only show the selected marker, this function helps to do that
  void _addSelectedMarker(VehicleDetail obj) async {
    // print(currentVehicle);
    var markerIdVal = obj.vehicleNumber;
    markerId = MarkerId(markerIdVal);
    latitude = obj.lat;
    longitude = obj.lng;
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(obj.lat, obj.lng),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'images/car.png'),
        onTap: () {
          String location = '$latitude , $longitude';
          print("HELLOq");
          print(location);
          bottomSheetController =
              _scaffoldKey.currentState.showBottomSheet((context) => Container(
                    child: getBottomSheet(location),
                    height: 400.0,
                    color: Colors.transparent,
                  ));

          if (currentVehicle == null ||
              currentVehicle.vehicleNumber != obj.vehicleNumber) {
            if (bottomSheetController != null) {
              bottomSheetController.setState(() {
                currentVehicle = obj;
                print(currentVehicle);
              });
            }
          }
        });

    Future.delayed(Duration(seconds: 1), () async {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 17.0)));
    });

    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      markers[markerId] = marker;
      print(markers);
    });
  }

  //returnType : List LatLng
  //name : _convertToLatLng
  //parameters : List points
  //description : converts the coardinates into Latlng and return the list
  List<LatLng> _convertToLatLng(List points) {
    print("inside convert latlng function");
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        //getting lat lng from array
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  //returnType : List of dynamic
  //name : _decodePoly
  //parameters : String poly(polylines)
  //description : Decode the polylines and return the list of coordinates
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  //returnType : void
  //name : updateMarkerPosition
  //parameters : None
  //description : Update the marker position during smooth Movement
  Future<void> updateMarkerPosition() async {
    for (int i = 0; i < result.length - 1; i++) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _latLngStream.addLatLng(result[i]);
    }

    //  Todo: 09 Feb 2021
    result.clear();
  }

  //returnType : void
  //name : initSocket
  //parameters : None
  //description : This function initialize the StompClient Socket connection & holds the onConnect function to listen data from the socket
  void initSocket() {
    client = StompClient(
        config: StompConfig(
            url: 'ws://192.168.2.202:8084/appendpoint',
          // url: "https://qascorpious.asiczen.com/appendpoint",
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error.toString())));

    client.activate();
  }

  @override
  Widget build(BuildContext context) {

    //To get the User Role

    role = Provider.of<AuthState>(context, listen: false).getToken.role;


    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (_scaffoldKey.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        } else if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            elevation: 0,
            content: Container(
              margin: EdgeInsets.symmetric(horizontal: 70.0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                "Double click to exit",
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
          ));
          return false;
        }

        return true;
      },
      child: isLoading
          ? Loading()
          : Scaffold(
              key: _scaffoldKey,
              drawer: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Color(0xffffffff).withAlpha(200),
                ),
                child: CustomDrawer(currentUser: currentUser, scaffoldKey: _scaffoldKey,role: role,parentContext: context,)
                // myDrawer(),
              ),
              appBar: AppBar(
                elevation: 0,
                iconTheme: new IconThemeData(
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Dashboard',
                    style: Theme.of(context).textTheme.headline3),
                // flexibleSpace: getAppbarGradient()
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.alignLeft),
                  onPressed: () {
                    if (!_scaffoldKey.currentState.isDrawerOpen) {
                      _scaffoldKey.currentState.openDrawer();
                    }
                  },
                ),
                backgroundColor: Colors.white,
              ),
              body: Stack(children: [
                Column(
                  children: <Widget>[
                    Visibility(
                      visible: isCategoriesScrollerVisible,
                      child: CategoriesScroller(
                          vehicleDetail: vehicleDetail,
                          press: (VehicleDetail data) {
                            /*if(bottomSheetController !=null) {
                    bottomSheetController.close();
                  }*/
                            print("clicked on tab");
                            if (currentVehicle == null ||
                                currentVehicle.vehicleNumber !=
                                    data.vehicleNumber) {
                              if (bottomSheetController != null) {
                                bottomSheetController.setState(() {
                                  currentVehicle = data;
                                  print(currentVehicle);
                                });
                              }

                              subscribeToVehicle(data.vehicleNumber, data);
                              print("CategoriesScroller is clickedd" +
                                  data.vehicleNumber);
                              setState(() {
                                markers.clear();
                                currentVehicle = data;
                                _addMarker();
                              });
                            }
                          }),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(20.296059, 85.824539),
                            zoom: 15,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          onTap: (LatLng location) {
                            setState(() {
                              pinPillPosition = -150;
                            });
                          },
                          markers: Set<Marker>.of(markers.values)),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 3,
                              blurRadius: 1.5),
                          BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 4,
                              blurRadius: 1.5),
                        ]),
                    child: IconButton(
                      tooltip: "refresh",
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        unSubscribe();
                        markers.clear();
                        print(vehicleDetail.length);
                        for (int i = 0; i < vehicleDetail.length; i++) {
                          addLastLocationVehicle(vehicleDetail[i]);
                        }
                        setMapBoundary();
                        // setState(() {
                        //   Future.delayed(Duration(seconds: 1), () async {
                        //     GoogleMapController controller =
                        //         await _controller.future;
                        //     controller.animateCamera(
                        //         CameraUpdate.newCameraPosition(CameraPosition(
                        //             target: LatLng(latitude, longitude),
                        //             zoom: 10)));
                        //   });
                        // });
                      },
                    ),
                  ),
                ),
                // MapPinPillComponent(
                //     pinPillPosition: pinPillPosition,
                //     currentlySelectedPin: currentlySelectedPin)
              ]),
            ),
    );
  }



  // Container(
  // width: MediaQuery.of(context).size.width / 1.2,
  // child: ListView.builder(
  // itemCount: drawerItemModelList.length,
  // itemBuilder: (BuildContext context, int index) {
  // return Theme(
  // data: Theme.of(context)
  //     .copyWith(cardColor: Color(0xff187bcd).withAlpha(10)),
  // child: ExpansionPanelList(
  // elevation: 0,
  // animationDuration: Duration(seconds: 1),
  // children: [
  // ExpansionPanel(
  // isExpanded: drawerItemModelList[index].isExpandable,
  // headerBuilder: (BuildContext context, bool isExtended) {
  // return ListTile(
  // title: Text(drawerItemModelList[index].header,
  // style: Theme.of(context)
  //     .textTheme
  //     .headline2
  //     .copyWith(color: Colors.white, fontSize: 18.0)),
  // );
  // },
  // body: Container(
  // height: 20.0 *
  // drawerItemModelList[index]
  //     .drawerBodyModel
  //     .items
  //     .length,
  // child: ListView.builder(
  // itemCount: drawerItemModelList[index]
  //     .drawerBodyModel
  //     .items
  //     .length,
  // itemBuilder: (BuildContext context, int i) {
  // return Text("Hello",
  // style: Theme.of(context)
  //     .textTheme
  //     .headline2
  //     .copyWith(
  // color: Colors.blueAccent,
  // fontSize: 10.0));
  // }),
  // ),
  // // child: ListView.builder(
  // //     itemCount: drawerItemModelList[index]
  // //         .drawerBodyModel
  // //         .items
  // //         .length,
  // //     itemBuilder: (BuildContext context, int i) {
  // //       return ListTile(
  // //         title: Text(
  // //             drawerItemModelList[index]
  // //                 .drawerBodyModel
  // //                 .items[i]
  // //                 .toString(),
  // //             style: Theme.of(context)
  // //                 .textTheme
  // //                 .headline2
  // //                 .copyWith(color: Colors.blueAccent)),
  // //       );
  // //     }),
  // )
  // ],
  // expansionCallback: (int item, bool status) {
  // setState(() {
  // drawerItemModelList[index].isExpandable =
  // !drawerItemModelList[index].isExpandable;
  // });
  // },
  // ),
  // );
  // },
  // ),
  // // child: Drawer(
  // //   child: ListView(
  // //     // Important: Remove any padding from the ListView.
  // //     padding: EdgeInsets.zero,
  // //     children: <Widget>[
  // //       Container(
  // //         child: UserAccountsDrawerHeader(
  // //           currentAccountPicture: CircleAvatar(
  // //             radius: 60.0,
  // //             backgroundImage: AssetImage("images/user-icon.png"),
  // //           ),
  // //           accountName: Text(
  // //             "${currentUser.orgRefName.toUpperCase()}",
  // //             style: Theme.of(context).textTheme.headline2.copyWith(
  // //                 color: Theme.of(context).accentColor, fontSize: 20.0),
  // //           ),
  // //           accountEmail: Text(
  // //             "${currentUser.emailid.toLowerCase()}",
  // //             style: Theme.of(context).textTheme.headline5.copyWith(
  // //                 color: Theme.of(context).accentColor, fontSize: 15.0),
  // //           ),
  // //         ),
  // //       ),
  // //       ListTile(
  // //         leading: FaIcon(FontAwesomeIcons.houseUser),
  // //         title: CustomDropdown(
  // //             context,
  // //             'Organizations',
  // //             role == "ROLE_SUPERADMIN"
  // //                 ? ["My Organization"]
  // //                 : [
  // //                     'Add Organization',
  // //                     'View All Organization',
  // //                     'My Organization'
  // //                   ],
  // //             setOrganizationRoute),
  // //       ),
  // //       ListTile(
  // //         leading: FaIcon(FontAwesomeIcons.toolbox),
  // //         title: CustomDropdown(
  // //           context,
  // //           'Devices',
  // //           ['Add Devices', 'View All Devices'],
  // //           setDevicesRoute,
  // //         ),
  // //         onTap: () {
  // //           // Update the state of the app.
  // //           // ...
  // //           // Navigator.pop(context);
  // //         },
  // //       ),
  // //       ListTile(
  // //         leading: FaIcon(FontAwesomeIcons.carAlt),
  // //         title: CustomDropdown(
  // //           context,
  // //           'Vehicles',
  // //           ['Add Vehicles', 'View All Vehicles', 'Associate With Devices'],
  // //           setVehiclesRoute,
  // //         ),
  // //         onTap: () {
  // //           // Update the state of the app.
  // //           // ...
  // //           // Navigator.pop(context);
  // //         },
  // //       ),
  // //       ListTile(
  // //         leading: FaIcon(FontAwesomeIcons.userAlt),
  // //         title: CustomDropdown(
  // //             context,
  // //             'Drivers',
  // //             ['Add Driver', 'All Drivers', 'Associate with Vehicle'],
  // //             setDriversRoute),
  // //         onTap: () {
  // //           // Update the state of the app.
  // //           // ...
  // //         },
  // //       ),
  // //       ListTile(
  // //         leading: FaIcon(FontAwesomeIcons.userAlt),
  // //         title:
  // //             CustomDropdown(context, 'Users', ['All Users'], setUserRoute),
  // //         onTap: () {
  // //           // Update the state of the app.
  // //           // ...
  // //         },
  // //       ),
  // //       ListTile(
  // //         leading: FaIcon(
  // //           FontAwesomeIcons.fileAlt,
  // //         ),
  // //         title: CustomDropdown(
  // //             context, 'Reports', ['Report'], setGraphStatus),
  // //
  // //         // Text('Reports', style: Theme.of(context).textTheme.subtitle1),
  // //         onTap: () {
  // //           // Navigator.push(context,
  // //           //     MaterialPageRoute(builder: (context) => ReportScreen()));
  // //         },
  // //       ),
  // //       ListTile(
  // //         leading: FaIcon(
  // //           FontAwesomeIcons.fileAlt,
  // //         ),
  // //         title: CustomDropdown(context, 'Trip',
  // //             ['Manage Trip', 'Trip Status'], setTripRoute),
  // //
  // //         // Text('Reports', style: Theme.of(context).textTheme.subtitle1),
  // //         onTap: () {
  // //           // Navigator.push(context,
  // //           //     MaterialPageRoute(builder: (context) => ReportScreen()));
  // //         },
  // //       ),
  // //       ListTile(
  // //         leading: Icon(Icons.exit_to_app),
  // //         title:
  // //             Text("Signout", style: Theme.of(context).textTheme.subtitle1),
  // //         onTap: _showMyDialog,
  // //       )
  // //     ],
  // //   ),
  // // ),
  // )

  //returnType : Future<void>
  //name : _showMyDialog
  //parameters : None
  //description : When user double tap on back button custom dialog pop up to ensure exit from app.
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog();
      },
    );
  }







  //returnType : void
  //name : setGraphStatus
  //parameters : String dropdownValue
  //description : Based on Dropdown value click navigate to graph/ report page
  void setGraphStatus(String newValue) {
    // DistanceByDateAndVehicle distanceByDateAndVehicle =
    // DistanceByDateAndVehicle(
    //     inputDate: "2021-02-05T13:05:32Z",
    //     orgRefName:
    //     CurrentUserSingleton.getInstance.getCurrentUser.orgRefName);

    if (newValue == "Report") {
      // Provider.of<GraphStateManagement>(context, listen: false)
      //     .fetchFleetStatus(currentUser.orgRefName);
      // Provider.of<AnalyticsStateManagement>(context, listen: false)
      //     .fetchUnderutilizedVehicles(currentUser.orgRefName);
      // Provider.of<AnalyticsStateManagement>(context, listen: false)
      //     .fetchOverSpeedVehicles(currentUser.orgRefName);
      // Provider.of<AnalyticsStateManagement>(context, listen: false)
      //     .fetchUnderSpeedVehicles(currentUser.orgRefName);
      // Provider.of<AnalyticsStateManagement>(context, listen: false)
      //     .fetchLowFuelVehicles(currentUser.orgRefName);
      //
      // Provider.of<DistanceByDateAndVehicleStateManagement>(context,
      //     listen: false)
      //     .fetchDistanceByDateAndVehicle(
      //     jsonEncode(distanceByDateAndVehicle.toJson()));

      // Provider.of<GraphStateManagement>(context,listen: false).fetchFleetUsage(currentUser.orgRefName);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ReportScreen()));
    }
  }



  //returnType : Widget
  //name : CustomDropdown
  //parameters : String labelName, context, Function onpressed
  //description : CustomDropdown design from DropDown class
  Widget CustomDropdown(BuildContext context, String labelName,
      List<String> contents, Function onpressed) {
    return DropdownButton<String>(
      // value: 'Organization',
      // decoration: InputDecoration(
      //     enabledBorder: UnderlineInputBorder(
      //         borderSide: BorderSide(color: Colors.white))),
      hint: Text(
        labelName,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      icon: Icon(Icons.arrow_right),
      isExpanded: true,
      // iconSize: 10,
      elevation: 16,
      underline: Container(
        color: Colors.white,
      ),
      style: Theme.of(context).textTheme.subtitle1,
      onChanged: (_) {
        onpressed(_);
      },
      items: contents.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      }).toList(),
    );
  }

  //returnType : Widget
  //name : fuelItem
  //parameters : var s, IconData data, var d
  //description : custom widget for FuelItem
  Widget fuelItem(var s, IconData data, var d) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //color: Colors.blueAccent,
      height: 110,
      width: 190,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.blueAccent[100],
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 0,
                    color: Colors.black12, // Black color with 12% opacity
                  )
                ]),
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(22)),
            ),
          ),
          Positioned(
            top: 30,
            right: 40,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 60,
              child: FaIcon(
                data,
                size: 50,
                color: Colors.grey[700],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: 100,
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      s,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            topRight: Radius.circular(22))),
                    child: Text(
                      d,
                      style: Theme.of(context).textTheme.button,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //returnType : void
  //name : callingAllTheRestApi
  //parameters :
  //description : Calling all the api used in the application in this function.
  void callingAllTheRestApi() async {
    // ORGANIZATION REST API CALL
    currentUserRepository = CurrentUserRepository();
    CurrentUser data = await currentUserRepository.getCurrentUser();

    Provider.of<VehicleStateManagement>(context, listen: false)
        .getAllVehicles();
    Provider.of<DeviceStateManagement>(context, listen: false).getAllDevices();
    Provider.of<DeviceStateManagement>(context, listen: false)
        .getAssociateDeviceVehicle();

    // DEVICE REST API CALL
    Provider.of<DeviceStateManagement>(context, listen: false).getAllDevices();

    //VEHICLE REST API CALL
    Provider.of<VehicleStateManagement>(context, listen: false)
        .getAllVehicles();
    Provider.of<DriverStateManagement>(context, listen: false)
        .getAssociateVehiclesAndDrive();

    // //DRIVER REST API CALL
    Provider.of<DriverStateManagement>(context, listen: false).getDrivers();

    // //USER REST API CALL
    Provider.of<UserStateManagement>(context, listen: false).getUserList();

    //  GRAPH REST API CALL

    DistanceByDateAndVehicle distanceByDateAndVehicle =
        DistanceByDateAndVehicle(
            inputDate: "2021-02-05T13:05:32Z", orgRefName: data.orgRefName);

    Provider.of<GraphStateManagement>(context, listen: false)
        .fetchFleetStatus(data.orgRefName);
    Provider.of<AnalyticsStateManagement>(context, listen: false)
        .fetchUnderutilizedVehicles(data.orgRefName);
    Provider.of<AnalyticsStateManagement>(context, listen: false)
        .fetchOverSpeedVehicles(data.orgRefName);
    Provider.of<AnalyticsStateManagement>(context, listen: false)
        .fetchUnderSpeedVehicles(data.orgRefName);
    Provider.of<AnalyticsStateManagement>(context, listen: false)
        .fetchLowFuelVehicles(data.orgRefName);

    Provider.of<DistanceByDateAndVehicleStateManagement>(context, listen: false)
        .fetchDistanceByDateAndVehicle(
            jsonEncode(distanceByDateAndVehicle.toJson()));

    //TRIP REST API CALL


    if (data != null) {
      Provider.of<OrganizationStateManagement>(context, listen: false)
          .fetchMyOrganization(data.orgRefName);
    }
  }
}


