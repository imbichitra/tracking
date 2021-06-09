import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/graph/fleetStatus.dart';
import 'package:mcs_tracking/Models/graph/fleetUsage.dart';
import 'package:mcs_tracking/StateManagement/Graph/analytics_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/graph_provider.dart';
import 'package:mcs_tracking/components/grid_card.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/screens/Graph/fleet_status.dart';
import 'package:mcs_tracking/screens/Graph/fleet_usage.dart';
import 'package:provider/provider.dart';
import 'package:mcs_tracking/screens/Graph/distance_vehicle_average.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  List<charts.Series<VehicleDistance, String>> _seriesSimpleGraphData;
  List<charts.Series<FleetStatusData, String>> _seriesData =
  List<charts.Series<FleetStatusData, String>>();

  bool isLoading = true;

  FleetUsage fleetUsage;



  @override
  void initState() {
    _seriesSimpleGraphData=List<charts.Series<VehicleDistance, String>>();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final ScrollController _scrollController = ScrollController();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.donut_small,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.show_chart,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.multiline_chart,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.info,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            title: Text(
              "Report",
              style: Theme.of(context).textTheme.headline3,
            ),
            elevation: 0,
            centerTitle: false,
          ),
          body: isLoading
              ? Loading()
              : TabBarView(
                  children: [
                    FleetStatusScreen(),
                    FleetUsageScreen(),
                    DistanceVehicleAverageScreen(),
                    thirdTab(),
                  ],
                )),
    );
  }

  // First Tab
  //Donut Chart
  Widget firstTab() {
    return  Container(
        height: MediaQuery.of(context).size.height/4 ,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),

        ),
        padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 30.0),
        child: charts.BarChart(
          _seriesData,
          vertical: false,
          animate: true,
          behaviors: [
            charts.DatumLegend(
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 2,
                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.black,
                    fontSize: 11))
          ],

          defaultRenderer: charts.BarRendererConfig(
              strokeWidthPx: 5.0
          ),
        ),

    );
  }

//  Second Tab
// Line Chart
  Widget secondTab() {
    return Container(
      child: Stack(
        children: [
          Container(
            child: charts.OrdinalComboChart(
              _seriesSimpleGraphData,
              animate: true,
              animationDuration: Duration(seconds: 5),
              defaultRenderer: charts.LineRendererConfig(
                  includeArea: true, includeLine: true, stacked: true
                  // includePoints: true
                  ),
              behaviors: [
                charts.ChartTitle(
                  "Vehicles",
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea,
                ),
                charts.ChartTitle(
                  "Distance",
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Third Tab
//   Information
  Widget thirdTab() {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          GirdViewCardWidget(
            heading: "Underutilized",
            title: "",
            subtitle: "",
            numValue: Provider.of<AnalyticsStateManagement>(context)
                .getUnderutilizedVehicles
                .underUtilizedCount
                .toString(),
            alertCaption: "Alerts",
            icon: Icons.directions_car,
            color: Color(0xffEA7773),
          ),
          GirdViewCardWidget(
            heading: "Over Speed",
            title: "",
            subtitle: "",
            numValue: Provider.of<AnalyticsStateManagement>(context)
                .getOverSpeedVehicles
                .overSpeedCount
                .toString(),
            alertCaption: "Alerts",
            icon: Icons.location_on,
            color: Color(0xff00CCCD),
          ),
          GirdViewCardWidget(
            heading: "Under Speed",
            title: "",
            subtitle: "",
            numValue: Provider.of<AnalyticsStateManagement>(context)
                .getUnderSpeedVehicles
                .underSpeedCount
                .toString(),
            alertCaption: "",
            icon: Icons.ac_unit,
            color: Color(0xffBB2CD9),
          ),
          GirdViewCardWidget(
            heading: "Low Fuel",
            title: " ",
            subtitle: " ",
            numValue: Provider.of<AnalyticsStateManagement>(context)
                        .getLowFuelVehicles
                        .lowFuelCount
                        .toString() ==
                    "null"
                ? "0"
                : Provider.of<AnalyticsStateManagement>(context)
                    .getLowFuelVehicles
                    .lowFuelCount
                    .toString(),
            alertCaption: "Alerts",
            icon: Icons.not_listed_location,
            color: Color(0xffE74292),
          ),
          // GirdViewCardWidget(
          //   heading: "Fence Deviation In",
          //   title: " ",
          //   subtitle: " ",
          //   numValue: "35",
          //   alertCaption: "Alerts",
          //   icon: Icons.location_searching,
          //   color: Color(0xff0ABDE3),
          // ),
          // GirdViewCardWidget(
          //   heading: "Fence Deviation Out",
          //   title: "Min Temp 13 c",
          //   subtitle: "Max Temp 48 c",
          //   numValue: "35",
          //   alertCaption: "Alerts",
          //   icon: Icons.flash_on,
          //   color: Color(0xffF3CC79),
          // ),
        ],
      ),
    );
  }
}

class Task {
  String task;
  double taskValue;
  Color colorVal;

  Task(String task, double taskValue, Color color) {
    this.colorVal = color;
    this.task = task;
    this.taskValue = taskValue;
  }
}

class VehicleDistance {
  final String vehicle;
  final num distance;

  VehicleDistance({this.vehicle, this.distance});
}

class FleetStatusData {
  String name;
  int data;
  Color colorVal;

  FleetStatusData(this.name, this.data, this.colorVal);
}