import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/graph/fleetUsage.dart';
import 'package:mcs_tracking/StateManagement/Graph/graph_provider.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/screens/Graph/active_inactive_vehicle_screen.dart';
import 'package:mcs_tracking/screens/Graph/idle_hour_mandatory_loss_screen.dart';
import 'package:provider/provider.dart';

class FleetUsageScreen extends StatefulWidget {
  @override
  _FleetUsageScreenState createState() => _FleetUsageScreenState();
}

class _FleetUsageScreenState extends State<FleetUsageScreen> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  final ScrollController _scrollController = ScrollController();
  List<FleetUsageVehicleDetails> _fleetUsageVehicleList = [];
  List<FlSpot> spots = [];


  @override
  void initState() {
    Provider.of<GraphStateManagement>(context, listen: false).fetchFleetUsage(
        CurrentUserSingleton.getInstance.getCurrentUser.orgRefName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _fleetUsageVehicleList =
        Provider.of<GraphStateManagement>(context).getFleetUsage.vehicles;
    Provider.of<FleetUsageReportGenerator>(context)
        .generateData(_fleetUsageVehicleList);

    return Scaffold(
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Stack(fit: StackFit.expand, children: [
                FractionallySizedBox(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.1,
                  child: Container(
                    child: Text(
                      "Fleet Usage",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
                Consumer<FleetUsageReportGenerator>(
                    builder: (BuildContext context, fleetUsageGenerator, _) {
                  return FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 0.9,
                      child: Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                AspectRatio(
                                  aspectRatio: 3,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Color(0xff232d37)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 40.0,
                                          left: 40.0,
                                          top: 40.0,
                                          bottom: 12),
                                      child: LineChart(
                                          LineChartData(
                                            gridData: FlGridData(
                                              show: true,
                                              drawVerticalLine: true,
                                              getDrawingHorizontalLine: (value) {
                                                return FlLine(
                                                  color: const Color(0xff03203C),
                                                  strokeWidth: 1,
                                                );
                                              },
                                              getDrawingVerticalLine: (value) {
                                                return FlLine(
                                                  color: const Color(0xff03203C),
                                                  strokeWidth: 1,
                                                );
                                              },
                                            ),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              bottomTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 22,
                                                getTextStyles: (value) => const TextStyle(
                                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9.0),
                                                getTitles: (value) {
                                                  if (value.toInt() < _fleetUsageVehicleList.length) {
                                                    return _fleetUsageVehicleList[value.toInt()].vehicleNumber;
                                                  }
                                                  return '';
                                                },
                                                margin: 8,
                                              ),
                                              leftTitles: SideTitles(
                                                showTitles: false,
                                                getTextStyles: (value) => const TextStyle(
                                                  color: Color(0xff67727d),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                getTitles: (value) {
                                                  // print(value.toInt());
                                                  return '';
                                                },
                                                reservedSize: 28,
                                                margin: 12,
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                                show: true,
                                                border: Border.all(color: const Color(0xff37434d), width: 1)),
                                            minX: 0,
                                            maxX: _fleetUsageVehicleList.length.toDouble(),
                                            minY: 0,
                                            // maxY: 10000,
                                            lineBarsData: [
                                              LineChartBarData(
                                                spots: fleetUsageGenerator.getSpots,
                                                isCurved: false,
                                                colors: gradientColors,
                                                barWidth: 5,
                                                isStrokeCapRound: true,
                                                dotData: FlDotData(
                                                  show: false,
                                                ),
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  colors:
                                                  gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                )
                              ])));
                })
              ]),
            ),
          );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff03203C),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff03203C),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9.0),
          getTitles: (value) {
            if (value.toInt() < _fleetUsageVehicleList.length) {
              return _fleetUsageVehicleList[value.toInt()].vehicleNumber;
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            print(value.toInt());
            // print(_fleetUsageVehicleList[value.toInt()].distance.toString());
            // switch (value.toInt()) {
            //   case 1:
            //     return '10km';
            //   case 2:
            //     return '20km';
            //   case 3:
            //     return '30km';
            //   case 5:
            //     return '50km';
            //   case 10:
            //     return '100km';
            // }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: _fleetUsageVehicleList.length.toDouble(),
      minY: 0,
      // maxY: 10000,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}

class FleetUsageReportGenerator extends ChangeNotifier {
  List<FlSpot> spots = [];

  void generateData(List<FleetUsageVehicleDetails> fleetUsageVehicleList) {
    spots.clear();
    for (int i = 0; i < fleetUsageVehicleList.length; i++) {
      spots.add(FlSpot(i.toDouble(), fleetUsageVehicleList[i].distance));
    }

    // notifyListeners();
  }

  List<FlSpot> get getSpots => this.spots;
}
