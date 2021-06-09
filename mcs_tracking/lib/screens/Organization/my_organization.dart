import 'package:flutter/material.dart';
import 'package:mcs_tracking/StateManagement/Organization/organization_provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../loading.dart';

class MyOrganizationScreen extends StatefulWidget {
  @override
  _MyOrganizationScreenState createState() => _MyOrganizationScreenState();
}

class _MyOrganizationScreenState extends State<MyOrganizationScreen> {



  @override
  Widget build(BuildContext context) {
    var myorg = Provider.of<OrganizationStateManagement>(context);

    Color color = Theme.of(context).accentColor;
    return myorg.myOrganization == null
        ? Loading()
        : Scaffold(
      appBar: AppBar(
        title: Text(
          'My Organization',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
            body: Container(
              child: Stack(
                children: [
                  Positioned(
                    left: 30.0,
                    top: 40.0,
                    right: 30.0,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      padding: EdgeInsets.only(top: 50.0),
                      // width: double.infinity,
                      height: 500.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2.0,
                                spreadRadius: 1.5,
                                color: Colors.grey)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            myorg.getMyOrganization.orgName,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(myorg.getMyOrganization.description,
                              style: Theme.of(context).textTheme.subtitle2),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              height: 2.0,
                              thickness: 3.0,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.tachometerAlt,
                                          color: color,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Expanded(
                                          child: Text("Over Speed: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          color: Colors.black45,
                                          height: 20,
                                          width: 2,
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        Expanded(
                                            child: Text(
                                                myorg.getMyOrganization
                                                        .overSpeedLimit
                                                        .toString() +
                                                    " Km/hr",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.tachometerAlt,
                                        color: color,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                          child: Text("Under Speed: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2)),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        color: Colors.black45,
                                        height: 20,
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 40.0,
                                      ),
                                      Expanded(
                                          child: Text(
                                              myorg.getMyOrganization
                                                      .underSpeedLimit
                                                      .toString() +
                                                  " Km/hr",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.route,
                                        color: color,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                        child: Text("Under Utilized Kms: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        color: Colors.black45,
                                        height: 20,
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 40.0,
                                      ),
                                      Expanded(
                                          child: Text(
                                              myorg.getMyOrganization
                                                      .underUtlizedKms
                                                      .toString() +
                                                  " Km",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.route,
                                        color: color,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                        child: Text("Over Utilized Kms: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        color: Colors.black45,
                                        height: 20,
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 40.0,
                                      ),
                                      Expanded(
                                          child: Text(
                                              myorg.getMyOrganization
                                                      .overUtilizedkms
                                                      .toString() +
                                                  " Km",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.gasPump,
                                        color: color,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                        child: Text("Fuel Alert: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        color: Colors.black45,
                                        height: 20,
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 40.0,
                                      ),
                                      Expanded(
                                          child: Text(
                                              myorg.getMyOrganization.fuelLimit
                                                      .toString() +
                                                  " %",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.solidClock,
                                        color: color,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                          child: Text("Over Utilized Hours: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2)),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        color: Colors.black45,
                                        height: 20,
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 40.0,
                                      ),
                                      Expanded(
                                          child: Text(
                                              myorg.getMyOrganization
                                                      .overUtilizedHours
                                                      .toString() +
                                                  " Hr",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.userClock,
                                        color: color,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                          child:
                                              Text("Under Utilized Hours: ",style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2)),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        color: Colors.black45,
                                        height: 20,
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 40.0,
                                      ),
                                      Expanded(
                                          child: Text(
                                              myorg.getMyOrganization
                                                      .underUtilizedHours
                                                      .toString() +
                                                  " Hr",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5.0,
                    left: 160.0,
                    right: 160.0,
                    child: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                        child: Image.asset("images/user-icon.png")),
                  ),
                ],
              ),
            ),
          );
  }
}
