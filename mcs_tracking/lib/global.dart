
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:intl/intl.dart';

String accessGlobalToken;
String refreshGlobalToken;

CurrentUser user;


String timeStampToLocalTime(int stamp){
  try{
    var date = DateTime.fromMillisecondsSinceEpoch(stamp);
    var format = DateFormat.yMMMEd().format(date);
    var time = TimeOfDay.fromDateTime(date);
    return format.toString() +", "+time.hour.toString() +" : "+time.minute.toString();
  }catch(e){
    print(e.toString());
    return "";
  }
}



// Expanded(
// child: Container(
// // width: MediaQuery.of(context).size.width / 1.2,
// // height: MediaQuery.of(context).size.height/1.5,
// child: ListView.builder(
// itemCount: drawerItemModelList.length,
// itemBuilder: (BuildContext context, int index) {
// return Theme(
// data: Theme.of(context)
//     .copyWith(cardColor: Color(0xffffffff).withAlpha(20)),
// child: ExpansionPanelList(
// elevation: 0,
// animationDuration: Duration(seconds: 1),
// children: [
// ExpansionPanel(
// isExpanded: drawerItemModelList[index].isExpandable,
// headerBuilder:
// (BuildContext context, bool isExtended) {
// return ListTile(
// title: Text(drawerItemModelList[index].header,
// style: Theme.of(context)
//     .textTheme
//     .headline2
//     .copyWith(
// color: Colors.white,
// fontSize: 18.0)),
// );
// },
// body: Container(
// height: 20.0 *
// drawerItemModelList[index]
//     .drawerBodyModel
//     .items
//     .length,
// child: ListView.builder(
// itemCount: drawerItemModelList[index]
//     .drawerBodyModel
//     .items
//     .length,
// itemBuilder: (BuildContext context, int i) {
// return Text("Hello",
// style: Theme.of(context)
//     .textTheme
//     .headline2
//     .copyWith(
// color: Colors.blueAccent,
// fontSize: 10.0));
// }),
// ),
// )
// ],
// expansionCallback: (int item, bool status) {
// setState(() {
// if (index == 5 || index == 6) {
// drawerItemModelList[index].isExpandable = false;
// } else {
// drawerItemModelList[index].isExpandable =
// !drawerItemModelList[index].isExpandable;
// }
// });
// },
// ),
// );
// },
// ),
//
// // child: Drawer(
// //   child: ListView(
// //     // Important: Remove any padding from the ListView.
// //     padding: EdgeInsets.zero,
// //     children: <Widget>[
// //       Container(
// //         child: UserAccountsDrawerHeader(
// //           currentAccountPicture: CircleAvatar(
// //             radius: 60.0,
// //             backgroundImage: AssetImage("images/user-icon.png"),
// //           ),
// //           accountName: Text(
// //             "${currentUser.orgRefName.toUpperCase()}",
// //             style: Theme.of(context).textTheme.headline2.copyWith(
// //                 color: Theme.of(context).accentColor, fontSize: 20.0),
// //           ),
// //           accountEmail: Text(
// //             "${currentUser.emailid.toLowerCase()}",
// //             style: Theme.of(context).textTheme.headline5.copyWith(
// //                 color: Theme.of(context).accentColor, fontSize: 15.0),
// //           ),
// //         ),
// //       ),
// //       ListTile(
// //         leading: FaIcon(FontAwesomeIcons.houseUser),
// //         title: CustomDropdown(
// //             context,
// //             'Organizations',
// //             role == "ROLE_SUPERADMIN"
// //                 ? ["My Organization"]
// //                 : [
// //                     'Add Organization',
// //                     'View All Organization',
// //                     'My Organization'
// //                   ],
// //             setOrganizationRoute),
// //       ),
// //       ListTile(
// //         leading: FaIcon(FontAwesomeIcons.toolbox),
// //         title: CustomDropdown(
// //           context,
// //           'Devices',
// //           ['Add Devices', 'View All Devices'],
// //           setDevicesRoute,
// //         ),
// //         onTap: () {
// //           // Update the state of the app.
// //           // ...
// //           // Navigator.pop(context);
// //         },
// //       ),
// //       ListTile(
// //         leading: FaIcon(FontAwesomeIcons.carAlt),
// //         title: CustomDropdown(
// //           context,
// //           'Vehicles',
// //           ['Add Vehicles', 'View All Vehicles', 'Associate With Devices'],
// //           setVehiclesRoute,
// //         ),
// //         onTap: () {
// //           // Update the state of the app.
// //           // ...
// //           // Navigator.pop(context);
// //         },
// //       ),
// //       ListTile(
// //         leading: FaIcon(FontAwesomeIcons.userAlt),
// //         title: CustomDropdown(
// //             context,
// //             'Drivers',
// //             ['Add Driver', 'All Drivers', 'Associate with Vehicle'],
// //             setDriversRoute),
// //         onTap: () {
// //           // Update the state of the app.
// //           // ...
// //         },
// //       ),
// //       ListTile(
// //         leading: FaIcon(FontAwesomeIcons.userAlt),
// //         title:
// //             CustomDropdown(context, 'Users', ['All Users'], setUserRoute),
// //         onTap: () {
// //           // Update the state of the app.
// //           // ...
// //         },
// //       ),
// //       ListTile(
// //         leading: FaIcon(
// //           FontAwesomeIcons.fileAlt,
// //         ),
// //         title: CustomDropdown(
// //             context, 'Reports', ['Report'], setGraphStatus),
// //
// //         // Text('Reports', style: Theme.of(context).textTheme.subtitle1),
// //         onTap: () {
// //           // Navigator.push(context,
// //           //     MaterialPageRoute(builder: (context) => ReportScreen()));
// //         },
// //       ),
// //       ListTile(
// //         leading: FaIcon(
// //           FontAwesomeIcons.fileAlt,
// //         ),
// //         title: CustomDropdown(context, 'Trip',
// //             ['Manage Trip', 'Trip Status'], setTripRoute),
// //
// //         // Text('Reports', style: Theme.of(context).textTheme.subtitle1),
// //         onTap: () {
// //           // Navigator.push(context,
// //           //     MaterialPageRoute(builder: (context) => ReportScreen()));
// //         },
// //       ),
// //       ListTile(
// //         leading: Icon(Icons.exit_to_app),
// //         title:
// //             Text("Signout", style: Theme.of(context).textTheme.subtitle1),
// //         onTap: _showMyDialog,
// //       )
// //     ],
// //   ),
// // ),
// ),
// ),
