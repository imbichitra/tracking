import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/Models/graph/distanceByDateAndVehicle.dart';
import 'package:mcs_tracking/StateManagement/Graph/analytics_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/distanceByDateAndVehicle_provider.dart';
import 'package:mcs_tracking/StateManagement/Graph/graph_provider.dart';
import 'package:mcs_tracking/StateManagement/Trip/trip_provider..dart';

import 'package:mcs_tracking/components/custom_AlertDialog.dart';
import 'package:mcs_tracking/components/custom_navigation_animation/custom_navigation.dart';
import 'package:mcs_tracking/screens/Device/add_tracker_screen.dart';
import 'package:mcs_tracking/screens/Device/tracker_list_sreen.dart';
import 'package:mcs_tracking/screens/Driver/add_driver_screen.dart';
import 'package:mcs_tracking/screens/Driver/driver_list_screen.dart';
import 'package:mcs_tracking/screens/Organization/my_organization.dart';
import 'package:mcs_tracking/screens/Report/report_screen.dart';
import 'package:mcs_tracking/screens/RouteReplay/route_replay_screen.dart';

import 'package:mcs_tracking/screens/Trip/trip_screen.dart';
import 'package:mcs_tracking/screens/User/adduser_screen.dart';
import 'package:mcs_tracking/screens/User/userlist_screen.dart';
import 'package:mcs_tracking/screens/Vehicle/add_vehicles_screen.dart';
import 'package:mcs_tracking/screens/Vehicle/vehicles_list_screen.dart';
import 'package:mcs_tracking/screens/association/associate_driver_with_vehicle.dart';
import 'package:mcs_tracking/screens/association/associate_vehicle_with_devices_screen.dart';
import 'package:provider/provider.dart';


class CustomDrawer extends StatelessWidget {
  final CurrentUser currentUser;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String role;
  final BuildContext parentContext;


  CustomDrawer({Key key, @required this.currentUser, @required this.scaffoldKey,@required this.role,@required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      color: Colors.white.withAlpha(200),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                "images/user-icon.png",
                width: 100.0,
                height: 100.0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: Text(
              currentUser.emailid.toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          CustomExpansionTile(
            icon: Icon(
                FontAwesomeIcons.layerGroup,
                color: Colors.grey[600],
                size: 15.0,
              ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text(
                "Organisation",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 15.0),
              ),
            ),
            list: role == "USER_SUPERADMIN"? <Widget>[
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("My Organisation", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {
                  print("clicked");
                  scaffoldKey.currentState.openEndDrawer();
                  // Navigator.of(context).push(Materi);
                },
              ),
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("Add Organisation", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {},
              ),
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("All Organisation", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {},
              ),
            ]:<Widget>[ListTile(
              title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("My Organisation", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0))),
              onTap: () {
                scaffoldKey.currentState.openEndDrawer();
                Navigator.push(context, SliderAnimationRoute(page: MyOrganizationScreen()));
              },
            ),],
          ),
          
          CustomExpansionTile(
            icon: Icon(
              FontAwesomeIcons.desktop,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text(
                "Devices",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 15.0),
              ),
            ),
            list: [
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("Add Device", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: AddDeviceScreen()));
                },
              ),
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("All Devices", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: DeviceListScreen()));
                },
              ),
            ],
          ),
          CustomExpansionTile(
            icon: Icon(
              FontAwesomeIcons.truck,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text(
                "Vehicles",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 15.0),
              ),
            ),
            list: [
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("Add Vehicle", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: AddVehicleScreen()));
                },
              ),
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("All Vehicle", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: VehicleListScreen()));
                },
              ),
              ListTile(
                title: Container(
                    margin: EdgeInsets.only(left: 60.0),
                    child: Text("Associate Vehicle", style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.0))),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: AssociateVehicleWithDeviceScreen()));
                },
              ),
            ],
          ),
          CustomExpansionTile(
            icon: Icon(
              FontAwesomeIcons.biking,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text(
                "Drivers",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 15.0),
              ),
            ),
            list: [
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("Add Driver", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0)),
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: AddDriverScreen()));
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("All Drivers", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0)),
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: DriverListScreen()));
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("Associate Driver", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0)),
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: AssociateDriverWithVehicleScreen()));
                },
              ),
            ],
          ),
          CustomExpansionTile(
            icon: Icon(
              FontAwesomeIcons.userAlt,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text(
                "Manage User",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 15.0),
              ),
            ),
            list: [
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("Add User", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0)),
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: AddUserScreen()));
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("All Users", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0)),
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: UserListScreen()));
                },
              ),
            ],
          ),
          CustomExpansionTile(
            icon: Icon(
              FontAwesomeIcons.mapMarkerAlt,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Trip",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 15.0),
              ),
            ),
            list: [
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("Manage Trip", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0)),
                ),
                onTap: () {

                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, SliderAnimationRoute(page: TripScreen()));
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Text("Trip Status", style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 13.0)),
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  // Navigator.push(context, SliderAnimationRoute(page: ManageTripScreen()));
                },
              ),
            ],
          ),

          ListTile(
            leading: Icon(
              FontAwesomeIcons.chartBar,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text("Report",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 15.0)),
            ),
            onTap: () async{
              scaffoldKey.currentState.openEndDrawer();
              DistanceByDateAndVehicle distanceByDateAndVehicle =
              DistanceByDateAndVehicle(
                  inputDate: "2021-02-05T13:05:32Z",
                  orgRefName:
                  CurrentUserSingleton.getInstance.getCurrentUser.orgRefName);
               Provider.of<GraphStateManagement>(context, listen: false)
                  .fetchFleetStatus(currentUser.orgRefName);
              Provider.of<AnalyticsStateManagement>(context, listen: false)
                  .fetchUnderutilizedVehicles(currentUser.orgRefName);
              Provider.of<AnalyticsStateManagement>(context, listen: false)
                  .fetchOverSpeedVehicles(currentUser.orgRefName);
              Provider.of<AnalyticsStateManagement>(context, listen: false)
                  .fetchUnderSpeedVehicles(currentUser.orgRefName);
              Provider.of<AnalyticsStateManagement>(context, listen: false)
                  .fetchLowFuelVehicles(currentUser.orgRefName);

            Provider.of<DistanceByDateAndVehicleStateManagement>(context,
                  listen: false)
                  .fetchDistanceByDateAndVehicle(
                  jsonEncode(distanceByDateAndVehicle.toJson()));

              Navigator.of(context).push(SliderAnimationRoute(page: ReportScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.route,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text("Route Replay",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 15.0)),
            ),
            onTap: () {
               scaffoldKey.currentState.openEndDrawer();
               Navigator.of(context).push(SliderAnimationRoute(page: RouteReplayScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.grey[600],
              size: 15.0,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom:10.0),
              child: Text("SignOut",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 15.0)),
            ),
            onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              _showMyDialog();
            },
          ),
        ],
      ),
    );
  }

  //returnType : Future<void>
  //name : _showMyDialog
  //parameters : None
  //description : When user double tap on back button custom dialog pop up to ensure exit from app.
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog();
      },
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  final List<Widget> list;
  final Widget title;
  final Icon icon;

  CustomExpansionTile(
      {@required this.list, @required this.title, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: icon,
          title: title,
          children: list,
        ),
      ),
    );
  }
}
