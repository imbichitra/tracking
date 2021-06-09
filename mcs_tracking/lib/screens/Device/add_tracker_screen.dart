import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/device/device.dart';
import 'package:mcs_tracking/StateManagement/Device/device_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/screens/Device/tracker_list_sreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode _trackerIdFocusNode = FocusNode();

  bool _autoValidate = false;
  List<String> models = ['3G', '4G', 'NBIOT'];

  String trackerId;
  String dropDownValue;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title:
            Text('Add Tracker', style: Theme.of(context).textTheme.headline3),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100.0),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: _getFormContents(),
          ),
        ),
      ),
    );
  }

  Widget _getFormContents() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Column(
        children: [
          TextFormField(
            focusNode: _trackerIdFocusNode,
            onSaved: (value) => trackerId = value,
            validator: (value) {
              if (value.length == 0) {
                return "Required field can not be empty";
              }
              if (num.tryParse(value) == null) {
                return "Should contain digits";
              }
              if (value.length != 15) {
                return "Imei number should be 15 digits";
              }
              return null;
            },
            style: Theme.of(context).textTheme.headline6,
            decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.subtitle1,
                labelText: 'Tracker IMEI Number',
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
            height: 30,
          ),
          RaisedGradientButton(
            child: Text('Add Device',
                style: Theme.of(context).textTheme.headline6.apply(
                      color: Colors.white,
                    )),
            onPressed: () {
              submit();
            },
          )
        ],
      ),
    );
  }

  void submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      postData();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void postData() async {
    Map<String, dynamic> device = {
      "imeiNumber": trackerId,
      "modelType": dropDownValue
    };

    Device deviceObj = Device(imeiNumber: trackerId, modelType: dropDownValue);
    Map<String, dynamic> object = deviceObj.toJson();
    int status =
        await Provider.of<DeviceStateManagement>(context, listen: false)
            .addDevice(jsonEncode(object));
    print(status);
    if (status == 200) {
      Provider.of<DeviceStateManagement>(context, listen: false)
          .getAllDevices();
      showCustomSnackbar("Success");
      Future.delayed(Duration(seconds: 10));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DeviceListScreen()));
    }
    if (status == 409) {
      showCustomSnackbar("Device is already exist!! Please try with new one");
    } else {
      showCustomSnackbar("Oops!! can not add device");
    }
  }

  void showCustomSnackbar(String message) {
    key.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget myDropDown() {
    return Container(
      height: 45.0,
      decoration: BoxDecoration(
        // border: Border.all(width: 0.7, color: Colors.grey[700]),
        // color: Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      // padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      width: 400,
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropDownValue,
        hint: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Select Model',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            )),
        icon: Icon(
          Icons.arrow_downward,
          size: 30,
        ),
        iconSize: 10,
        elevation: 16,
        style: Theme.of(context).textTheme.headline6,
        underline: Container(
          height: 1,
          color: Colors.grey[500],
        ),
        onChanged: (String newValue) {
          setState(() {
            dropDownValue = newValue;
          });
        },
        items: models.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
