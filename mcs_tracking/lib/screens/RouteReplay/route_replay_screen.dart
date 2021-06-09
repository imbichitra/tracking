import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mcs_tracking/Models/graph/routeReplay.dart';
import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/StateManagement/Graph/route_replay_provider.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:provider/provider.dart';

class RouteReplayScreen extends StatefulWidget {
  @override
  _RouteReplayScreenState createState() => _RouteReplayScreenState();
}

class _RouteReplayScreenState extends State<RouteReplayScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  Map<String, Polyline> polylines;

  final Set<Polyline> _polyline = {};
  final Set<Marker> _markers = {};

  GoogleMapController controller;

  bool isloading = false;

  String fromDateString,
      fromTimeString,
      toDateString,
      toTimeString,
      hour,
      minute,
      time;

  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _toDateController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toTimeController = TextEditingController();
  TextEditingController _fromTimeController = TextEditingController();

  double height, width;

  String dropdownValue;

  Position currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<LatLng> latlngSegment = List();
  LatLng source;
  LatLng destination;

  List<LatLng> latlngSegment1 = List();
  List<LatLng> latlngSegment2 = List();
  static LatLng _lat1 = LatLng(13.035606, 77.562381);
  static LatLng _lat2 = LatLng(13.070632, 77.693071);
  static LatLng _lat3 = LatLng(12.970387, 77.693621);
  static LatLng _lat4 = LatLng(12.858433, 77.575691);
  static LatLng _lat5 = LatLng(12.948029, 77.472936);
  static LatLng _lat6 = LatLng(13.069280, 77.455844);
  LatLng _lastMapPosition = _lat1;

  Cap roundCap = Cap.roundCap;

  BitmapDescriptor bitmapDescriptor;

  String containerText = "Pick vehicle number to see route replay";

  @override
  void initState() {
    super.initState();
    getCurrentLatLng();

    bitmapDescriptor = BitmapDescriptor.defaultMarker;
    //line segment 1
    latlngSegment1.add(_lat1);
    latlngSegment1.add(_lat2);
    latlngSegment1.add(_lat3);
    latlngSegment1.add(_lat4);

    //line segment 2
    latlngSegment2.add(_lat4);
    latlngSegment2.add(_lat5);
    latlngSegment2.add(_lat6);
    latlngSegment2.add(_lat1);
  }

  void getCurrentLatLng() async {
    currentPosition = await _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Route Replay',
          style: Theme
              .of(context)
              .textTheme
              .headline3,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Card(
                  elevation: 15.0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0),
                              width: width / 2.5,
                              height: height / 15,
                              alignment: Alignment.center,
                              // decoration:
                              //     BoxDecoration(color: Colors.grey[200]),
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                      context, fromDate, _fromDateController);
                                },
                                child: Container(
                                  child: TextFormField(
                                    controller: _fromDateController,
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline6,
                                    onSaved: (value) {
                                      fromDateString = value;
                                      // print(startDateString);
                                    },
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "From Date",
                                      // labelText: 'Time',
                                      // contentPadding:
                                      //     EdgeInsets.only(top: 5)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0),
                              width: width / 2.5,
                              height: height / 15,
                              alignment: Alignment.center,
                              // decoration:
                              //     BoxDecoration(color: Colors.grey[200]),
                              child: InkWell(
                                onTap: () {
                                  selectTime(
                                      context, startTime, _fromTimeController);
                                },
                                child: Container(
                                  child: TextFormField(
                                    controller: _fromTimeController,
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline6,
                                    onSaved: (value) {
                                      fromTimeString = value;
                                      print(fromDateString);
                                    },
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "From Time",
                                      // labelText: 'Time',
                                      // contentPadding:
                                      //     EdgeInsets.only(top: 5)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0),
                              width: width / 2.5,
                              height: height / 15,
                              alignment: Alignment.center,
                              // decoration:
                              //     BoxDecoration(color: Colors.grey[200]),
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                      context, toDate, _toDateController);
                                },
                                child: Container(
                                  child: TextFormField(
                                    controller: _toDateController,
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline6,
                                    onSaved: (value) {
                                      toDateString = value;
                                      // print(endDateString);
                                    },
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "To Date",
                                      // labelText: 'Time',
                                      // contentPadding:
                                      //     EdgeInsets.only(top: 5)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0),
                              width: width / 2.5,
                              height: height / 15,
                              alignment: Alignment.center,
                              // decoration:
                              //     BoxDecoration(color: Colors.grey[200]),
                              child: InkWell(
                                onTap: () {
                                  selectTime(
                                      context, endTime, _toTimeController);
                                },
                                child: Container(
                                  child: TextFormField(
                                    controller: _toTimeController,
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline6,
                                    onSaved: (value) {
                                      toTimeString = value;
                                      // print(endTimeString);
                                    },
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "To Time",
                                      // labelText: 'Time',
                                      // contentPadding:
                                      //     EdgeInsets.only(top: 5)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 40.0, right: 50.0),
                        // height: 60.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Consumer<VehicleStateManagement>(
                                builder: (BuildContext context,
                                    final VehicleStateManagement
                                    vehStateManagement,
                                    final Widget child,) {
                                  return DropdownButton<String>(
                                    isExpanded: true,
                                    // isDense: true,
                                    value: dropdownValue,
                                    hint: Container(
                                      // padding: EdgeInsets.symmetric(horizontal:30.0, vertical:20.0),
                                        child: Text(
                                          "Select Vehicle",
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .headline6,
                                        )),
                                    icon: Icon(Icons.arrow_downward),
                                    items: vehStateManagement.getVehicles
                                        ?.map<DropdownMenuItem<String>>(
                                            (Vehicle vehicle) {
                                          return DropdownMenuItem<String>(
                                              child: Container(
                                                child: Text(
                                                  vehicle.vehicleRegNumber
                                                      .toString(),
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                      fontFamily: "Roboto"),
                                                ),
                                              ),
                                              value: vehicle.vehicleRegNumber
                                                  .toString());
                                        })?.toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<RouteReplayStateManagement>(builder:
                          (BuildContext context, routeStateManagement, _) {
                        return Container(
                          padding: EdgeInsets.only(left: 40.0, right: 50.0),
                          child: MaterialButton(
                            child: Text(
                              "show",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle1,
                            ),
                            onPressed: () async {
                              if (dropdownValue == null ||
                                  _fromDateController.text == null || _fromTimeController.text == null || _toDateController.text == null || _toTimeController.text == null) {
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Please enter all the values",style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 12.0,color: Colors.white)),
                                        backgroundColor: Theme.of(context).accentColor,
                                        behavior: SnackBarBehavior.floating,
                                      )
                                    );
                              } else {
                                try {
                                  RouteReplay routeReplay = RouteReplay(
                                      vehicleNumber: dropdownValue,
                                      startDateTime:
                                      _fromDateController.text.toString() +
                                          "T" +
                                          _fromTimeController.text
                                              .substring(0, 5) +
                                          ":00",
                                      endDateTime: _toDateController.text
                                          .toString() +
                                          "T" +
                                          _toTimeController.text.substring(
                                              0, 5) +
                                          ":00");

                                  await routeStateManagement
                                      .fetchRouteReplayData(
                                      jsonEncode(routeReplay.toJson()));

                                  if (routeStateManagement.getRouteReplayData
                                      ?.data?.locationlist?.length ==
                                      0) {
                                    setState(() {
                                      containerText = "No data";
                                    });
                                    return;
                                  }
                                  getPolyLinesData(routeStateManagement
                                      .getRouteReplayData.data.locationlist);
                                } catch (e) {
                                  print(e);
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Sorry !! There is some problem",style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 12.0,color: Colors.white)),
                                        backgroundColor: Theme.of(context).accentColor,
                                        behavior: SnackBarBehavior.floating,
                                      )
                                  );
                                }
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            isloading
                ? Expanded(
              flex: 2,
              child: Container(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(20.296059, 85.824539), zoom: 13.0),
                  polylines: _polyline,
                ),
              ),
            )
                : Expanded(
              flex: 2,
              child: Container(
                child: Center(
                  child: Text(
                    "$containerText",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 15.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //returnType : Future<Null>
//name : selectDate
//parameters : BuildContext context,DateTime initialDate,TextEditingController textEditingController
//description : Getting the Date
  Future<Null> selectDate(BuildContext context, DateTime initialDate,
      TextEditingController textEditingController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));

    if (picked != null) {
      setState(() {
        initialDate = picked;
        // formValidateVariable = initialDate.toIso8601String();
        textEditingController.text =
            initialDate.toIso8601String().substring(0, 10);
      });
    }
  }

//returnType : Future<Null>
//name : selectTime
//parameters : BuildContext context, TimeOfDay timeOfDay,TextEditingController timeController
//description : Getting the Date
  Future<Null> selectTime(BuildContext context, TimeOfDay timeOfDay,
      TextEditingController timeController) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );
    if (picked != null)
      setState(() {
        timeOfDay = picked;
        print(timeOfDay);
        hour = timeOfDay.hour.toString();
        minute = timeOfDay.minute.toString();
        time = hour + ' : ' + minute;
        timeController.text = time;
        timeController.text = formatDate(
            DateTime(2019, 08, 1, timeOfDay.hour, timeOfDay.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;

      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(source.toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: source,
        infoWindow: InfoWindow(
          title: 'Awesome Polyline tutorial',
          snippet: 'This is a snippet',
        ),
      ));

      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        //latlng is List<LatLng>
        points: latlngSegment,
        width: 8,
        startCap: roundCap,
        endCap: Cap.buttCap,
        color: Colors.blue,
      ));

      //different sections of polyline can have different colors
      // _polyline.add(Polyline(
      //   polylineId: PolylineId('line2'),
      //   visible: true,
      //   //latlng is List<LatLng>
      //   points: latlngSegment2,
      //   width: 2,
      //   color: Colors.red,
      // ));
    });
  }

  void getPolyLinesData(List<Locationlist> dataList) {
    latlngSegment.clear();
    for (int i = 0; i < dataList.length; i++) {
      latlngSegment.add(LatLng(dataList[i].lat, dataList[i].lng));
    }
    source = latlngSegment.first;
    destination = latlngSegment.last;
    setState(() {
      isloading = true;
    });
  }
}
