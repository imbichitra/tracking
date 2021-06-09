import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constant.dart';

class Loading extends StatefulWidget  {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin{

  AnimationController _animationController;

  Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this,duration:Duration(seconds: 4));

    _colorTween = _animationController.drive(ColorTween(begin: Color(0xff5B54FA), end: Color(0xff538FFB)));

    _animationController.repeat();
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Theme.of(context).accentColor,
        body: Center(
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: _colorTween,
              // backgroundColor: Theme.of(context).accentColor,
            ),
        ),
    );
  }
}