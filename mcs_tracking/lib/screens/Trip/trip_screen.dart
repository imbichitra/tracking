import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/trip/trip.dart';
import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/StateManagement/Trip/trip_provider..dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/screens/Trip/trip_detail_screen.dart';
import 'package:mcs_tracking/screens/Trip/trip_map_view_screen.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../loading.dart';

class TripScreen extends StatefulWidget {
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  LatLng startLoc, endLoc;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime expectedStarTime, expectedEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Container(
                child: Text("Create Trip"),
              )),
              Tab(
                  icon: Container(
                child: Text("Start Trip"),
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StartTripScreen(
              scaffoldKey: _scaffoldKey,
            ),
            ManageTripScreen()
          ],
        ),
      ),
    );
  }
}

class StartTripScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  StartTripScreen({Key key, this.scaffoldKey});

  @override
  _StartTripScreenState createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final formKey = GlobalKey<FormState>();

  String vehicleNumber, orgRefName;
  int vehId;
  Position position;
  var startLocation;
  String startLocationHintText = "Start Location";
  String endLocationHintText = "End Location";
  bool isRecursive = false;
  bool isRounded = false;
  double startLocationLatitude,
      startLocationLongitude,
      endLocationLatitude,
      endLocationLongitude;

  double height, width;

  String startDateString,
      startTimeString,
      endDateString,
      endTimeString,
      hour,
      minute,
      time,
      startFormSavedDateTime,
      endFormSavedDateTime;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  PickResult startLocationPlace;
  PickResult endLocationPlace;

  var tripStateManagent;

  @override
  void initState() {
    super.initState();
    getAllTrip();
    getCurrentPosition();
    orgRefName = CurrentUserSingleton.getInstance.getCurrentUser.orgRefName;
  }

  void getAllTrip() async {
    await Provider.of<TripStateManagement>(context, listen: false).fetchAllTrip(
        CurrentUserSingleton.getInstance.getCurrentUser.orgRefName);
  }

  //returnType : void
  //name : getCurrentPosition
  //parameters : None
  //description : Getting the current position using i.e current position latitude &
  void getCurrentPosition() async {
    position = await _getStartLocationLatLng();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    tripStateManagent = Provider.of<TripStateManagement>(context);

    return Provider.of<VehicleStateManagement>(context).getVehicles.length > 0
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: getFormContents(),
              ),
            ),
          )
        : Loading();
  }

  //returnType : Widget
  //name : getFormContents
  //parameters : None
  //description : Getting the form contents
  Widget getFormContents() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Consumer<VehicleStateManagement>(builder: (
              final BuildContext context,
              final VehicleStateManagement vehStateManagement,
              final Widget child,
            ) {
              return DropdownButtonFormField<String>(
                hint: Text("Select Vehicle"),
                isExpanded: true,
                value: vehicleNumber,
                items: vehStateManagement.getVehicles
                    ?.map<DropdownMenuItem<String>>((Vehicle vehicle) {
                  return DropdownMenuItem<String>(
                      child: Container(
                        child: Text(
                          vehicle.vehicleRegNumber.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontFamily: "Roboto", fontSize: 15.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      value: vehicle.vehicleRegNumber.toString());
                })?.toList(),
                onChanged: (String newValue) {
                  setState(() {
                    vehicleNumber = newValue;
                    vehId = vehStateManagement.getVehicles.indexWhere(
                        (element) => element.vehicleRegNumber == newValue);
                  });
                },
              );
            }),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedGradientButton(
            child: Text(startLocationPlace == null
                ? "Start Location"
                : startLocationPlace.formattedAddress.toString()),
            onPressed: () async {
              // position = await _getStartLocationLatLng();
              showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Start Location"),
                      content: PlacePicker(
                        apiKey: "AIzaSyAdWZcIlR6JQCxy3dwN83p385SMjAGsUTs",
                        initialPosition:
                            LatLng(position.latitude, position.longitude),
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        onPlacePicked: (result) {
                          setState(() {
                            startLocationPlace = result;
                            print(
                                'start location   ${startLocationPlace.geometry.location.lat}');
                            print(startLocationPlace.geometry.location.lng);
                          });
                        },
                      ),
                    );
                  });
            },
          ),
          SizedBox(
            height: 10,
          ),
          RaisedGradientButton(
            child: Text(endLocationPlace == null
                ? "End Location"
                : endLocationPlace.formattedAddress.toString()),
            onPressed: () async {
              // position = await _getStartLocationLatLng();
              showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      title: Text("End Location"),
                      content: PlacePicker(
                        apiKey: "AIzaSyAdWZcIlR6JQCxy3dwN83p385SMjAGsUTs",
                        initialPosition:
                            LatLng(position.latitude, position.longitude),
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        onPlacePicked: (result) {
                          setState(() {
                            print("clicked");
                            endLocationPlace = result;
                            print(endLocationPlace.formattedAddress);
                          });
                        },
                      ),
                    );
                  });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
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
                                  context, startDate, _startDateController);
                            },
                            child: Container(
                              child: TextFormField(
                                controller: _startDateController,
                                enabled: false,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                                onSaved: (value) {
                                  startDateString = value;
                                  // print(startDateString);
                                },
                                decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Start Date",
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
                                  context, startTime, _startTimeController);
                            },
                            child: Container(
                              child: TextFormField(
                                controller: _startTimeController,
                                enabled: false,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                                onSaved: (value) {
                                  startTimeString = value;
                                  print(startDateString);
                                },
                                decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Start Time",
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
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           padding: EdgeInsets.only(top: 15.0),
                //           width: width / 2.5,
                //           height: height / 15,
                //           alignment: Alignment.center,
                //           // decoration:
                //           //     BoxDecoration(color: Colors.grey[200]),
                //           child: InkWell(
                //             onTap: () {
                //               selectDate(context, endDate, _endDateController);
                //             },
                //             child: Container(
                //               child: TextFormField(
                //                 controller: _endDateController,
                //                 enabled: false,
                //                 textAlign: TextAlign.center,
                //                 style: Theme.of(context).textTheme.headline6,
                //                 onSaved: (value) {
                //                   endDateString = value;
                //                   // print(endDateString);
                //                 },
                //                 decoration: InputDecoration(
                //                   disabledBorder: UnderlineInputBorder(
                //                       borderSide: BorderSide.none),
                //                   hintText: "End Date",
                //                   // labelText: 'Time',
                //                   // contentPadding:
                //                   //     EdgeInsets.only(top: 5)
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: Container(
                //           padding: EdgeInsets.only(top: 15.0),
                //           width: width / 2.5,
                //           height: height / 15,
                //           alignment: Alignment.center,
                //           // decoration:
                //           //     BoxDecoration(color: Colors.grey[200]),
                //           child: InkWell(
                //             onTap: () {
                //               selectTime(context, endTime, _endTimeController);
                //             },
                //             child: Container(
                //               child: TextFormField(
                //                 controller: _endTimeController,
                //                 enabled: false,
                //                 textAlign: TextAlign.center,
                //                 style: Theme.of(context).textTheme.headline6,
                //                 onSaved: (value) {
                //                   endTimeString = value;
                //                   // print(endTimeString);
                //                 },
                //                 decoration: InputDecoration(
                //                   disabledBorder: UnderlineInputBorder(
                //                       borderSide: BorderSide.none),
                //                   hintText: "End Time",
                //                   // labelText: 'Time',
                //                   // contentPadding:
                //                   //     EdgeInsets.only(top: 5)
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   child: Container(
                      //     child: CheckboxListTile(
                      //       title: Text("Rounded"),
                      //       value: isRounded,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           isRounded = value;
                      //         });
                      //       },
                      //       controlAffinity: ListTileControlAffinity.leading,
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Container(
                          child: CheckboxListTile(
                            title: Text("Recursive"),
                            value: isRecursive,
                            onChanged: (bool value) {
                              setState(() {
                                isRecursive = value;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          RaisedGradientButton(
            onPressed: () async {
              print(vehicleNumber);
              print(startLocationPlace);
              print(_startDateController.text);
              SystemChannels.textInput.invokeMethod('TextInput.hide');

              try {
                if (vehicleNumber != null ||
                    startLocationPlace != null ||
                    _startDateController.text != null) {

                  Trip trip = Trip(
                      vehicleId: vehId,
                      vehicleNumber: vehicleNumber,
                      isRecurring: isRecursive,
                      orgRefName: orgRefName,
                      startLocation: StartLocation(
                          lat: startLocationPlace.geometry.location.lat,
                          lng: startLocationPlace.geometry.location.lng),
                      endLocation: StartLocation(
                          lat: endLocationPlace.geometry.location.lat,
                          lng: endLocationPlace.geometry.location.lng),
                      expectedTripStartTime:
                          _startDateController.text.toString() +
                              "T" +
                              _startTimeController.text.substring(0, 5) +
                              ":00");
                  await tripStateManagent.createTrip(jsonEncode(trip.toJson()));

                  print("success");
                  widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                    content:
                        Text("Trip Successfully created"),
                    backgroundColor: Theme.of(context).accentColor,
                    behavior: SnackBarBehavior.floating,
                  ));
                } else {
                  widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Required field  can not be empty"),
                    backgroundColor: Theme.of(context).accentColor,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              } catch (e) {
                widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Ops !! there is some problem"),
                  backgroundColor: Theme.of(context).accentColor,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  //returnType : Future<Position>
  //name : getFormContents
  //parameters : None
  //description : Getting the form contents
  Future<Position> _getStartLocationLatLng() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      widget.scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Location services are disabled.")));
      return Future.error("Location service are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      widget.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              "Location permissions are permanently denied, we cannot request permissions.")));
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        widget.scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("Location permissions are denied")));
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
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
//name : selectDate
//parameters : BuildContext context,DateTime initialDate,TextEditingController textEditingController
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
}

class ManageTripScreen extends StatefulWidget {
  @override
  _ManageTripScreenState createState() => _ManageTripScreenState();
}

class _ManageTripScreenState extends State<ManageTripScreen> {
  String orgRefName =
      CurrentUserSingleton.getInstance.getCurrentUser.getorgRefName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<TripStateManagement>(context).getAllTrip.length > 0
        ? Container(
            child: ListView.builder(
                itemCount:
                    Provider.of<TripStateManagement>(context).getAllTrip.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Provider.of<TripStateManagement>(context)
                            .getAllTrip[index]
                            .tripStarted
                        ? Colors.green.shade100
                        : Colors.white,
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.edit,
                          color: Theme.of(context).accentColor,
                          size: 18.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TripDetailScreen(
                                        trip: Provider.of<TripStateManagement>(
                                                context)
                                            .getAllTrip[index],
                                      )));
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripMapViewScreen(
                                    trip: Provider.of<TripStateManagement>(
                                            context)
                                        .getAllTrip[index])));
                      },
                      trailing: !Provider.of<TripStateManagement>(context)
                              .getAllTrip[index]
                              .tripStarted
                          ? ElevatedButton(
                              child: Text("Start"),
                              onPressed: () async {
                                // Calling START TRIP API
                                await Provider.of<TripStateManagement>(context,
                                        listen: false)
                                    .startTrip(
                                        CurrentUserSingleton.getInstance
                                            .getCurrentUser.orgRefName,
                                        Provider.of<TripStateManagement>(
                                                context,
                                                listen: false)
                                            .getAllTrip[index]
                                            .tripId
                                            .toString());

                                // Changing the variable of trip started (locally)
                                Provider.of<TripStateManagement>(context,
                                        listen: false)
                                    .getAllTrip[index]
                                    .tripStarted = true;

                                // Showing snackbar
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      Provider.of<TripStateManagement>(context,
                                              listen: false)
                                          .getTrip
                                          .message),
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  behavior: SnackBarBehavior.floating,
                                ));

                                // Calling the get all trip rest api
                                Provider.of<TripStateManagement>(context,
                                        listen: false)
                                    .fetchAllTrip(orgRefName);
                              },
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              child: Text("End"),
                              onPressed: () async {
                                // Calling END TRIP API
                                await Provider.of<TripStateManagement>(context,
                                        listen: false)
                                    .endTrip(
                                        orgRefName,
                                        Provider.of<TripStateManagement>(
                                                context,
                                                listen: false)
                                            .getAllTrip[index]
                                            .tripId,
                                        Provider.of<TripStateManagement>(
                                                context,
                                                listen: false)
                                            .getAllTrip[index]
                                            .vehicleId);

                                // calling the variable of trip started (locally)
                                Provider.of<TripStateManagement>(context,
                                        listen: false)
                                    .getAllTrip[index]
                                    .tripStarted = false;

                                // Showing snackbar
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      Provider.of<TripStateManagement>(context,
                                              listen: false)
                                          .getTrip
                                          .message),
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  behavior: SnackBarBehavior.floating,
                                ));

                                // Calling the get all trip rest api
                                Provider.of<TripStateManagement>(context,
                                        listen: false)
                                    .fetchAllTrip(orgRefName);
                              },
                            ),
                      title: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vehicle Number : " +
                                  Provider.of<TripStateManagement>(context)
                                      .getAllTrip[index]
                                      .vehicleNumber,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            // Text(
                            //     "Active : " +
                            //         Provider.of<TripStateManagement>(context)
                            //             .getAllTrip[index]
                            //             .active
                            //             .toString(),
                            //     style: Theme.of(context).textTheme.subtitle1),
                            SizedBox(
                              height: 10.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }))
        : Loading();
  }
}
