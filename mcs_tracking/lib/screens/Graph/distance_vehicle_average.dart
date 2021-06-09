import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/graph/activeVehicleVsStatus.dart';
import 'package:mcs_tracking/Models/graph/fleetDistanceVehicleAverage.dart';
import 'package:mcs_tracking/Models/graph/vehicleStatusCounter.dart';
import 'package:mcs_tracking/Models/graph/vehiclesHours.dart';
import 'package:mcs_tracking/StateManagement/Graph/graph_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/vehicle_distance_average_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/vehicle_vs_distance_provider.dart';
import 'package:mcs_tracking/screens/Graph/active_inactive_vehicle_screen.dart';
import 'package:mcs_tracking/screens/Graph/distanceByVehicle_screen.dart';
import 'package:provider/provider.dart';
import 'package:mcs_tracking/screens/Graph/distance_by_date_time_screen.dart';

import '../../loading.dart';

class DistanceVehicleAverageScreen extends StatefulWidget {
  @override
  _DistanceVehicleAverageScreenState createState() =>
      _DistanceVehicleAverageScreenState();
}

class _DistanceVehicleAverageScreenState
    extends State<DistanceVehicleAverageScreen> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  var month, year, day;

  var thirtyOne = [1, 3, 5, 7, 8, 10, 12];
  int newDate;

  String _setDate, _orgRefName;
  String _startDate;
      // DateTime(2020, 11, 02, 00, 00, 00).toIso8601String() + "Z";
  String _endDate = DateTime.now().toIso8601String() + "Z";

  TimeOfDay selectedTizme = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();

  double _height;
  double _width;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  DistanceVehicleList list;
  VehicleHoursList vehicleHoursList;
  ActiveVehicleVsStatusList activeVehicleVsStatusList;
  VehicleStatusCounterList vehicleStatusCounterList;

  List<BarChartGroupData> barChartGroupData = [];
  bool isStart = true;
  bool isLoading = true;
  bool isLoading2 = true;
  bool isLoading3 = true;
  bool isLoading4 = true;

  bool isShowingMainData = true;
  bool initLoading = true;
  bool isEmptyData = false;
  int touchedGroupIndex;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  List<BarChartGroupData> rawBarGroupsForVehicleStatusCount = [];
  List<BarChartGroupData> showingBarGroupsVehicleStatusCount = [];

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
    calculateDateTime();
    // _startDateController.text = DateFormat.yMd().format(DateTime.now());
    // _endDateController.text = DateFormat.yMd().format(DateTime.now());
    _orgRefName = CurrentUserSingleton.getInstance.getCurrentUser.orgRefName;
    // print(_orgRefName);


    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     initLoading = false;
    //   });
    // });
    print("######################################  --->");
    // print(DateTime.now().hour);
    // print(DateTime.now().year);
    print(DateTime.now().month);
    print(DateTime.now().day - 5);
    print(DateTime.now().toIso8601String() + "Z");
    // print(DateTime.now().minute);
    calculateDateTime();
    print(year.toString()+"-"+month.toString()+"-"+day.toString()+"T"+DateTime.now().toString().substring(11) +"Z");
    _startDate = year.toString()+"-"+month.toString()+"-"+day.toString()+"T"+DateTime.now().toString().substring(11) +"Z";
    getDistanceVehicleData();


    super.initState();
  }

  void calculateDateTime() {
    if (DateTime.now().day - 5 <= 0 && DateTime.now().month == 1) {
      month = 12;
      year = DateTime.now().year - 1;
      newDate = DateTime.now().day - 5;
      getDay(newDate);
    } else if (DateTime.now().day - 5 <= 0 && DateTime.now().month != 1) {
      month = DateTime.now().month - 1;
      getCustomMonth(month);
      newDate = DateTime.now().day - 5;
      year = DateTime.now().year;
      getDay(newDate);
    } else if (DateTime.now().day - 5 <= 0 && DateTime.now().month == 2) {
      month = DateTime.now().month - 1;
      getCustomMonth(month);
      newDate = DateTime.now().day - 5;
      year = DateTime.now().year;
      day = 28 + newDate;
    } else {
      newDate = DateTime.now().day - 5;
      month = DateTime.now().month - 1;
      getCustomMonth(month);
      year = DateTime.now().year;
      getDay(newDate);
    }
  }

  void getDay(int newDate){
    if (thirtyOne.contains(DateTime.now().month)) {
      day = 31 + newDate;
    } else if (DateTime.now().month == 2) {
      day = 28 + newDate;
    } else {
      day = 30 + newDate;
    }
    getCustomDay(day);
  }

  void getCustomDay(day){
    NumberFormat formatter = new NumberFormat("00");
    print("day is $day");
    if([1,2,3,4,5,6,7,8,9].contains(day)){
     day = formatter.format(day);
     print("day is $day");
    }
  }

  void getCustomMonth(mnt){
    NumberFormat formatter = new NumberFormat("00");
    if([1,2,3,4,5,6,7,8,9].contains(mnt)){
      month = formatter.format(mnt);
      print("month is $month");
    }
  }

  void getDistanceVehicleData() async {
    await Provider.of<VehicleDistanceAverageStateManagement>(context,
            listen: false)
        .fetchVehicleDistanceAverage(jsonEncode({
      "orgRefName": _orgRefName,
      "fromDate": _startDate,
      "toDate": _endDate
    }));

    await Provider.of<VehicleVsHourStateManagement>(context, listen: false)
        .fetchVehicleVsHours(jsonEncode({
      "orgRefName": _orgRefName,
      "fromDate": _startDate,
      "toDate": _endDate
    }));

    await Provider.of<GraphStateManagement>(context, listen: false)
        .fetchActiveVehicleVsStatus(jsonEncode({
      "orgRefName": _orgRefName,
      "fromDate": _startDate,
      "toDate": _endDate
    }));

    await Provider.of<GraphStateManagement>(context, listen: false)
        .fetchVehicleStatusCounter(jsonEncode({
      "orgRefName": _orgRefName,
      "fromDate": _startDate,
      "toDate": _endDate
    }));

    activeVehicleVsStatusList =
        Provider.of<GraphStateManagement>(context, listen: false)
            .getActiveVehicleVsStatus;
    setDistanceStatusData();

    vehicleStatusCounterList =
        Provider.of<GraphStateManagement>(context, listen: false)
            .getVehicleStatusCounterList;
    setVehicleStatusCounter();

    list = Provider.of<VehicleDistanceAverageStateManagement>(context,
            listen: false)
        .getDistanceVehicleList;
    setGraphData();

    vehicleHoursList =
        Provider.of<VehicleVsHourStateManagement>(context, listen: false)
            .getVehicleHoursList;
    setVehicleHoursGraph();
    if(list.distancevehicleList.isNotEmpty){
      setState(() {
        initLoading = false;
        isEmptyData = false;
      });
    }else{
      setState(() {
        isEmptyData = true;
        initLoading = false;
      });
    }
    
  }

  final allAvgIndividualScrollControl = ScrollController();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return initLoading
        ? Loading()
        : isEmptyData?Center(child: Text("No data to show",style: TextStyle(color: Colors.black,),)): Container(
            margin: EdgeInsets.only(top: 30.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0),

            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Date Time Pick Section

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
                                      _selectDate(
                                          context, _startDateController);
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
                        width: 10.0,
                      ),
                      Container(
                        // padding: EdgeInsets.all(10.0),
                        // margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () async {
                            Map<String, dynamic> toJson = {
                              "orgRefName": _orgRefName,
                              "fromDate": _startDate,
                              "toDate": _endDate
                            };
                            setState(() {
                              isStart = false;
                            });
                            await Provider.of<
                                        VehicleDistanceAverageStateManagement>(
                                    context,
                                    listen: false)
                                .fetchVehicleDistanceAverage(
                                    jsonEncode(toJson));

                            await Provider.of<VehicleVsHourStateManagement>(
                                    context,
                                    listen: false)
                                .fetchVehicleVsHours(jsonEncode(toJson));

                            await Provider.of<GraphStateManagement>(context,
                                    listen: false)
                                .fetchActiveVehicleVsStatus(jsonEncode(toJson));

                            await Provider.of<GraphStateManagement>(context,
                                    listen: false)
                                .fetchVehicleStatusCounter(jsonEncode(toJson));

                            // First Graph
                            list = Provider.of<
                                        VehicleDistanceAverageStateManagement>(
                                    context,
                                    listen: false)
                                .getDistanceVehicleList;
                            setGraphData();

                            // Second Graph
                            vehicleHoursList =
                                Provider.of<VehicleVsHourStateManagement>(
                                        context,
                                        listen: false)
                                    .getVehicleHoursList;
                            setVehicleHoursGraph();

                            // Third Graph
                            activeVehicleVsStatusList =
                                Provider.of<GraphStateManagement>(context,
                                        listen: false)
                                    .getActiveVehicleVsStatus;
                            setDistanceStatusData();

                            // Forth Graph
                            vehicleStatusCounterList =
                                Provider.of<GraphStateManagement>(context,
                                        listen: false)
                                    .getVehicleStatusCounterList;
                            setVehicleStatusCounter();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "All average & individual",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // isStart
                isStart
                    ? AspectRatio(
                        aspectRatio: 1.5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.5),
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff2c274c),
                                Color(0xff46426c),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
// color: const Color(0xff000063),
                          child: BarChart(
                            BarChartData(
                                alignment: BarChartAlignment.spaceAround,
// maxY: 100000000,
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
                                        fontSize: 10),
                                    margin: 20,
                                    getTitles: (double value) {
                                      if (value <= list.result.length) {
                                        return list.result[value.toInt()]
                                            .vehicleNumber;
                                      }
                                      return "";
                                    },
                                  ),
                                  leftTitles: SideTitles(showTitles: false),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: barChartGroupData),
                          ),
                        ),
                      )
                    : isLoading
                        ? AspectRatio(
                            aspectRatio: 1.5,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: 1.5,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.5),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff2c274c),
                                    Color(0xff46426c),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
// color: const Color(0xff000063),
                              child: BarChart(
                                BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: 100000000,
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
                                        getTextStyles: (value) =>
                                            const TextStyle(
                                                color: Color(0xff7589a2),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                        margin: 20,
                                        getTitles: (double value) {
                                          if (value <= list.result.length) {
                                            return list.result[value.toInt()]
                                                .vehicleNumber;
                                          }
                                          return "";
                                        },
                                      ),
                                      leftTitles: SideTitles(showTitles: false),
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    barGroups: barChartGroupData),
                              ),
                            ),
                          ),

                SizedBox(
                  height: 15.0,
                ),

                Text(
                  "Fleet Fuel",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                isStart
                    ? AspectRatio(
                        aspectRatio: 1.5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff2c274c),
                                Color(0xff46426c),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    height: 37,
                                  ),
                                  const Text(
                                    '',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 37,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 16.0, left: 6.0),
                                      child: LineChart(
                                        sampleData1(),
                                        swapAnimationDuration:
                                            const Duration(milliseconds: 250),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.white.withOpacity(
                                      isShowingMainData ? 1.0 : 0.5),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isShowingMainData = !isShowingMainData;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    : isLoading2
                        ? AspectRatio(
                            aspectRatio: 1.5,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: 1.5,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.5),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff2c274c),
                                    Color(0xff46426c),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height: 37,
                                      ),
                                      const Text(
                                        'Vehicle vs Hours',
                                        style: TextStyle(
                                          color: Color(0xff827daa),
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 37,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0, left: 6.0),
                                          child: LineChart(
                                            sampleData1(),
                                            swapAnimationDuration:
                                                const Duration(
                                                    milliseconds: 250),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.white.withOpacity(
                                          isShowingMainData ? 1.0 : 0.5),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isShowingMainData = !isShowingMainData;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Active Vehicle And Vehicle Idle Hour",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10,
                ),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    color: const Color(0xff2c4260),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 20,
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
                                fontSize: 14),
                            margin: 20,
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 0:
                                  return '01 Jan';
                                case 1:
                                  return '02 Jan';
                                case 2:
                                  return '03 Jan';
                                case 3:
                                  return '04 Jan';
                                case 4:
                                  return '05 Jan';
                                case 5:
                                  return '06 Jan';
                                case 6:
                                  return '07 Jan';
                                default:
                                  return '';
                              }
                            },
                          ),
                          leftTitles: SideTitles(showTitles: false),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(y: 8, colors: [
                                Colors.lightBlueAccent,
                                Colors.greenAccent
                              ])
                            ],
                            showingTooltipIndicators: [0],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(y: 10, colors: [
                                Colors.lightBlueAccent,
                                Colors.greenAccent
                              ])
                            ],
                            showingTooltipIndicators: [0],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(y: 14, colors: [
                                Colors.lightBlueAccent,
                                Colors.greenAccent
                              ])
                            ],
                            showingTooltipIndicators: [0],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(y: 15, colors: [
                                Colors.lightBlueAccent,
                                Colors.greenAccent
                              ])
                            ],
                            showingTooltipIndicators: [0],
                          ),
                          BarChartGroupData(
                            x: 4,
                            barRods: [
                              BarChartRodData(y: 13, colors: [
                                Colors.lightBlueAccent,
                                Colors.greenAccent
                              ])
                            ],
                            showingTooltipIndicators: [0],
                          ),
                          BarChartGroupData(
                            x: 5,
                            barRods: [
                              BarChartRodData(y: 10, colors: [
                                Colors.lightBlueAccent,
                                Colors.greenAccent
                              ])
                            ],
                            showingTooltipIndicators: [0],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // Text(
                //   "Active Inactive And Idle",
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context)
                //       .textTheme
                //       .subtitle1
                //       .copyWith(color: Theme.of(context).accentColor),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // ActiveInactiveIdleScreen(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Active Vehicle & Distance Travelled ",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10,
                ),
                // IdleHourMandatoryLossScreen()
                isStart
                    ? AspectRatio(
                        aspectRatio: 1.2,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: const Color(0xff2c4260),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                const SizedBox(
                                  height: 38,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: BarChart(
                                      BarChartData(
                                        maxY: 10000,
                                        barTouchData: BarTouchData(
                                            touchTooltipData:
                                                BarTouchTooltipData(
                                              tooltipBgColor: Colors.grey,
                                              getTooltipItem:
                                                  (_a, _b, _c, _d) => null,
                                            ),
                                            touchCallback: (response) {
                                              if (response.spot == null) {
                                                setState(() {
                                                  touchedGroupIndex = -1;
                                                  showingBarGroups =
                                                      List.of(rawBarGroups);
                                                });
                                                return;
                                              }

                                              touchedGroupIndex = response
                                                  .spot.touchedBarGroupIndex;

                                              setState(() {
                                                if (response.touchInput
                                                        is FlLongPressEnd ||
                                                    response.touchInput
                                                        is FlPanEnd) {
                                                  touchedGroupIndex = -1;
                                                  showingBarGroups =
                                                      List.of(rawBarGroups);
                                                } else {
                                                  showingBarGroups =
                                                      List.of(rawBarGroups);
                                                  if (touchedGroupIndex != -1) {
                                                    double sum = 0;
                                                    for (BarChartRodData rod
                                                        in showingBarGroups[
                                                                touchedGroupIndex]
                                                            .barRods) {
                                                      sum += rod.y;
                                                    }
                                                    final avg = sum /
                                                        showingBarGroups[
                                                                touchedGroupIndex]
                                                            .barRods
                                                            .length;

                                                    showingBarGroups[
                                                            touchedGroupIndex] =
                                                        showingBarGroups[
                                                                touchedGroupIndex]
                                                            .copyWith(
                                                      barRods: showingBarGroups[
                                                              touchedGroupIndex]
                                                          .barRods
                                                          .map((rod) {
                                                        return rod.copyWith(
                                                            y: avg);
                                                      }).toList(),
                                                    );
                                                  }
                                                }
                                              });
                                            }),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (value) =>
                                                const TextStyle(
                                                    color: Color(0xff7589a2),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 7),
                                            margin: activeVehicleVsStatusList
                                                .getList.length
                                                .toDouble(),
                                            getTitles: (double value) {
                                              if (value.toInt() != null) {
                                                return activeVehicleVsStatusList
                                                    .getList[value.toInt()]
                                                    .dayOfMonth;
                                              }
                                              return "";
                                            },
                                          ),
                                          leftTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (value) =>
                                                const TextStyle(
                                                    color: Color(0xff7589a2),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                            margin: 40,
                                            reservedSize: 14,
                                            getTitles: (value) {
                                              if (value == 0) {
                                                return '0';
                                              } else if (value == 10) {
                                                return '10';
                                              } else if (value == 20) {
                                                return '20';
                                              } else if (value == 30) {
                                                return '30';
                                              } else if (value == 40) {
                                                return '30';
                                              } else if (value == 50) {
                                                return '30';
                                              } else if (value == 60) {
                                                return '30';
                                              } else {
                                                return '';
                                              }
                                            },
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        barGroups: showingBarGroups,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : isLoading3
                        ? AspectRatio(
                            aspectRatio: 1.5,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: 1.2,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              color: const Color(0xff2c4260),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 38,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: BarChart(
                                          BarChartData(
                                            maxY: 10000,
                                            barTouchData: BarTouchData(
                                                touchTooltipData:
                                                    BarTouchTooltipData(
                                                  tooltipBgColor: Colors.grey,
                                                  getTooltipItem:
                                                      (_a, _b, _c, _d) => null,
                                                ),
                                                touchCallback: (response) {
                                                  if (response.spot == null) {
                                                    setState(() {
                                                      touchedGroupIndex = -1;
                                                      showingBarGroups =
                                                          List.of(rawBarGroups);
                                                    });
                                                    return;
                                                  }

                                                  touchedGroupIndex = response
                                                      .spot
                                                      .touchedBarGroupIndex;

                                                  setState(() {
                                                    if (response.touchInput
                                                            is FlLongPressEnd ||
                                                        response.touchInput
                                                            is FlPanEnd) {
                                                      touchedGroupIndex = -1;
                                                      showingBarGroups =
                                                          List.of(rawBarGroups);
                                                    } else {
                                                      showingBarGroups =
                                                          List.of(rawBarGroups);
                                                      if (touchedGroupIndex !=
                                                          -1) {
                                                        double sum = 0;
                                                        for (BarChartRodData rod
                                                            in showingBarGroups[
                                                                    touchedGroupIndex]
                                                                .barRods) {
                                                          sum += rod.y;
                                                        }
                                                        final avg = sum /
                                                            showingBarGroups[
                                                                    touchedGroupIndex]
                                                                .barRods
                                                                .length;

                                                        showingBarGroups[
                                                                touchedGroupIndex] =
                                                            showingBarGroups[
                                                                    touchedGroupIndex]
                                                                .copyWith(
                                                          barRods: showingBarGroups[
                                                                  touchedGroupIndex]
                                                              .barRods
                                                              .map((rod) {
                                                            return rod.copyWith(
                                                                y: avg);
                                                          }).toList(),
                                                        );
                                                      }
                                                    }
                                                  });
                                                }),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              bottomTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles: (value) =>
                                                    const TextStyle(
                                                        color:
                                                            Color(0xff7589a2),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 7),
                                                margin:
                                                    activeVehicleVsStatusList
                                                        .getList.length
                                                        .toDouble(),
                                                getTitles: (double value) {
                                                  if (value.toInt() != null) {
                                                    return activeVehicleVsStatusList
                                                        .getList[value.toInt()]
                                                        .dayOfMonth;
                                                  }
                                                  return "";
                                                },
                                              ),
                                              leftTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles: (value) =>
                                                    const TextStyle(
                                                        color:
                                                            Color(0xff7589a2),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                margin: 40,
                                                reservedSize: 14,
                                                getTitles: (value) {
                                                  if (value == 0) {
                                                    return '0';
                                                  } else if (value == 10) {
                                                    return '10';
                                                  } else if (value == 20) {
                                                    return '20';
                                                  } else {
                                                    return '';
                                                  }
                                                },
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            barGroups: showingBarGroups,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                Text(
                  "Active & Idle Vehicle",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10,
                ),
                // IdleHourMandatoryLossScreen()
                isStart
                    ? AspectRatio(
                        aspectRatio: 1.2,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: const Color(0xff2c4260),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                const SizedBox(
                                  height: 38,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: BarChart(
                                      BarChartData(
                                        maxY: 20,
                                        barTouchData: BarTouchData(
                                            touchTooltipData:
                                                BarTouchTooltipData(
                                              tooltipBgColor: Colors.grey,
                                              getTooltipItem:
                                                  (_a, _b, _c, _d) => null,
                                            ),
                                            touchCallback: (response) {
                                              if (response.spot == null) {
                                                setState(() {
                                                  touchedGroupIndex = -1;
                                                  showingBarGroupsVehicleStatusCount =
                                                      List.of(
                                                          rawBarGroupsForVehicleStatusCount);
                                                });
                                                return;
                                              }

                                              touchedGroupIndex = response
                                                  .spot.touchedBarGroupIndex;

                                              setState(() {
                                                if (response.touchInput
                                                        is FlLongPressEnd ||
                                                    response.touchInput
                                                        is FlPanEnd) {
                                                  touchedGroupIndex = -1;
                                                  showingBarGroupsVehicleStatusCount =
                                                      List.of(
                                                          rawBarGroupsForVehicleStatusCount);
                                                } else {
                                                  showingBarGroupsVehicleStatusCount =
                                                      List.of(
                                                          rawBarGroupsForVehicleStatusCount);
                                                  if (touchedGroupIndex != -1) {
                                                    double sum = 0;
                                                    for (BarChartRodData rod
                                                        in showingBarGroupsVehicleStatusCount[
                                                                touchedGroupIndex]
                                                            .barRods) {
                                                      sum += rod.y;
                                                    }
                                                    final avg = sum /
                                                        showingBarGroupsVehicleStatusCount[
                                                                touchedGroupIndex]
                                                            .barRods
                                                            .length;

                                                    showingBarGroupsVehicleStatusCount[
                                                            touchedGroupIndex] =
                                                        showingBarGroupsVehicleStatusCount[
                                                                touchedGroupIndex]
                                                            .copyWith(
                                                      barRods:
                                                          showingBarGroupsVehicleStatusCount[
                                                                  touchedGroupIndex]
                                                              .barRods
                                                              .map((rod) {
                                                        return rod.copyWith(
                                                            y: avg);
                                                      }).toList(),
                                                    );
                                                  }
                                                }
                                              });
                                            }),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (value) =>
                                                const TextStyle(
                                                    color: Color(0xff7589a2),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 7),
                                            margin: vehicleStatusCounterList
                                                .getList.length
                                                .toDouble(),
                                            getTitles: (double value) {
                                              if (value.toInt() != null) {
                                                return vehicleStatusCounterList
                                                    .getList[value.toInt()]
                                                    .dayOfMonth;
                                              }
                                              return "";
                                            },
                                          ),
                                          leftTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (value) =>
                                                const TextStyle(
                                                    color: Color(0xff7589a2),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                            margin: 40,
                                            reservedSize: 14,
                                            getTitles: (value) {
                                              if (value == 0) {
                                                return '0';
                                              } else if (value == 10) {
                                                return '10';
                                              } else if (value == 20) {
                                                return '20';
                                              } else {
                                                return '';
                                              }
                                            },
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        barGroups:
                                            showingBarGroupsVehicleStatusCount,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : isLoading4
                        ? AspectRatio(
                            aspectRatio: 1.5,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: 1.2,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              color: const Color(0xff2c4260),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 38,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: BarChart(
                                          BarChartData(
                                            maxY: 20,
                                            barTouchData: BarTouchData(
                                                touchTooltipData:
                                                    BarTouchTooltipData(
                                                  tooltipBgColor: Colors.grey,
                                                  getTooltipItem:
                                                      (_a, _b, _c, _d) => null,
                                                ),
                                                touchCallback: (response) {
                                                  if (response.spot == null) {
                                                    setState(() {
                                                      touchedGroupIndex = -1;
                                                      showingBarGroupsVehicleStatusCount =
                                                          List.of(
                                                              rawBarGroupsForVehicleStatusCount);
                                                    });
                                                    return;
                                                  }

                                                  touchedGroupIndex = response
                                                      .spot
                                                      .touchedBarGroupIndex;

                                                  setState(() {
                                                    if (response.touchInput
                                                            is FlLongPressEnd ||
                                                        response.touchInput
                                                            is FlPanEnd) {
                                                      touchedGroupIndex = -1;
                                                      showingBarGroupsVehicleStatusCount =
                                                          List.of(
                                                              rawBarGroupsForVehicleStatusCount);
                                                    } else {
                                                      showingBarGroupsVehicleStatusCount =
                                                          List.of(
                                                              rawBarGroupsForVehicleStatusCount);
                                                      if (touchedGroupIndex !=
                                                          -1) {
                                                        double sum = 0;
                                                        for (BarChartRodData rod
                                                            in showingBarGroupsVehicleStatusCount[
                                                                    touchedGroupIndex]
                                                                .barRods) {
                                                          sum += rod.y;
                                                        }
                                                        final avg = sum /
                                                            showingBarGroupsVehicleStatusCount[
                                                                    touchedGroupIndex]
                                                                .barRods
                                                                .length;

                                                        showingBarGroupsVehicleStatusCount[
                                                                touchedGroupIndex] =
                                                            showingBarGroupsVehicleStatusCount[
                                                                    touchedGroupIndex]
                                                                .copyWith(
                                                          barRods:
                                                              showingBarGroupsVehicleStatusCount[
                                                                      touchedGroupIndex]
                                                                  .barRods
                                                                  .map((rod) {
                                                            return rod.copyWith(
                                                                y: avg);
                                                          }).toList(),
                                                        );
                                                      }
                                                    }
                                                  });
                                                }),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              bottomTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles: (value) =>
                                                    const TextStyle(
                                                        color:
                                                            Color(0xff7589a2),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 7),
                                                margin: vehicleStatusCounterList
                                                    .getList.length
                                                    .toDouble(),
                                                getTitles: (double value) {
                                                  if (value.toInt() != null) {
                                                    return vehicleStatusCounterList
                                                        .getList[value.toInt()]
                                                        .dayOfMonth;
                                                  }
                                                  return "";
                                                },
                                              ),
                                              leftTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles: (value) =>
                                                    const TextStyle(
                                                        color:
                                                            Color(0xff7589a2),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                margin: 40,
                                                reservedSize: 14,
                                                getTitles: (value) {
                                                  if (value == 0) {
                                                    return '0';
                                                  } else if (value == 10) {
                                                    return '10';
                                                  } else if (value == 20) {
                                                    return '20';
                                                  } else {
                                                    return '';
                                                  }
                                                },
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            barGroups:
                                                showingBarGroupsVehicleStatusCount,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                Text(
                  "Distance By Date",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10,
                ),
                DistanceByDateTimeScreen(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Distance By Date For a Vehicle",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 10,
                ),
                DistanceByVehicleScreen()
              ],
            ),
          );
  }

  void setGraphData() {
    List<BarChartGroupData> dataList = [];
    for (int i = 0; i < list.result.length; i++) {
      dataList.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                y: list.result[i].totalDistance,
                colors: [Color(0xff3d5aff), Color(0xff8187ff)])
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    setState(() {
      barChartGroupData = dataList;
      isLoading = false;
    });
  }

  List<FlSpot> lineSpotData1 = List<FlSpot>();
  List<FlSpot> lineSpotData2 = List<FlSpot>();
  List<FlSpot> lineSpotData3 = List<FlSpot>();

  void setVehicleHoursGraph() {
    lineSpotData1.clear();
    lineSpotData2.clear();
    lineSpotData3.clear();
    for (int i = 0; i < vehicleHoursList.result.length; i++) {
      lineSpotData1.add(
          FlSpot(i.toDouble(), vehicleHoursList.result[i].idleHourEngineOn));
      lineSpotData2.add(
          FlSpot(i.toDouble(), vehicleHoursList.result[i].idleHourEngineOff));
      lineSpotData3
          .add(FlSpot(i.toDouble(), vehicleHoursList.result[i].movingEngineOn));
    }
    if(lineSpotData1.isNotEmpty && lineSpotData2.isNotEmpty && lineSpotData3.isNotEmpty)
      setState(() {
        isLoading2 = false;
      });
  }

  void setDistanceStatusData() {
    rawBarGroups.clear();
    showingBarGroups.clear();
    for (int i = 0; i < activeVehicleVsStatusList.getList.length; i++) {
      final barGroup = makeGroupData(
          i,
          activeVehicleVsStatusList.getList[i].activeVehicleCount,
          activeVehicleVsStatusList.getList[i].totalDistance);
      rawBarGroups.add(barGroup);
    }
    showingBarGroups = rawBarGroups;
    
    setState(() {
      isLoading3 = false;
    });
  }

  void setVehicleStatusCounter() {
    rawBarGroupsForVehicleStatusCount.clear();
    showingBarGroupsVehicleStatusCount.clear();
    for (int i = 0; i < vehicleStatusCounterList.getList.length; i++) {
      final barGroup = makeGroupData(
          i,
          vehicleStatusCounterList.getList[i].activeVehicleCount,
          vehicleStatusCounterList.getList[i].idleVehicleCount);
      rawBarGroupsForVehicleStatusCount.add(barGroup);
    }
    showingBarGroupsVehicleStatusCount = rawBarGroupsForVehicleStatusCount;

    setState(() {
      isLoading4 = false;
    });
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: lineSpotData1,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: lineSpotData2,
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );

    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: lineSpotData3,
      isCurved: true,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return [lineChartBarData1, lineChartBarData2, lineChartBarData3];
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 8,
          ),
          margin: 20,
          getTitles: (value) {
            if (value < vehicleHoursList.result.length) {
              return vehicleHoursList.result[value.toInt()].vehicleNumber;
            }
            return " ";
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: vehicleHoursList.result.length.toDouble(),
      maxY: 500000000,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }
}
