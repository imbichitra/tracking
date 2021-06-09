import 'package:flutter/material.dart';
import 'package:mcs_tracking/StateManagement/Device/device_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/screens/Device/tracker_detail_screen.dart';
import 'package:provider/provider.dart';

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'All Tracker Devices',
          style: Theme.of(context).textTheme.headline3,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body:  Provider.of<DeviceStateManagement>(context).getDevices.length > 0
          ? Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: Provider.of<DeviceStateManagement>(context)
                      .getDevices
                      .length,
                  itemBuilder: (context, index) {
                    final item = Provider.of<DeviceStateManagement>(context,listen: false).getDevices[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(item.deviceId.toString()),
                      onDismissed: (direction)async{
                        Provider.of<DeviceStateManagement>(context,listen: false).getDevices.removeWhere((element) => item.deviceId == element.deviceId);
                        int status = await Provider.of<DeviceStateManagement>(context,listen: false).deleteDevice(item.deviceId);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Deleted"),
                          backgroundColor: Theme.of(context).accentColor,
                          behavior: SnackBarBehavior.floating,
                        ));
                      },
                      background: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Icon(Icons.delete)],
                        ),
                      ),
                      child: Card(
                        // color: foregroundColor,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundImage: AssetImage('images/tracker.png'),
                            // ),
                            title: Container(
                              // padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Device IMEI Number :' +
                                        Provider.of<DeviceStateManagement>(
                                                context)
                                            .getDevices[index]
                                            .imeiNumber,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Device Type: ${Provider.of<DeviceStateManagement>(context).getDevices[index].model}',
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TrackerDetailView(
                                            data: Provider.of<
                                                        DeviceStateManagement>(
                                                    context)
                                                .getDevices[index],
                                          )));
                            },
                          ),
                        ),
                      ),
                    );
                  }),
            )
          : Loading(),
    );
  }
}
