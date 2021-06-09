import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcs_tracking/StateManagement/Device/device_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/Models/device/device.dart';
import 'package:mcs_tracking/screens/Device/tracker_list_sreen.dart';
import 'package:provider/provider.dart';

class TrackerDetailView extends StatefulWidget {
  final Device data;

  TrackerDetailView({this.data});

  @override
  _TrackerDetailViewState createState() => _TrackerDetailViewState();
}

class _TrackerDetailViewState extends State<TrackerDetailView> {
  GlobalKey<FormState> _formkey = GlobalKey();
  final key = GlobalKey<ScaffoldState>();

  String _trackerImeiNo;
  String _trackerModelName;
  bool isLoading = true;
  int id;

  var tokenObj;

  bool autoValidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  void setData(){
    _trackerImeiNo = widget.data.imeiNumber;
    _trackerModelName = widget.data.model;
    id = widget.data.deviceId;
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: key,
      appBar: AppBar(
        title: Text('Tracker Information',style: Theme.of(context).textTheme.headline3,),
        centerTitle: true,
        elevation: 0,
        
      ),
      body: isLoading? Loading():Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            autovalidate: autoValidate,
            child: _getFormContents(),
          ),
        ),
      ),
    );
  }

  Widget _getFormContents() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          Container(
            child: TextFormField(
              initialValue: _trackerImeiNo,
              onChanged: (value)=> _trackerImeiNo = value,
              validator: (value){
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
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'IMEI Number',
                  isDense: true,
                  contentPadding: EdgeInsets.all(12)),
            ),
          ),

          SizedBox(
            height: 12,
          ),
          Container(
            child: TextFormField(
              initialValue: _trackerModelName,
              validator: null,
              onChanged: (value)=> _trackerModelName = value,
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Model Name',
                  isDense: true,
                  contentPadding: EdgeInsets.all(12)),
            ),
          ),
          SizedBox(
            height: 30,
          ),

            RaisedGradientButton(
              child: Text("Update",style: Theme.of(context).textTheme.subtitle1.apply(color:Colors.white),),
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  _formkey.currentState.save();
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  Map<String, dynamic> object = {
                    "deviceid": id,
                    "imeiNumber": _trackerImeiNo,
                    "modelType": _trackerModelName
                  };
                  int statusCode = await Provider.of<DeviceStateManagement>(
                      context, listen: false).updateDevice(jsonEncode(object));

                  if (statusCode == 200) {
                    Provider.of<DeviceStateManagement>(context, listen: false)
                        .getAllDevices();
                    key.currentState.showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme
                          .of(context)
                          .accentColor,
                      content: Text(
                        "Successfully updated", textAlign: TextAlign.center,),
                    ));
                  } else {
                    key.currentState.showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme
                          .of(context)
                          .accentColor,
                      content: Text(
                        "Opps!! can not update", textAlign: TextAlign.center,),
                    ));
                  }
                }else{
                  setState(() {
                    autoValidate = true;
                  });
                }

              },
              gradient: buttonColor,
            ),

        ],
      ),
    );
  }

//  void deleteData(){
//    trackerController
//    .deleteTracker(accessGlobalToken,widget.data["deviceId"])
//    .then((value){
//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TrackerList()));
//    })
//    .catchError((e)=>print(e));
//  }


}
