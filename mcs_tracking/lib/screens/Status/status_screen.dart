import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcs_tracking/components/status_card.dart';

class StatusScreen extends StatefulWidget {
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Status",
          style: Theme.of(context).textTheme.headline3,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusCardWidget(
                    title: "Over Speed",
                    value: "22",
                    color: Color(0xff25CCF7),
                    icon: Icons.keyboard_arrow_up,
                    function: null,
                    unit:""
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StatusCardWidget(
                    title: "Under Speed",
                    value: "12",
                    color: Color(0xff2B2B52),
                    icon: Icons.keyboard_arrow_down,
                    function: null,
                      unit:""
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusCardWidget(
                    title: "Low Fuel",
                    value: "22",
                    color: Color(0xffF0DF87),
                    icon: Icons.local_car_wash,
                    function: null,
                      unit:""
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StatusCardWidget(
                    title: "Under Utilized",
                    value: "22",
                    color: Color(0xffFF3031),
                    icon: Icons.sentiment_very_dissatisfied,
                    function: null,
                      unit:""
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusCardWidget(
                    title: "Fence Deviation In",
                    value: "15",
                    color: Color(0xff3C40C6),
                    icon: Icons.fullscreen_exit,
                    function: null,
                      unit:"Km/h"
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StatusCardWidget(
                    title: "Fence Deviation Out",
                    value: "15",
                    color: Color(0xff10A881),
                    icon: Icons.fullscreen_exit,
                    function: null,
                    unit: "Km/h",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
