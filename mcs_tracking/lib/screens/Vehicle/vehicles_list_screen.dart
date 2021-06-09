import 'package:flutter/material.dart';
import 'package:mcs_tracking/StateManagement/Vehicle/vehicle_provider.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/screens/Vehicle/vehicle_detail_screen.dart';
import 'package:provider/provider.dart';

class VehicleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final providerObject = Provider.of<VehicleStateManagement>(context);
//     providerObject.getAllVehicles();

    return Scaffold(
      backgroundColor: Color(0xFFEAF0F1),
      appBar: AppBar(
        title: Text(
          'All Vehicles',
          style: Theme.of(context).textTheme.headline3,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Provider.of<VehicleStateManagement>(context).getVehicles.length > 0
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                  itemCount: Provider.of<VehicleStateManagement>(context)
                      .getVehicles
                      .length,
                  itemBuilder: (context, index) {
                    final item = Provider.of<VehicleStateManagement>(context,listen: false)
                        .getVehicles[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(item.vehicleId.toString()),
                      background: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Icon(Icons.delete)],
                        ),
                      ),
                      onDismissed: (direction) async {
                        Provider.of<VehicleStateManagement>(context,listen: false).getVehicles.removeWhere((element) => item.vehicleId == element.vehicleId);
                        int status =
                            await Provider.of<VehicleStateManagement>(context,listen: false)
                                .deleteVehicle(item.vehicleId);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Deleted"),
                          backgroundColor: Theme.of(context).accentColor,
                          behavior: SnackBarBehavior.floating,
                        ));
                      },
                      child: Card(
                        child: Container(
                          // height: MediaQuery.of(context).size.height / 8,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Vehicle Number : ' +
                                        Provider.of<VehicleStateManagement>(
                                                context)
                                            .getVehicles[index]
                                            .vehicleRegNumber,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Vehicle Type : ' +
                                      Provider.of<VehicleStateManagement>(
                                              context)
                                          .getVehicles[index]
                                          .vehicleType,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            onTap: () {
                                int  vehicleId = Provider.of<VehicleStateManagement>(
                                    context,listen:false)
                                    .getVehicles[index].vehicleId;
                              Provider.of<VehicleStateManagement>(context,listen: false).fetchOwnerDetails(vehicleId);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VehicleDetailView(
                                            object: Provider.of<
                                                        VehicleStateManagement>(
                                                    context)
                                                .getVehicles[index],
                                          )));
                            },
                            /*
                              trailing: Container(
                                height: 30,
                                width: 70,
                                child: RaisedGradientButton(
                                  child: Text(
                                    'Show',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VehicleDetailView(
                                              object:Provider.of<VehicleStateManagement>(context)
                                                .getVehicles[index]
                                                  ,
                                            )));
                                  },
                                ),
                              ),
                              */
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

/*
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        // backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('All Vehicle List',style: Theme.of(context).textTheme.headline3,),
          elevation: 0,
          centerTitle: true,
        ),
        body:isLoading?Loading(): Container(
          padding: EdgeInsets.all(10),
          child:ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) => Card(
              // color: foregroundColor,
              child: Container(
                height: MediaQuery.of(context).size.height/8,
                padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 5),
                child: ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage: AssetImage('images/car.png'),
                  // ),

                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vehicle Number : ' + vehicles[index]["vehicleRegnNumber"]??"Wait..",
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Vehicle Type : ' + vehicles[index]["vehicleType"]?? "wait..",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  trailing: Container(
                    height: 30,
                    width: 70,
                    child: RaisedGradientButton(
                        child: Text(
                          'Show',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VehicleDetailView(object:vehicles[index])));
                        },
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VehicleDetailView(object:vehicles[index])));
                  },
                ),
              ),
            ),
          ),
        ),
    );
  }
}


*/
