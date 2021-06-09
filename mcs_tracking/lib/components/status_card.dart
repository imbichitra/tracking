import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Function function;
  final Color color;
  final String unit;


  StatusCardWidget({this.icon, this.title, this.value, this.function,this.color,this.unit});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap:function,
      child: Container(
        padding: EdgeInsets.only(left: 5,right: 5,top: 5),
        height: height / 4,
        width: width / 3,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Icon(icon, size: 75, color: Colors.white,),
              ),
            ),

            Container(
              padding: EdgeInsets.only(top:10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, textAlign:TextAlign.center,style:Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white,)),
                  Text(value,style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 30,color: Colors.white),),
                  Text(unit,style:Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
