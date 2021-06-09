import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcs_tracking/Models/driver/driver.dart';
import 'package:mcs_tracking/StateManagement/Driver/driver_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:provider/provider.dart';

class DriverDetailView extends StatefulWidget {
//  final Map data;
  final Driver data;

  DriverDetailView({this.data});

  @override
  _DriverDetailViewState createState() => _DriverDetailViewState();
}

class _DriverDetailViewState extends State<DriverDetailView> {
  GlobalKey<FormState> _formkey = GlobalKey();
  bool _autoValidate = false;

  String _buttonTitle = 'Update';
  bool _isActivate = true;

  String driverName;
  String driverContactNumber;
  String driverWhtsAppNumber;
  String licenseNumber;
  int id;

  final key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.data.driverId;
    driverName = widget.data.driverName;
    driverContactNumber = widget.data.contactNumber;
    driverWhtsAppNumber = widget.data.whatsappnumber;
    licenseNumber = widget.data.drivingLicence;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      key: key,
      appBar: AppBar(
        title: Text(
          'Driver Information',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: _getFormContents(),
          ),
        ),
      ),
    );
  }

  Widget _getFormContents() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Container(
            child: TextFormField(
              // enabled: _isActivate,
              autovalidate: _autoValidate,
              initialValue: driverName,
              validator: (value) =>
                  value.length == 0 ? "Required field can not be empty" : null,
              onChanged: (value) {
                driverName = value;
              },
              style: Theme.of(context).textTheme.subtitle1,
              decoration: InputDecoration(
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                labelStyle: Theme.of(context).textTheme.headline6,
                labelText: 'Driver Name',
                isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              autovalidate: _autoValidate,
              initialValue: driverContactNumber,
              validator: (value) {
                if (!(value.length == 10)) {
                  return "Contact number must contain 10 digits";
                }
                if (num.tryParse(value) == null) {
                  return "Should contain number";
                }
                return null;
              },
              onChanged: (value) => driverContactNumber = value,
              style: Theme.of(context).textTheme.subtitle1,
              decoration: InputDecoration(
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                labelStyle: Theme.of(context).textTheme.headline6,
                labelText: 'Driver Contact Number',
                isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              autovalidate: _autoValidate,
              initialValue: licenseNumber,
              validator: (value) {
                String regex = "^(([A-Z]{2}[0-9]{2})" +
                    "( )|([A-Z]{2}-[0-9]" +
                    "{2}))((19|20)[0-9]" +
                    "[0-9])[0-9]{7}\$";
                if (!(value.length == 16)) {
                  return "license number must be of 16 digits";
                }
                if (RegExp(regex).hasMatch(value) == false) {
                  return "Not a valid license number";
                } else {
                  return null;
                }
              },
              onChanged: (value) => licenseNumber = value,
              style: Theme.of(context).textTheme.subtitle1,
              decoration: InputDecoration(
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                labelStyle: Theme.of(context).textTheme.headline6,
                labelText: 'Driver License Number',
                isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              autovalidate: _autoValidate,
              initialValue: driverWhtsAppNumber,
              validator: (value) {
                if (!(value.length == 10)) {
                  return "WhatsApp number must contain 10 digits";
                }
                if (num.tryParse(value) == null) {
                  return "Should contain number";
                }
                return null;
              },
              onChanged: (value) => driverWhtsAppNumber = value,
              style: Theme.of(context).textTheme.subtitle1,
              decoration: InputDecoration(
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                labelStyle: Theme.of(context).textTheme.headline6,
                labelText: 'Driver WhatsApp Number',
                isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedGradientButton(
            child: Text(_buttonTitle),
            onPressed: () {
              updateDriver();
            },
            gradient: buttonColor,
          ),
        ],
      ),
    );
  }

  void updateDriver() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Map<String, dynamic> driver = {
        "driverId": id,
        "driverName": driverName,
        "contactNumber": driverContactNumber,
        "whatsappnumber": driverWhtsAppNumber,
        "drivingLicence": licenseNumber
      };

    int statusCode =
        await Provider.of<DriverStateManagement>(context, listen: false)
            .updateDriver(jsonEncode(driver));
    
        if (statusCode == 200) {
      Provider.of<DriverStateManagement>(context, listen: false).getDrivers();
      key.currentState.showSnackBar(SnackBar(
        content: Text(
          "successfully updated",
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).accentColor,
      ));
    } else {
      key.currentState.showSnackBar(SnackBar(
        content: Text(
          "Ops !! can not update",
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).accentColor,
      ));
    }

    }else{
      key.currentState.showSnackBar(SnackBar(
        content: Text(
          "Required field can not be empty",
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).accentColor,
      ));
    }

    


    /*
    driverController.updateDrivers(driverName, driverContactNumber, driverWhtsAppNumber, licenseNumber, id, accessGlobalToken).then((value) {
      if(value == 200){
        key.currentState.showSnackBar(SnackBar(
          content:Text("successfully updated"),
          backgroundColor: Colors.blueAccent,

        ));
      }else{
        key.currentState.showSnackBar(SnackBar(
          content:Text("Oops! con not update"),
          backgroundColor: Colors.blueAccent,

        ));
      }
      }).catchError((e)=>print(e));
*/
  }
}
