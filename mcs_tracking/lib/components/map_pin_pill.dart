import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/pinPillModel.dart';

class MapPinPillComponent extends StatefulWidget {
  double pinPillPosition;
  PinInformation currentlySelectedPin;

  MapPinPillComponent({ this.pinPillPosition, this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {

  @override
  Widget build(BuildContext context) {

    return AnimatedPositioned(
        bottom: widget.pinPillPosition,
        right: 0,
        left: 0,
        duration: Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(20),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
                ]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   width: 50,
                  //   margin: EdgeInsets.only(left: 10),
                  //   child: ClipOval(child: Image.asset("images/car1.png", fit: BoxFit.cover )),
                  // ),
                  Expanded(
                    child: Container(
                      // color: Colors.blueAccent,
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: Text(widget.currentlySelectedPin.vehicleNumber, style: TextStyle(color: Colors.blue))),
                          SizedBox(height: 5,),
                          Expanded(child: Text('Driver Name: ${widget.currentlySelectedPin.drivername}', style: TextStyle(fontSize: 12, color: Colors.blueAccent.shade50))),
                          SizedBox(height: 5,),
                          Expanded(child: Text('Device Imei: ${widget.currentlySelectedPin.deviceImei}', style: TextStyle(fontSize: 12, color: Colors.blueAccent.shade50))),
                          SizedBox(height: 5,),
                          Expanded(child: Text('Last Time: ${widget.currentlySelectedPin.dateTime}', style: TextStyle(fontSize: 12, color: Colors.blueAccent.shade50))),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(15),
                  //   child: Image.asset(widget.currentlySelectedPin.pinPath, width: 50, height: 50),
                  // )
                ],
              ),
            ),
          ),
        );
  }

}