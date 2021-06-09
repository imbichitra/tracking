import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mcs_tracking/Models/vehicle_detail.dart';

class CategoriesScroller extends StatelessWidget {


  const CategoriesScroller({Key key,this.vehicleDetail,this.press}):super(key:key);
  //const CategoriesScroller();
  final List<VehicleDetail> vehicleDetail;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 11/2.3,
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        // height: MediaQuery.of(context).size.height/9,
        // width: double.infinity,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: vehicleDetail == null?0:vehicleDetail.length,
            itemBuilder: (context, index) {
          return Card(
            color: Theme.of(context).accentColor,
            elevation: 8.0,
            child: Container(
              child: GestureDetector(
                onTap: (){
                  press(vehicleDetail[index]);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Vehicle : ${vehicleDetail[index].vehicleNumber}',
                      // /${vehicleDetail[index].imeiNumber}
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Roboto'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Driver : ${vehicleDetail[index].driverName}'
                                    // '/${vehicleDetail[index].driverContact}'
                                ,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Roboto'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Row(
                      //       children: <Widget>[
                      //         Text(
                      //           "Imei : ${vehicleDetail[index].imeiNumber}",
                      //           // 'Speed : ${vehicleDetail[index].speed} KMPH/Fuel : ${vehicleDetail[index].fuel}%',
                      //           style: TextStyle(
                      //               color: Theme.of(context).primaryColor,
                      //               fontFamily: 'Roboto'),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
             /* margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.label,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Hell",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'avenir'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Mon-Fri',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'avenir'),
                  ),
                ],
              ),*/
            ),
          );
        }),
      ),
    );
  }
}