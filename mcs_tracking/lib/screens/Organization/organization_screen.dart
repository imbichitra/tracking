import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mcs_tracking/screens/Organization/create_new_organization_screen.dart';
import 'package:mcs_tracking/screens/Organization/vehicle_parameters_screen.dart';

class OrganizationScreen extends StatefulWidget {
  @override
  _OrganizationScreenState createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Organization',
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(
            color: Colors.blueAccent,
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).accentColor,
            indicatorWeight: 4.0,
            tabs: [
              Tab(
                child:Text(
                        'New Organization',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 18.0),
                      ),
                    ),
              Tab(
                child: Text(
                  'Vehicle Parameters',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[CreateNewOrganization(), VehicleParametersScreen()],
        ),
      ),
    );
  }
}
