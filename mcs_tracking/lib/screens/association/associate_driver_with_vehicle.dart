import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

import 'package:mcs_tracking/constant.dart';
import 'dart:async';
import 'package:mcs_tracking/loading.dart';



//Models
import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/Models/driver/driver.dart';


//providers
import 'package:provider/provider.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/Driver/driver_provider.dart';


class AssociateDriverWithVehicleScreen extends StatefulWidget {
  @override
  _AssociateDriverWithVehicleScreenState createState() =>
      _AssociateDriverWithVehicleScreenState();
}

class _AssociateDriverWithVehicleScreenState
    extends State<AssociateDriverWithVehicleScreen> {

  List<Vehicle> vehiclesList;
  List<Driver> driverList;
  List<Driver> vehicleDriverLink;

  final key = GlobalKey<ScaffoldState>();



  bool isLoading = true;
  int vehicleIndex;
  int driverIndex;

  int count = -1;


  @override
  void  initState(){
    super.initState();
    getData();

  }

  void getData(){
     setState(() {
       isLoading = false;
     });
  }








  List<Driver> filteredVehicle = [];

  Future<List<Driver>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    if (search == 'empty') return [];
    if (search == 'error') throw Error();
    setState(() {
      filteredVehicle = vehicleDriverLink.where((element) => (element.driverName).contains(search)).toList();
      // filteredVehicle = vehicleDriverLink
      //     .where((v) =>
      //         (v.vehicles.where((element) => (element.vehicleRegNumber).contains(search)).contains(search)) )
      //     .toList();
    });
    return filteredVehicle;
    // List.generate(filteredVehicle.length, (index) {
    //   return AssociateDriver(
    //     'Vehicle Number : ${filteredVehicle[index].vehicleNo}',
    //     'Device IMEI : ${filteredVehicle[index].driverName}',
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    vehiclesList = Provider.of<VehicleStateManagement>(context).getVehicles;
    vehicleDriverLink = Provider.of<DriverStateManagement>(context).getVehicleDriverAssociationList;
    driverList = Provider.of<DriverStateManagement>(context).getDriverList;


    return Provider.of<DriverStateManagement>(context).getDriverList.length<0?Loading():Scaffold(
      key: key,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Associate Vehicle With Driver',style: Theme.of(context).textTheme.headline3,),
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
                        child:  RaisedGradientButton(
                            child: Text('Save',style: Theme.of(context).textTheme.subtitle1.apply(color:Colors.white),),
                            onPressed: () {
                              postAssociateVehicles();
                            },
                            gradient: buttonColor,
                          
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void postAssociateVehicles()async{
    if(vehicleIndex == null || driverIndex == null){
      key.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).accentColor,
        content: Text("No value  selected",textAlign: TextAlign.center,),
      ));
    }else{
      Map<String,dynamic> object = {
        "vehicleId": vehicleIndex,
        "driverId":driverIndex
      };
      int statusCode = await Provider.of<VehicleStateManagement>(context,listen: false).associateVehicleDriver(jsonEncode(object));

      if(statusCode == 201){
        Provider.of<DriverStateManagement>(context,listen: false).getAssociateVehiclesAndDrive();
        key.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).accentColor,
          content: Text("Driver Associated Successfully",textAlign: TextAlign.center,),
        ));
      }else{
        key.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).accentColor,
          content: Text("Ops!! can not associate",textAlign: TextAlign.center),
        ));
      }

/*
    driverController.postAssociateDriver(accessGlobalToken, vehicleIndex, driverIndex)
    .then((value){
      key.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.blueAccent,
        content: Text("Successfully associated"),
      ));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AssociateDriverWithVehicle()));
    })
    .catchError((e)=>print(e));
*/
    }
  }

  Widget associateSearchWidget() {
    return SearchBar<Driver>(
      onSearch: search,
      onItemFound: (Driver asDriver, int index) {
        return Card(
            child: ListTile(
            title: Text(asDriver.driverName,style: Theme.of(context).textTheme.subtitle1,),
            subtitle: Text(asDriver.vehicles[index].vehicleRegNumber.toString(),style: Theme.of(context).textTheme.subtitle1,),
          ),
        );
      },
      cancellationWidget: Text('Okay',style: Theme.of(context).textTheme.subtitle1,),
      debounceDuration: Duration(milliseconds: 800),
      loader: Center(
        child: Text('loading...',style: Theme.of(context).textTheme.subtitle1,),
      ),
      placeHolder: Center(
        child: Container(
          child: ListView.builder(
            itemCount: vehicleDriverLink.length,
            itemBuilder: (context,index) {
              List vehicles = vehicleDriverLink[index].vehicles;
              count=0;

               // return Card(
               //   child: Text(vehicles.length<=0?"No Vehicles": vehicleDriverLink[index].vehicles[count++].vehicleRegNumber.toString(),style: Theme
               //       .of(context)
               //       .textTheme
               //       .subtitle1,),
               // );




                return Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Driver Name : " +
                          vehicleDriverLink[index].driverName.toString(), style: Theme
                          .of(context)
                          .textTheme
                          .subtitle1,),
                      SizedBox(height: 10,),
                      Text(vehicles.length<=0?"Vehicle Number : No Vehicles":"Vehicle Number : "+vehicleDriverLink[index].vehicles[count].vehicleRegNumber.toString()??"", style: Theme
                          .of(context)
                          .textTheme
                          .subtitle1,),
                    ],
                  ),
                ),
              );

            }

              ),),
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
                  hint: Text('Vehicle Number',style: Theme.of(context).textTheme.subtitle1,),
                  value: dropdownValue,
                  items: vehiclesList.map((value) {
                    return DropdownMenuItem(
                      value: value.vehicleRegNumber.toString(),
                      child: Text(value.vehicleRegNumber.toString(),style: Theme.of(context).textTheme.subtitle1,),
                    );
                  }).toList(),
                  onChanged: ((dynamic newValue) {
                    state.didChange(newValue);
                    dropdownValue = newValue;
                     for (var i in vehiclesList){
                      if (i.vehicleRegNumber.toString() == newValue){
                        vehicleIndex = i.vehicleId;
                      }
                     }
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
      borderRadius: BorderRadius.circular(5),
//                border: Border.all(
//                  color: Color(0xff218F76),
//                  width: 2.0,
//                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text('Driver Name',style: Theme.of(context).textTheme.subtitle1,),
                  value: dropdownValue1,
                  items: driverList.map((value) {
                    return DropdownMenuItem(
                      value: value.driverName.toString(),
                      child: Text(value.driverName.toString(),style: Theme.of(context).textTheme.subtitle1,),
                    );
                  }).toList(),
                  onChanged: ((dynamic newValue) {
                    state.didChange(newValue);
                    dropdownValue1 = newValue;
                    for(var i in driverList){
                      if (i.driverName == dropdownValue1){
                        driverIndex = i.driverId;
                      }
                    }
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
                      style:Theme.of(context).textTheme.subtitle1,),
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
                      child: Text(value['name'],style: Theme.of(context).textTheme.subtitle1,),
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
