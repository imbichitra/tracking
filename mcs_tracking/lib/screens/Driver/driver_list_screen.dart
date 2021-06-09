import 'package:flutter/material.dart';
import 'package:mcs_tracking/screens/driver/driver_detail_screen.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:provider/provider.dart';
import 'package:mcs_tracking/StateManagement/Driver/driver_provider.dart';

class DriverListScreen extends StatefulWidget {
  @override
  _DriverListScreenState createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {

  List<dynamic> driverList;
  var tokenObj;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getDrivers();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Drivers Information',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body:Provider.of<DriverStateManagement>(context).getDriverList.length>0? Container(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
          child: ListView.builder(
            itemCount: Provider.of<DriverStateManagement>(context).getDriverList.length,
            itemBuilder: (context, index) {
              final item = Provider.of<DriverStateManagement>(context,listen: false).getDriverList[index];

             return  Dismissible(
               key: Key(item.driverId.toString()),
               direction: DismissDirection.endToStart,
               background: Container(
                 padding: EdgeInsets.symmetric(horizontal: 20.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [Icon(Icons.delete)],
                 ),
               ),
               onDismissed: (direction) async {
                 Provider.of<DriverStateManagement>(context,listen: false).getDriverList.removeWhere((element) => item.driverId == element.driverId);
                 int status =
                 await Provider.of<DriverStateManagement>(context,listen: false).deleteDriver(item.driverId);
                 Scaffold.of(context).showSnackBar(SnackBar(
                   content: Text("Deleted"),
                   backgroundColor: Theme.of(context).accentColor,
                   behavior: SnackBarBehavior.floating,
                 ));
               },
               child: Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundImage: AssetImage('images/tracker.png'),
                      // ),

                      title: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Driver Name : ' + Provider
                                    .of<DriverStateManagement>(context)
                                    .getDriverList[index].driverName,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subtitle1
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Contact Number: ${Provider
                                    .of<DriverStateManagement>(context)
                                    .getDriverList[index].contactNumber}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subtitle1
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Text(
                            //       'License Number: ${Provider.of<DriverStateManagement>(context).getDriverList[index].drivingLicence}',
                            //       style: Theme.of(context).textTheme.subtitle1
                            //     ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DriverDetailView(data: Provider
                                      .of<DriverStateManagement>(context)
                                      .getDriverList[index],),
                            ));
                      },

                    ),
                  ),
                ),
             );
            }
          ),
        ),
      ):Loading(),
    );
  }
}
