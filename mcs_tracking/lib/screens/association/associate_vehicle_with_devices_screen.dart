import 'dart:async';
import 'dart:convert';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/associateDevice.dart';


import 'package:mcs_tracking/constant.dart';

import 'package:mcs_tracking/global.dart';
import 'package:mcs_tracking/loading.dart';

//Models
import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/Models/device/device.dart';

//Providers
import 'package:provider/provider.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/Device/device_provider.dart';



class AssociateVehicleWithDeviceScreen extends StatefulWidget {
  @override
  _AssociateVehicleWithDeviceScreenState createState() => _AssociateVehicleWithDeviceScreenState();
}

class _AssociateVehicleWithDeviceScreenState extends State<AssociateVehicleWithDeviceScreen> {

  List<Vehicle> vehiclesList;
  List<Device> vechileDevicesLink;
  List<Device> devicesList;

  var tokenObj;

  final key = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  int vehicleIndex;
  int deviceIndex;


  List<Device> searchingVehicle= [];

  Future<List<Device>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    if (search == 'empty') return [];
    if (search == 'error') throw Error();
    setState(() {
      /*filteredVehicle = vehicle
          .where((v) =>
              (v.deviceIMEI.contains(search)) || v.vehicleNo.contains(search))
          .toList();*/
      searchingVehicle = vechileDevicesLink
          .where((element) =>
              (element.vehicle.vehicleRegNumber.toString().contains(search) ||
                  element.imeiNumber.contains(search)))
          .toList();
    });
      return searchingVehicle;
//    return List.generate(searchingVehicle.length, (index) {
//      return AssociateDevice(
//        searchingVehicle[index]["vehicleNumber"],
//        searchingVehicle[index]["imeiNumber"],
//      );
//    });
  }

  @override
  void initState() {
    super.initState();

//    getVehicleList();
//    getAssociateVehicles();
//    getDevices();
  }

  void getData(){
    vehiclesList = Provider.of<VehicleStateManagement>(context,listen: false).getVehicles;
    devicesList = Provider.of<DeviceStateManagement>(context,listen: false).getDevices;
    vechileDevicesLink = Provider.of<DeviceStateManagement>(context,listen: false).getDeviceVehicleAssociationList;
  }
/*
  void getVehicleList() {
    var list;
    list = vehicleController.getVehicles(accessGlobalToken);
    list.then((value) {
      setState(() {
        vehiclesList = value;
      });
    }).catchError((err) => print(err));
  }

  void getDevices() {
    trackerController = TrackerController();
    trackerController.getTracker(accessGlobalToken).then((devices) {
      devicesList = devices;
      setState(() {
        isLoading = false;
      });
    }).catchError((err) => print(err));
  }

  void getAssociateVehicles() {
    vehicleController.getAssociateVehicle(accessGlobalToken).then((value) {
      setState(() {
        vechileDevicesLink = value;
        searchingVehicle = value;
      });

      print("----------------->");
      print(vechileDevicesLink);
    }).catchError((e) => print(e));
  }
  
 */

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    getData();
    return Provider.of<DeviceStateManagement>(context).getDeviceVehicleAssociationList.length>=0?
        Scaffold(
            key: key,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('Associate Vehicle with Devices',
                  style: Theme.of(context).textTheme.headline3),
              elevation: 0,
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: associateSearchWidget(),
                  ),
                  Expanded(
                    // height: MediaQuery.of(context).size.height*.24,
                    child: Container(
                      // color:Colors.blueAccent,
                      child: Column(
                        children: [
                          Flexible(child: customDropdownFormVehicleNo()),
                          Flexible(child: customDropdownFormIMEI()),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: RaisedGradientButton(
                                child: Text('Save',style:Theme.of(context).textTheme.subtitle1.apply(color:Colors.white)),
                                onPressed: () {
                                  postAssociateVehicle();
                                },
                                gradient: buttonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ) : Loading();
  }

  void postAssociateVehicle() async{
    if (vehicleIndex == null || deviceIndex == null) {
      key.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).accentColor,
          content: Text("No value selected",textAlign: TextAlign.center)));
    } else {
      Map<String,dynamic> object ={
        "vehicleid":vehicleIndex,
        "deviceid":deviceIndex
      };

      
      int status = await Provider.of<VehicleStateManagement>(context,listen: false).associateVehicleDevice(jsonEncode(object));
      if(status == 201){
        Provider.of<DeviceStateManagement>(context,listen: false).getAssociateDeviceVehicle();
        setState(() {
          vechileDevicesLink = Provider.of<DeviceStateManagement>(context,listen: false).getDeviceVehicleAssociationList;
        });
        key.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).accentColor,
          content: Text("Vehicle Associated Successfully",textAlign: TextAlign.center),
        ));
      }else{
        key.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).accentColor,
          content: Text("Ops!! can not associate",textAlign: TextAlign.center,),
        ));
      }

      /*
      vehicleController
          .postAssociateVehicle(vehicleIndex, deviceIndex, accessGlobalToken)
          .then((value) {
//        print(value);
        key.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.blueAccent, content: Text("Associated")));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AssociateWithDevices()));
      }).catchError((e) => print(e));

       */
    }
  }

  Widget associateSearchWidget() {
    return SearchBar<Device>(
      onSearch: search,
      onItemFound: (Device vehicleObj, int index) {
        String vehicleNumber = vehicleObj.vehicle.vehicleRegNumber=="null"?" ":vehicleObj.vehicle.vehicleRegNumber.toString();
        return Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Vehicle Number : " + vehicleNumber,
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(
                  height: 10,
                ),
                Text("Imei Number : " + vehicleObj.imeiNumber,
                    style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          ),
        );
      },
      cancellationWidget: Text(
        'Okay',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      debounceDuration: Duration(milliseconds: 800),
      loader: Center(
        child: Text('loading...',style: Theme.of(context).textTheme.subtitle1,),
      ),
      placeHolder: Center(
        child: Container(
          child: ListView.builder(
            itemCount:
                vechileDevicesLink == null ? 0 : vechileDevicesLink.length,
            itemBuilder: (context, index) => Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Vehicle Number : " +
                            vechileDevicesLink[index].vehicle.vehicleRegNumber
                                .toString() ?? "na",
                        style: Theme.of(context).textTheme.subtitle1),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Imei Number : " +
                            vechileDevicesLink[index].imeiNumber?? "na",
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onError: (error) {
        return Center(
          child: Text('Error occured : $error'),
        );
      },
      emptyWidget: Center(
        child: Text('Empty'),
      ),
    );
  }

  Widget customDropdownFormVehicleNo() {
    String dropdownValue;
    return FormField(builder: (FormFieldState state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
                  ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text('Vehicle Number',
                      style: Theme.of(context).textTheme.subtitle1),
                  value: dropdownValue,
                  items: vehiclesList.map((value) {
                    return DropdownMenuItem(
                      value: value.vehicleRegNumber,
                      child: Text(value.vehicleRegNumber.toString(),
                          style: Theme.of(context).textTheme.subtitle1),
                    );
                  }).toList(),
                  onChanged: ((dynamic newValue) {
                    state.didChange(newValue);
                    dropdownValue = newValue;
                    for (Vehicle i in vehiclesList) {
                      if (i.vehicleRegNumber == newValue) {
                        vehicleIndex = i.vehicleId;
                      }
                    }
                    print(vehicleIndex);
                  }),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget customDropdownFormIMEI() {
    String dropdownValue1;
    return FormField(builder: (FormFieldState state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text('Device IMEI No.',
                      style: Theme.of(context).textTheme.subtitle1),
                  value: dropdownValue1,
                  items: devicesList.map((value) {
                    return DropdownMenuItem(
                      value: value.imeiNumber,
                      child: Text(value.imeiNumber.toString(),style: Theme.of(context).textTheme.subtitle1),
                    );
                  }).toList(),
                  onChanged: ((dynamic newValue) {
                    state.didChange(newValue);
                    dropdownValue1 = newValue;
                    for (var i in devicesList) {
                      if (i.imeiNumber == newValue) {
                        deviceIndex = i.deviceId;
                      }
                    }
                    print(deviceIndex);
                  }),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class DropdownFormField extends StatefulWidget {
  BuildContext context;
  final String hint;
  dynamic value;
  final List<dynamic> items;
  final Function onChanged;
  final Function validator;
  final bool autovalidate;
  final Function onSaved;
  dynamic initialValue;
  final theme;
  final TextStyle textStyle;

  DropdownFormField({
    this.hint,
    dynamic value,
    this.items,
    this.onChanged,
    this.autovalidate,
    this.validator,
    dynamic initialValue,
    this.theme,
    this.textStyle,
    this.onSaved,
  }) {
    this.value = items.where((i) => i == value).length > 0 ? value : null;
    this.initialValue =
        items.where((i) => i == value).length > 0 ? value : null;
  }

  @override
  State<StatefulWidget> createState() {
    return _DropdownFormField();
  }
}

class _DropdownFormField extends State<DropdownFormField> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: widget.initialValue,
      onSaved: (val) => (dynamic newValue) => widget.onSaved(newValue),
      autovalidate: widget.autovalidate,
      validator: widget.validator,
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonHideUnderline(
              child: Theme(
                data: Theme.of(context).copyWith(
                    brightness: widget.theme == 'dark'
                        ? Brightness.dark
                        : Brightness.light,
                    canvasColor:
                        widget.theme == 'dark' ? Colors.black : Colors.white),
                child: DropdownButton(
                  hint: Text(widget.hint,
                      style: Theme.of(context).textTheme.subtitle1),
                  style: Theme.of(context).textTheme.subtitle1,
                  value: widget.value,
                  isDense: true,
                  elevation: 24,
                  isExpanded: true,
                  onChanged: (dynamic newValue) {
                    state.didChange(newValue);
                    widget.onChanged(newValue);
                  },
                  items: widget.items.map((dynamic value) {
                    return DropdownMenuItem(
                      value: value['id'].toString(),
                      child: Text(value['name'],
                          style: Theme.of(context).textTheme.subtitle1),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 2.0),
            state.hasError
                ? Text(
                    state.hasError ? state.errorText : '',
                    style: TextStyle(
                        color: Colors.redAccent.shade700, fontSize: 12.0),
                  )
                : SizedBox(height: 0)
          ],
        );
      },
    );
  }
}
