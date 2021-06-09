import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mcs_tracking/Animation/FadeAnimation.dart';
import 'package:mcs_tracking/Models/token.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/screens/Vehicle/vehicles_list_screen.dart';
import 'package:provider/provider.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  GlobalKey<FormState> _formkey = GlobalKey();
  bool _autoValidate = false;

  RegExp exp =
      RegExp(r'([A-Z]{2,3})-(\d{2,4})\w|([A-Z]{2,3})\d{2}[A-Z]{1,2}\d{1,4}\w');

  List<String> vehicleTypeList = ['BUS', 'TRUCK', 'AMBULANCE', 'CAR'];
  String dropDownValue;

  String vehicleNumber;
  String ownerName;
  String ownerContact;

  Token tokenObj;

  final key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
      key: key,
      appBar: AppBar(
        title: Text(
          'Add Vehicles',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Flexible(
            child: FadeAnimation(
              1.5,
              SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: _getFormContents(context),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// methodName : _getFormContents
  /// description :  Container containing form contents like TrxtFormField, buttons etc
  /// onSuccess : return Container Widget
  /// onFailure :Null
  /// written : Asiczen

  Widget _getFormContents(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Container(
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value.length == 0) {
                  return "Required field can not be empty";
                }
                print(exp.hasMatch(value));
                if (exp.hasMatch(value) == false) {
                  return "Vehicle number is not correct";
                } else {
                  return null;
                }
              },
              onSaved: (value) => vehicleNumber = value,
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Vehicle Number',
                  border: border,
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  isDense: true,
                  contentPadding: EdgeInsets.all(12)),
            ),
            SizedBox(
              height: 12,
            ),
            myDropDown(),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              validator: (value) =>
                  value.length == 0 ? "This is required field" : null,
              onSaved: (value) => ownerName = value,
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Owner Name',
                  border: border,
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  isDense: true,
                  contentPadding: EdgeInsets.all(12)),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              validator: (value) {
                if (!(value.length == 10)) {
                  return "Contact number should be of 10 digits";
                }
                if (num.tryParse(value) == null) {
                  return "Should contain digit";
                }
                return null;
              },
              onSaved: (value) => ownerContact = value,
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Owner Contact Number',
                  border: border,
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  isDense: true,
                  contentPadding: EdgeInsets.all(12)),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedGradientButton(
              child: Text(
                'Add Vehicle',
                style: Theme.of(context).textTheme.headline6.apply(
                      color: Colors.white,
                    ),
              ),
              gradient: buttonColor,
              onPressed: () {
                submit();
              },
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      Map<String, dynamic> vehicle = {
        "vehicleRegNumber": vehicleNumber,
        "vehcleType": dropDownValue,
        "ownerName": ownerName,
        "ownerContact": ownerContact
      };
      int statuscode =
          await Provider.of<VehicleStateManagement>(context, listen: false)
              .createVehicle(jsonEncode(vehicle));
      if (statuscode == 201) {
        customSnackBar("Vehicle added successfully");
        Provider.of<VehicleStateManagement>(context, listen: false)
            .getAllVehicles();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VehicleListScreen()));
      } else if (statuscode == 409) {
        customSnackBar("Vehicle is already exist");
      } else {
        customSnackBar("oops there is some issue!!");
      }

/*

      vehicleController
          .postVehicle(vehicleNumber, dropDownValue, ownerName, ownerContact,
              accessGlobalToken)
          .then((value) {
        if (value == 201) {
          customSnackBar("Vehicle added successfully");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => VehicleList()));
        } else if (value == 409) {
          customSnackBar("Vehicle is already exist");
        } else {
          customSnackBar("oops there is some issue!!");
        }
      }).catchError((e) => print(e));


 */
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Widget myDropDown() {
    return Container(
      height: 50.0,
      width: 400,
      child: DropdownButton<String>(
        hint: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
          "Select one ",
          style: Theme.of(context).textTheme.subtitle1,
        )),
        isExpanded: true,
        value: dropDownValue,
        icon: Icon(
          Icons.arrow_downward,
          size: 30,
        ),
        underline: Container(
          height: 1,
          color: Colors.grey[500],
        ),
        iconSize: 10,
        elevation: 16,
        style: Theme.of(context).textTheme.headline6,
        onChanged: (String newValue) {
          setState(() {
            dropDownValue = newValue;
          });
        },
        items: vehicleTypeList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(padding:EdgeInsets.symmetric(horizontal: 10.0), child: Text(value)),
          );
        }).toList(),
      ),
    );
  }

  void customSnackBar(String message) {
    key.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        "$message",
        textAlign: TextAlign.center,
      ),
    ));
  }
}
