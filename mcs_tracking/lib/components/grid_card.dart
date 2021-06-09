import 'package:flutter/material.dart';

class GirdViewCardWidget extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String title;
  final String subtitle;
  final String numValue;
  final String alertCaption;
  final Color color;


  GirdViewCardWidget({this.icon, this.heading, this.title, this.subtitle,
    this.numValue, this.alertCaption, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      padding:EdgeInsets.only(top:10,left: 5),
                      child: Text(heading,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white,fontSize: 15.0))),
                ),
                Icon(
                  icon,
                  size: 100,
                  color: Colors.white,
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),


          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 12,color: Colors.white),),
                Text(subtitle,style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 12,color: Colors.white)),
                Text(
                  numValue,
                  style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 35,color: Colors.white),
                ),
                Text(alertCaption,style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 12,color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}