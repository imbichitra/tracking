import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/screens/Vehicle/vehicles_list_screen.dart';
import 'package:provider/provider.dart';

class VehicleDetailView extends StatefulWidget {
  final Vehicle object;

  VehicleDetailView({this.object});

  @override
  _VehicleDetailViewState createState() => _VehicleDetailViewState();
}

class _VehicleDetailViewState extends State<VehicleDetailView> {
  GlobalKey<FormState> _formkey = GlobalKey();
  bool _autoValidate = false;

  String _buttonTitle = 'Update';
  bool _isActivate = true;
  bool _autoFocus = false;

  int vehicleId;
  String vehicleNumber;
  String vehicleType;
  String ownerName;
  String contactNumber;
  OwnerDetails ownerDetails;

  bool isLoading = true;

  final key = GlobalKey<ScaffoldState>();
  bool autoValidate = false;

  RegExp regex = RegExp(r'([A-Z]{2,3})-(\d{2,4})\w|([A-Z]{2,3})\d{2}[A-Z]{1,2}\d{1,4}\w');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
          isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.object.vehicleowner.ownerName);
    vehicleType = widget.object.vehicleType;
    vehicleNumber = widget.object.vehicleRegNumber;
    vehicleId = widget.object.vehicleId;
    ownerDetails = Provider.of<VehicleStateManagement>(context,listen: false).getOwnerDetails;
    ownerName = ownerDetails.ownerName;
    contactNumber = ownerDetails.ownerContactNumber;



    return Scaffold(
      // backgroundColor: backgroundColor,
      key: key,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Vehicle Information',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Loading()
          : Container(
        margin: EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  autovalidate: autoValidate,
                  key: _formkey,
                  child: _getFormContents(),
                ),
              ),
            ),
    );
  }

//  Future<void> delete()async{
//    return showDialog(
//        context: context,
//        builder: (BuildContext context){
//          return AlertDialog(
//            title: Text("Do you want to delte?"),
//            actions: [
//              FlatButton(
//                child: Text('Delete'),
//                onPressed: () {
//                  print(widget.object["vehicleId"]);
//                  vehicleController.deleteVehicle(accessGlobalToken, widget.object["vehicleId"]);
//                  Navigator.of(context).pop();
//                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>VehicleList()));
//                },
//              ),
//              FlatButton(
//                child: Text('Cancel'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        }
//    );
//
//  }

  Widget _getFormContents() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Container(
            child: TextFormField(
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              initialValue: vehicleNumber,
              validator: (value){
                if(regex.hasMatch(value) == false){
                  return "Enter valid vehicle number";
                }

                return null;
              },
              onChanged: (value) {
                vehicleNumber = value;
              },
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Vehicle Number',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              initialValue: vehicleType,
              enabled: false,
              onChanged: (value) {
                vehicleType = value;
              },
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Vehicle Model Type',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              initialValue: ownerName,
              validator: (value){
                if(value.length == 0){
                  return "Owner Name field can not be empty";
                }

                return null;
              },
              onChanged: (value) {
                ownerName = value;
              },
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Owner Name',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              initialValue: contactNumber,
              validator: (value) {
                if (value.length < 10 || value.length > 10) {
                  return "Contact Number must be 10 digits ";
                }
                if (num.tryParse(value) == null) {
                  return "Not a valid number";
                }
                return null;
              },
              onChanged: (value) {
                contactNumber = value;
              },
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Owner Contact Number',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          RaisedGradientButton(
            child: Text(
              _buttonTitle,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .apply(color: Colors.white),
            ),
            onPressed: () {
              edit();
            },
            // gradient: buttonColor,
          ),
        ],
      ),
    );
  }

  void edit() async {
    print("clicked");
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      Map<String, dynamic> mapObject = {
        "vehicleid": widget.object.vehicleId,
        "vehicleRegNumber": vehicleNumber,
        "vehcleType": vehicleType,
        "ownerName": ownerName,
        "ownerContact": contactNumber
      };
      int statusCode = await Provider.of<VehicleStateManagement>(context, listen: false)
          .updateVehicles(jsonEncode(mapObject));
      Provider.of<VehicleStateManagement>(context, listen: false)
          .getAllVehicles();
      if ( statusCode ==
          200) {
        key.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).accentColor,
          content: Text("Updated",textAlign: TextAlign.center,),
        ));
      } else {
        key.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Sorry there is some problem"),
        ));
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
