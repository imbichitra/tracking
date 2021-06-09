import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/trip/trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mcs_tracking/screens/dashboard_screen.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TripMapViewScreen extends StatefulWidget {
  final Trip trip;

  TripMapViewScreen({key: Key, this.trip});

  @override
  _TripMapViewScreenState createState() => _TripMapViewScreenState();
}

class _TripMapViewScreenState extends State<TripMapViewScreen> with SingleTickerProviderStateMixin {

  Completer<GoogleMapController> _controller = Completer();
  StompClient client, stompClient;

  Map result;

  Animation animation;
  double distanceTravelledInPercentage;
  bool delayed,deviated;
  String vehicleNumber;
  double latitude,longitude;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId merkarId;
  BitmapDescriptor pinLocationIcon;

  dynamic onConnect(StompClient client, StompFrame frame) {
    print(widget.trip.vehicleNumber);
    print("##################################################### 2");
    stompClient = client;
    stompClient.subscribe(
        destination: "/topic/${CurrentUserSingleton.getInstance.getCurrentUser.getorgRefName}/trips",
        callback: (StompFrame frame){
          print("##################################################### 3");
          result = jsonDecode(frame.body);
          setState(() {
            delayed = result["delayed"];
            deviated = result["deviated"];
            distanceTravelledInPercentage = result["distanceTravelledInPercentage"].toDouble()/100;
            latitude = result["lat"];
            longitude = result["lng"];
            vehicleNumber = result["vehicleNumber"];
          });

          markers.clear();
          Marker marker = Marker(
            markerId: MarkerId("hello"),
            position: LatLng(result['lat'], result['lng']),
          );
          markers[merkarId] = marker;
          print(result.toString());
        }
    );
  }


  void initSocket() {
    print("##################################################### 1");
    client = StompClient(
        config: StompConfig(
            url: 'ws://45.114.48.150:8084/appendpoint',
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error.toString()))
    );

    client.activate();
  }


  void createMapMarker() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/car_icon.png');
  }

  @override
  void initState() {
    super.initState();
    merkarId = MarkerId(widget.trip.vehicleNumber);
    createMapMarker();
    initSocket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    client.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            FractionallySizedBox (
              alignment: Alignment.topCenter,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(20.296059, 85.824539),
                  zoom: 10,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set<Marker>.of(markers.values)
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 3,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Distance Travelled ",style: Theme.of(context).textTheme.headline3.copyWith(fontSize:14.0 ),),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    width: 100.0,
                                    lineHeight: 14.0,
                                    percent: distanceTravelledInPercentage??0.0,
                                    backgroundColor: Colors.grey,
                                    progressColor: Colors.blue,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("Deviated : ${deviated??"Loading..."}",style: Theme.of(context).textTheme.headline3.copyWith(fontSize:14.0 ),),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Vehicle Number: ${vehicleNumber??"Loading..."}",style: Theme.of(context).textTheme.headline3.copyWith(fontSize:14.0,fontFamily: "Roboto" ),),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text("Delayed : ${delayed?? "Loading..." }",style: Theme.of(context).textTheme.headline3.copyWith(fontSize:14.0 ),),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ),


          ],
        ),
      ),
    );
  }
}