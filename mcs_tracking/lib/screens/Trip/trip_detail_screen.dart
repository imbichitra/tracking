import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:mcs_tracking/Models/trip/trip.dart';
import 'package:mcs_tracking/StateManagement/Trip/trip_provider..dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  TripDetailScreen({key: Key, this.trip});

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

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
  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();

  PickResult startLocationPlace;
  PickResult endLocationPlace;
  Position position;
  var tripStateManagent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    tripStateManagent = Provider.of<TripStateManagement>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Driver Details',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: AspectRatio(
        aspectRatio: 4 / 5,
        child: Container(
          margin: EdgeInsets.only(top: 40.0),
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                  child: Column(
                children: [
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
                                apiKey:
                                    "AIzaSyAdWZcIlR6JQCxy3dwN83p385SMjAGsUTs",
                                initialPosition: LatLng(
                                    position.latitude, position.longitude),
                                useCurrentLocation: true,
                                selectInitialPosition: true,
                                onPlacePicked: (result) {
                                  setState(() {
                                    startLocationPlace = result;
                                    print(
                                        'start location   ${startLocationPlace.geometry.location.lat}');
                                    print(startLocationPlace
                                        .geometry.location.lng);
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
                                apiKey:
                                    "AIzaSyAdWZcIlR6JQCxy3dwN83p385SMjAGsUTs",
                                initialPosition: LatLng(
                                    position.latitude, position.longitude),
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
                  RaisedGradientButton(
                    onPressed: () async {
                      try {
                        if (startLocationPlace != null ||
                            _startDateController != null) {
                          Trip trip = Trip(
                              vehicleId: widget.trip.vehicleId,
                              vehicleNumber: widget.trip.vehicleNumber,
                              startLocation: StartLocation(
                                  lat: startLocationPlace.geometry.location.lat,
                                  lng:
                                      startLocationPlace.geometry.location.lng),
                              expectedTripStartTime: _startDateController.text
                                      .toString() +
                                  "T" +
                                  _startTimeController.text.substring(0, 5) +
                                  ":00");
                          await tripStateManagent
                              .updateTrip(jsonEncode(trip.toJson()));
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(tripStateManagent
                                .getCreateTripResponse.message),
                            backgroundColor: Theme.of(context).accentColor,
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      } catch (e) {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Ops !! can not update"),
                          backgroundColor: Theme.of(context).accentColor,
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    },
                    child: Text("Save"),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  //returnType : void
  //name : getCurrentPosition
  //parameters : None
  //description : Getting the current position using i.e current position latitude &
  void getCurrentPosition() async {
    position = await _getStartLocationLatLng();
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
      scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Location services are disabled.")));
      return Future.error("Location service are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              "Location permissions are permanently denied, we cannot request permissions.")));
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        scaffoldKey.currentState.showSnackBar(
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
