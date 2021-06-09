import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/graph/distanceByVehicle.dart';
import 'package:mcs_tracking/StateManagement/Graph/distanceByDateAndVehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/distanceByVehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:provider/provider.dart';

class DistanceByVehicleScreen extends StatefulWidget {
  @override
  _DistanceByVehicleScreenState createState() =>
      _DistanceByVehicleScreenState();
}

class _DistanceByVehicleScreenState extends State<DistanceByVehicleScreen> {
  double _height;
  double _width;

  String _setDate, _orgRefName;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  String _startDate =
      DateTime(2020, 11, 02, 00, 00, 00).toIso8601String() + "Z";
  String _endDate = DateTime.now().toIso8601String() + "Z";

  String selectedVehicleNumber;

  DateTime selectedDate = DateTime.now();

  List<BarChartGroupData> barChartGroupDateList = [];






  Future<Null> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        print(picked.toIso8601String().substring(0, 19) + "Z");

        selectedDate = picked;
        controller.text = DateFormat.yMd().format(selectedDate);
        print(controller.text);
      });
    if (controller == _startDateController) {
      setState(() {
        _startDate = picked.toIso8601String().substring(0, 19) + "Z";
      });
    } else {
      setState(() {
        _endDate = picked.toIso8601String().substring(0, 19) + "Z";
      });
    }

    // print(selectedDate);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orgRefName = CurrentUserSingleton.getInstance.getCurrentUser.orgRefName;
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: _height / 15,
            width: double.infinity,
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    // padding:EdgeInsets.symmetric(horizontal:10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Platform.isIOS
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(top: 15.0),
                            width: _width / 2.5,
                            height: _height / 15,
                            alignment: Alignment.center,
                            // decoration:
                            //     BoxDecoration(color: Colors.grey[200]),
                            child: InkWell(
                              onTap: () {
                                _selectDate(context, _startDateController);
                              },
                              child: Container(
                                child: TextFormField(
                                  controller: _startDateController,
                                  enabled: false,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  onSaved: (value) {
                                    _setDate = value;
                                    print(_setDate);
                                  },
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "Start Date",
                                    // labelText: 'Time',
                                    // contentPadding:
                                    //     EdgeInsets.only(top: 5)
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Container(
                    // padding:EdgeInsets.symmetric(horizontal:10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Platform.isIOS
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(top: 15.0),
                            width: _width / 2.5,
                            height: _height / 15,
                            alignment: Alignment.center,
                            // decoration:
                            //     BoxDecoration(color: Colors.grey[200]),
                            child: InkWell(
                              onTap: () {
                                _selectDate(context, _endDateController);
                              },
                              child: Container(
                                child: TextFormField(
                                  controller: _endDateController,
                                  enabled: false,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  onSaved: (value) {
                                    _setDate = value;
                                    print(_setDate);
                                  },
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "End Date",
                                    // labelText: 'Time',
                                    // contentPadding:
                                    //     EdgeInsets.only(top: 5)
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                    child: Container(
                        child: Consumer<VehicleStateManagement>(
                          builder: (_,object,__){
                            return DropdownSearch<String>(
                              validator: (v) => v == null ? "required field" : null,
                              hint: "Select vehicle",
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              items: object.getVehicles.map((e) => e.vehicleRegNumber).toList(),

                              onChanged: (data){
                                selectedVehicleNumber = data;
                              },
                            );
                          },
                        ))),
                SizedBox(
                  width: 10.0,
                ),
                Consumer<DistanceByVehicleStateManagement>(
                  builder: (_,object,__){
                    return Container(
                      // padding: EdgeInsets.all(10.0),
                      // margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () async {
                          if(selectedVehicleNumber == null ||_startDate == null ||_endDate == null){
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please pick start date, end date & vehicle number")));
                            return;
                          }else{
                            DistanceByVehicle distanceByVehicle = DistanceByVehicle(vehicleNumber: selectedVehicleNumber,orgRefName: CurrentUserSingleton.getInstance.getCurrentUser.orgRefName,fromDate: _startDate,toDate: _endDate);
                            object.fetchDistanceByVehicleData(jsonEncode(distanceByVehicle.toJson()));
                          }

                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
         Consumer<DistanceByVehicleStateManagement>(
            builder: (_,object,__){
              if(object.getDistanceByVehicle == null){
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 60.0,vertical: 50.0),
                  child: Text("Select Date and Vehicle Number",style: TextStyle(color: Colors.blue),),);
              }
              for(int i=0; i<object.getDistanceByVehicle.data.length;i++){
                BarChartGroupData barChartGroupData = BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(y:object.getDistanceByVehicle.data[i].distance.toDouble() , colors: [
                      Colors.lightBlueAccent,
                      Colors.greenAccent
                    ])
                  ],
                  showingTooltipIndicators: [0],
                );

                if(barChartGroupDateList.length <= object.getDistanceByVehicle.data.length){
                  barChartGroupDateList.add(barChartGroupData);
                }else{
                  break;
                }
              }

              return AspectRatio(
                aspectRatio: 1.7,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xff2c4260),
                  child: BarChart(
                    BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 1000,
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: const EdgeInsets.all(0),
                            tooltipBottomMargin: 8,
                            getTooltipItem: (
                                BarChartGroupData group,
                                int groupIndex,
                                BarChartRodData rod,
                                int rodIndex,
                                ) {
                              return BarTooltipItem(
                                rod.y.round().toString(),
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 8.0),
                            margin: 20,
                            getTitles: (double value) {
                              if(value.toInt()< object.getDistanceByVehicle.data.length){
                                return value.toInt().toString();
                              }
                              return "";
                            },
                          ),
                          leftTitles: SideTitles(showTitles: false),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: barChartGroupDateList
                    ),
                  ),
                ),
              );
            },
            child: Text("Loading..........."),
          )
        ],
      ),
    );
  }
}
