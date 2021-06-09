import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcs_tracking/StateManagement/Device/device_provider.dart';
import 'package:mcs_tracking/StateManagement/Driver/driver_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/distanceByVehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/graph_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/route_replay_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/vehicle_distance_average_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/vehicle_vs_distance_provider.dart';
import 'package:mcs_tracking/StateManagement/Organization/organization_provider.dart';
import 'package:mcs_tracking/StateManagement/Trip/trip_provider..dart';
import 'package:mcs_tracking/StateManagement/User/user_provider.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/screens/Graph/fleet_status.dart';
import 'package:mcs_tracking/screens/Graph/fleet_usage.dart';
import 'package:mcs_tracking/screens/Organization/organizationlist_screen.dart';
import 'package:mcs_tracking/screens/Vehicle/vehicles_list_screen.dart';
import 'package:mcs_tracking/screens/dashboard_screen.dart';
import 'package:mcs_tracking/screens/login_screen.dart';
import 'package:provider/provider.dart';
import "package:shared_preferences/shared_preferences.dart";

import 'StateManagement/Graph/analytics_provider.dart';
import 'StateManagement/Graph/distanceByDateAndVehicle_provider.dart';
import 'StateManagement/auth/auth_state.dart';
import 'injector/injector.dart';

Future<void> main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // systemNavigationBarColor: Colors.blue,
      // statusBarColor: Colors.white,
      ));
  //Interceptor
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  await setupLocator();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AuthState()),
      ChangeNotifierProvider.value(value: DriverStateManagement()),
      ChangeNotifierProvider.value(value: VehicleStateManagement()),
      ChangeNotifierProvider.value(value: DeviceStateManagement()),
      ChangeNotifierProvider.value(value: OrganizationStateManagement()),
      ChangeNotifierProvider.value(value: UserStateManagement()),
      ChangeNotifierProvider.value(value: GraphStateManagement()),
      ChangeNotifierProvider.value(value: AnalyticsStateManagement()),
      ChangeNotifierProvider.value(
          value: VehicleDistanceAverageStateManagement()),
      ChangeNotifierProvider.value(value: VehicleVsHourStateManagement()),
      ChangeNotifierProvider.value(value: TripStateManagement()),
      ChangeNotifierProvider.value(
          value: DistanceByDateAndVehicleStateManagement()),
      ChangeNotifierProvider.value(value: DistanceByVehicleStateManagement()),
      ChangeNotifierProvider.value(value: RouteReplayStateManagement()),
      ChangeNotifierProvider.value(value: FleetStatusReportGenerator()),
      ChangeNotifierProvider.value(value: FleetUsageReportGenerator())
    ],
    child: MaterialApp(
        // home: email == null ? WelcomeScreen() : DashboardScreen(),
        // Navigate to Splash Screen
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/login": (context) => Login(),
          "/dashboard": (context) => DashboardScreen(),
          "/vehicle-list": (context) => VehicleListScreen(),
          "/organization-list": (context) => OrganizationList()
        },
        theme: ThemeData(
          fontFamily: "Raleway",
          primaryColor: Colors.white,
          brightness: Brightness.light,
          accentColor: Color(0xff538FFB),
          dividerColor: Colors.grey[500],
          focusColor: Color(0xff538FFB),
          disabledColor: Colors.blue[600],
          hintColor: Color(0xff538FFB),
          textTheme: TextTheme(
            headline5:
                TextStyle(fontSize: 22.0, color: Colors.grey[700], height: 1.3),
            headline4: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
                height: 1.3),
            headline3: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
                height: 1.3),
            headline2: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Colors.grey[700],
                height: 1.4),
            headline1: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w300,
                color: Colors.grey[600],
                height: 1.4),
            subtitle1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                height: 1.3),
            headline6: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: Colors.grey[700],
                height: 1.3),
            bodyText2: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.2),
            bodyText1: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.3),
            caption: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
                color: Colors.blue[800],
                height: 1.2),
          ),
        )),
  ));
}


// Spalash Screen class
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation heartbeatAnimation;

  // For spinning the loader for 3 sec
  Future<bool> _mockCheckSession() async {
    await Future.delayed(Duration(seconds: 3), () {});
    return true;
  }

  // Navigate to Login Screen
  void navigateToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    heartbeatAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 200,
            end: 230,
          ),
          weight: 50,
        ),
        // TweenSequenceItem<double>(
        //   tween: Tween<double>(
        //     begin: 150,
        //     end: 200,
        //   ),
        //   weight: 50,
        // ),
      ],
    ).animate(controller);
    controller.repeat(reverse: true);

    _mockCheckSession()
        .then((status) => {
              if (status) {navigateToHome()}
            })
        .catchError((e) => print(e));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff187bcd),
      body: Container(
        child: Stack(
          children: [
            FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 0.6,
              child: Center(
                child: Image.asset(
                  "images/trade_mark.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    //   AnimatedBuilder(
    //   animation: heartbeatAnimation,
    //   builder: (context, widget) {
    //     return Scaffold(
    //
    //         backgroundColor: Color(0xff187bcd),
    //         body: Container(
    //       child: Stack(
    //         children: [
    //           FractionallySizedBox(
    //             alignment: Alignment.topCenter,
    //             heightFactor: 0.8,
    //             child: Center(
    //                 // child: Icon(Icons.add,size: heartbeatAnimation.value,)
    //                 child:
    //                 // Image.asset(
    //                 //   "images/Background_dot.png"
    //                 // )
    //                 Image.asset(
    //               "images/logo_new.png",
    //               width: heartbeatAnimation.value,
    //               height: heartbeatAnimation.value,
    //             )
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 10.0),
    //             child: Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Text("Asiczen Technologies", style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white70,),),
    //             ),
    //           )
    //
    //         ],
    //       ),
    //     )
    //
    //         //   Container(
    //         //     decoration: BoxDecoration(
    //         //   gradient: LinearGradient(
    //         //   begin: Alignment.topRight,
    //         //     end: Alignment.bottomLeft,
    //         //     colors: [
    //         //       Color(0xff5B54FA), Color(0xff538FFB)
    //         //     ],
    //         //   )
    //         // ),
    //         //     padding: EdgeInsets.only(top: MediaQuery
    //         //         .of(context)
    //         //         .size
    //         //         .height / 4),
    //         //     child: Stack(
    //         //         children: [
    //         //           Positioned(
    //         //             top: 30.0,
    //         //             left: 30.0,
    //         //             right: 30.0,
    //         //             child: Container(
    //         //                   padding:
    //         //                   EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
    //         //                   child: Center(
    //         //                     child: Text(
    //         //                       "AzTrack",
    //         //                       style: TextStyle(
    //         //                           color: Colors.white,
    //         //                           fontFamily: "Amita",
    //         //                           fontWeight: FontWeight.w500,
    //         //                           fontSize: 60.0),
    //         //                     ),
    //         //                   ),
    //         //                 ),
    //         //                ),
    //         //           Align(
    //         //             alignment: Alignment.center,
    //         //             // left: 130,
    //         //             // right: 130,
    //         //             child: CircularProgressIndicator(
    //         //               backgroundColor:   Color(0xff538FFB),
    //         //               valueColor: new AlwaysStoppedAnimation<Color>(Colors.white60),
    //         //             ),
    //         //           ),
    //         //           // Positioned(
    //         //           //   top: MediaQuery.of(context).size.height/1.45,
    //         //           //   left: 180,
    //         //           //   right: 180,
    //         //           //   child: Text(
    //         //           //     "from",
    //         //           //     textAlign: TextAlign.center,
    //         //           //   ),
    //         //           // ),
    //         //           Align(
    //         //             alignment: Alignment.bottomCenter,
    //         //             child: Container(
    //         //               margin: EdgeInsets.symmetric(vertical: 5.0),
    //         //               child: Text(
    //         //                   "Asiczen",
    //         //                 textAlign: TextAlign.center,
    //         //                 style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
    //         //               ),
    //         //             ),
    //         //           )
    //         //
    //         //         ]),
    //         //   ),
    //         );
    //   },
    // );
  }
}
