import 'package:flutter/material.dart';
class CustomCard extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final Color color;
  final String subtext;


  CustomCard({this.height, this.width, this.text, this.color, this.subtext});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),),
            Text(subtext)
          ],
        ),
      ),
      decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(5),
          color: color
      ),
    );
  }
}