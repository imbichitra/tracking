import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/graph/fleetStatus.dart';
import 'package:mcs_tracking/StateManagement/Graph/graph_provider.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:provider/provider.dart';

class FleetStatusScreen extends StatefulWidget {
  @override
  _FleetStatusScreenState createState() => _FleetStatusScreenState();
}

class _FleetStatusScreenState extends State<FleetStatusScreen> {
  List<charts.Series<FleetStatusData, String>> _seriesData =
      List<charts.Series<FleetStatusData, String>>();

  FleetStatus fleetStatus;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Future.delayed(Duration(seconds: 5), () {
    //   FleetStatus fleetStatus =
    //       Provider.of<GraphStateManagement>(context, listen: false)
    //           .getFleetStatus;
    //   print(fleetStatus.runningVehicle);
    //   _generateData(fleetStatus);
    // });
  }

  _generateData(FleetStatus fleetStatus) {
    var barData = [
      new FleetStatusData(
          "Running", fleetStatus.runningVehicle, Color(0xff0A79DF)),
      new FleetStatusData("Inactive", fleetStatus.inactive, Color(0xff4834DF)),
      new FleetStatusData("Idle", fleetStatus.idle, Color(0xff67E6DC)),
      // new FleetStatusData("Stopped", fleetStatus.stopped, Color(0xffE8290B)),
      new FleetStatusData("No data", fleetStatus.noData, Color(0xffE8290B)),
      new FleetStatusData(
          "Vehicles", fleetStatus.totalVehicle, Color(0xff67E6DC)),
    ];

    _seriesData.add(charts.Series(
      data: barData,
      id: "Fleet Status",
      domainFn: (FleetStatusData obj, _) => obj.name,
      measureFn: (FleetStatusData obj, _) => obj.data,
      colorFn: (FleetStatusData obj, _) =>
          charts.ColorUtil.fromDartColor(obj.colorVal),
    ));

    setState(() {
      isLoading = false;
    });
  }

  // Container(
  // child: charts.BarChart(
  // _seriesData,
  // vertical: false,
  // animate: true,
  // ),
  // ),

  @override
  Widget build(BuildContext context) {
    FleetStatus fleetStatusObj =
        Provider.of<GraphStateManagement>(context).getFleetStatus;

    Provider.of<FleetStatusReportGenerator>(context).generateData(fleetStatusObj);
    // fleetStatusReportGenerator.generateData(fleetStatusObj);

    return Scaffold(
      body:
      // isLoading
      //     ? Loading()
      //     :

      Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Fleet Status",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ),
              Container(
                      margin: EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 30.0),
                      child: Consumer<FleetStatusReportGenerator>(
                        builder: (BuildContext context,
                            fleetStatusReportGenerator, _) {


                          return charts.BarChart(
                            fleetStatusReportGenerator._seriesData,
                            vertical: false,
                            animate: true,
                            behaviors: [
                              charts.DatumLegend(
                                  outsideJustification:
                                      charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: 2,
                                  cellPadding:
                                      EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.black,
                                      fontSize: 11))
                            ],
                            defaultRenderer:
                                charts.BarRendererConfig(strokeWidthPx: 5.0),
                          );
                        },
                        // child: charts.BarChart(
                        //   _seriesData,
                        //   vertical: false,
                        //   animate: true,
                        //   behaviors: [
                        //     charts.DatumLegend(
                        //         outsideJustification:
                        //         charts.OutsideJustification.endDrawArea,
                        //         horizontalFirst: false,
                        //         desiredMaxRows: 2,
                        //         cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                        //         entryTextStyle: charts.TextStyleSpec(
                        //             color: charts.MaterialPalette.black,
                        //             fontSize: 11))
                        //   ],
                        //   defaultRenderer:
                        //   charts.BarRendererConfig(strokeWidthPx: 5.0),
                        // ),
                      ),
                    )


                  // child: Container(
                  //   margin: EdgeInsets.only(top: 10.0),
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                  //   child: charts.BarChart(
                  //     _seriesData,
                  //     vertical: false,
                  //     animate: true,
                  //     behaviors: [
                  //       charts.DatumLegend(
                  //           outsideJustification:
                  //               charts.OutsideJustification.endDrawArea,
                  //           horizontalFirst: false,
                  //           desiredMaxRows: 2,
                  //           cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                  //           entryTextStyle: charts.TextStyleSpec(
                  //               color: charts.MaterialPalette.black,
                  //               fontSize: 11))
                  //     ],
                  //     defaultRenderer:
                  //         charts.BarRendererConfig(strokeWidthPx: 5.0),
                  //   ),
                  // ),
              ],
            ),
    );
  }
}

class FleetStatusReportGenerator extends ChangeNotifier {
  List<charts.Series<FleetStatusData, String>> _seriesData =
      List<charts.Series<FleetStatusData, String>>();

  void generateData(FleetStatus fleetStatus) {
    _seriesData.clear();

    var barData = [
      new FleetStatusData(
          "Running", fleetStatus.runningVehicle, Color(0xff0A79DF)),
      new FleetStatusData("Inactive", fleetStatus.inactive, Color(0xff4834DF)),
      new FleetStatusData("Idle", fleetStatus.idle, Color(0xff67E6DC)),
      // new FleetStatusData("Stopped", fleetStatus.stopped, Color(0xffE8290B)),
      new FleetStatusData("No data", fleetStatus.noData, Color(0xffE8290B)),
      new FleetStatusData(
          "Vehicles", fleetStatus.totalVehicle, Color(0xff67E6DC)),
    ];

    _seriesData.add(charts.Series(
      data: barData,
      id: "Fleet Status",
      domainFn: (FleetStatusData obj, _) => obj.name,
      measureFn: (FleetStatusData obj, _) => obj.data,
      colorFn: (FleetStatusData obj, _) =>
          charts.ColorUtil.fromDartColor(obj.colorVal),
    ));
    // notifyListeners();
  }
}

class FleetStatusData {
  String name;
  int data;
  Color colorVal;

  FleetStatusData(this.name, this.data, this.colorVal);
}
