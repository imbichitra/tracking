import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/graph/distanceByDateAndVehicle.dart';
import 'package:mcs_tracking/StateManagement/Graph/distanceByDateAndVehicle_provider.dart';
import 'package:provider/provider.dart';



class DistanceByDateTimeScreen extends StatefulWidget {
  @override
  _DistanceByDateTimeScreenState createState() => _DistanceByDateTimeScreenState();
}

class _DistanceByDateTimeScreenState extends State<DistanceByDateTimeScreen> {

  bool isPlaying = false;
  final Color barBackgroundColor = Colors.blue as Color;
  final Duration animDuration = const Duration(milliseconds: 250);
  String toDay = DateTime.now().toIso8601String() + "Z";

  List<BarChartGroupData> barChartGroupDateList = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    // Provider.of<DistanceByDateAndVehicleStateManagement>(context,listen: false).fetchDistanceByDateAndVehicle(jsonEncode(distanceByDateAndVehicle.toJson()));
    return Consumer<DistanceByDateAndVehicleStateManagement>(
      builder: (_,object, child){
        for(int i=0; i<object.getDistanceByDateAndVehicle.data.length;i++){
          BarChartGroupData barChartGroupData = BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(y:object.getDistanceByDateAndVehicle.data[i].distance.toDouble() , colors: [
                Colors.lightBlueAccent,
                Colors.greenAccent
              ])
            ],
            showingTooltipIndicators: [0],
          );

          if(barChartGroupDateList.length <= object.getDistanceByDateAndVehicle.data.length){
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
                      if(value.toInt()< object.getDistanceByDateAndVehicle.data.length){
                      return object.getDistanceByDateAndVehicle.data[value.toInt()].vehicleNumber.toString();
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
    );
  }
}


