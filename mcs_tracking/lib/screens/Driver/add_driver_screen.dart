import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcs_tracking/Animation/FadeAnimation.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/screens/Driver/driver_list_screen.dart';
import 'dart:async';
import 'package:mcs_tracking/StateManagement/Driver/driver_provider.dart';
import 'package:mcs_tracking/Models/driver/driver.dart';
import 'package:provider/provider.dart';

class AddDriverScreen extends StatefulWidget {
  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  GlobalKey<FormState> _formkey = GlobalKey();
  bool _autoValidate = false;

  String licenseNumber;
  String driverName;
  String driverContactNumber;
  String whatsAppNumber;

  final key = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: key,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Add Driver Details',
            style: Theme
                .of(context)
                .textTheme
                .headline3,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(children: [
          SizedBox(height: 20),
          Flexible(
            child: FadeAnimation(
              1.5,
              SingleChildScrollView(
                child: Form(
                  autovalidate: _autoValidate,
                  key: _formkey,
                  child: _getFormContents(),
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

  Widget _getFormContents() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) {
              licenseNumber = value;
            },
    validator: (value) {

              String regex = "^(([A-Z]{2}[0-9]{2})" +
                  "( )|([A-Z]{2}-[0-9]" +
                  "{2}))((19|20)[0-9]" +
                  "[0-9])[0-9]{7}\$";
              if (!(value.length == 16)) {
                return "license number must be of 16 digits";
              }
              if(RegExp(regex).hasMatch(value) == false){
                  return "Not a valid license number";
                }
              else {
                return null;
              }


            },


            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .subtitle1,
              labelText: 'License Number',
              border: border,
              enabledBorder: enableBorder,
              focusedBorder: focusedBorder,
              disabledBorder: disableBorder,
              errorBorder: errorBorder,
              isDense: true,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) =>
            value.length == 0 ? "Required field can not be empty" : null,
            onSaved: (value) => driverName = value,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
                labelText: 'Driver Name',
                border: border,
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                isDense: true,
                contentPadding: EdgeInsets.all(12)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (!(value.length == 10)) {
                return "Contact number must contain 10 digits";
              }
              if (num.tryParse(value) == null) {
                return "Should contain number";
              }
              return null;
            },
            onSaved: (value) => driverContactNumber = value,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
                labelText: 'Contact Number',
                border: border,
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                isDense: true,
                contentPadding: EdgeInsets.all(12)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (!(value.length == 10)) {
                return "WhatsApp number must contain 10 digits";
              }
              if (num.tryParse(value) == null) {
                return "Should contain number";
              }
              return null;
            },
            onSaved: (value) => whatsAppNumber = value,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
                labelText: 'WhatsApp Number',
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
            child: Text('Add Driver',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6
                    .apply(
                  color: Colors.white,
                )),
            gradient: buttonColor,
            onPressed: () {
              submit();
            },
          )
        ],
      ),
    );
  }

  void submit() async{

    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Driver driver = Driver(driverName: driverName,
          contactNumber: driverContactNumber,
          whatsappnumber: whatsAppNumber,
          drivingLicence: licenseNumber);

      Map<String,dynamic> data = driver.toJson();
      // print(data);
       int statusCode = await Provider.of<DriverStateManagement>(context,listen: false).addDriver(jsonEncode(data));

       if(statusCode == 201){
         Provider.of<DriverStateManagement>(context,listen: false).getDrivers();
         key.currentState.showSnackBar(SnackBar(
           behavior: SnackBarBehavior.floating,
           backgroundColor: Theme.of(context).accentColor,
           content: Text("Successfully Added",textAlign: TextAlign.center,),
         ));
         Future.delayed(Duration(seconds: (20)));
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DriverListScreen()));
       }else if(statusCode == 409){
         key.currentState.showSnackBar(SnackBar(
           behavior: SnackBarBehavior.floating,
           backgroundColor: Theme.of(context).accentColor,
           content: Text("Driver already exist"),
         ));
       }else{
         key.currentState.showSnackBar(SnackBar(
           behavior: SnackBarBehavior.floating,
           backgroundColor: Theme.of(context).accentColor,
           content: Text("Ops!! can not add driver",textAlign: TextAlign.center),
         ));
       }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }


}
