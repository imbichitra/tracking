import 'package:flutter/material.dart';

const Color gradientColor1 = Color(0xff0E0765);
const Color gradientColor2 = Color(0xff006DC0);
const Color gradientColor3 = Color(0xff00A6E4);

const Color foregroundColor = Color(0xff0E0765);
const Color backgroundColor = Color(0xffEAF0F1);

///App gradient color
Widget getAppbarGradient() {
  return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[gradientColor1, gradientColor2, gradientColor3]
          )));
}

///Linear Gradient
LinearGradient buttonColor = LinearGradient(
    colors: <Color>[Colors.blue[700], Colors.blue[700], Colors.blue[700]]);

/// Focused border
UnderlineInputBorder focusedBorder = UnderlineInputBorder(
  // borderRadius: BorderRadius.all(Radius.circular(0)),
  borderRadius: BorderRadius.all(Radius.zero),
  borderSide: BorderSide(width: 0.7, color: Colors.grey[700]),
);

///  disable border
UnderlineInputBorder disableBorder = UnderlineInputBorder(
  borderRadius: BorderRadius.all(Radius.zero),
  borderSide: BorderSide(width: 0.7, color: Colors.grey[700]),
);

/// enable border
UnderlineInputBorder enableBorder = UnderlineInputBorder(
  borderRadius: BorderRadius.all(Radius.zero),
  // borderRadius: BorderRadius.all(Radius.circular(0)),
  borderSide: BorderSide(width: 0.7, color: Colors.grey[700]),
);

/// border
UnderlineInputBorder border = UnderlineInputBorder(
    // borderRadius: BorderRadius.all(Radius.circular(0)),
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(
      width: 4,
    ));

/// error border
UnderlineInputBorder errorBorder = UnderlineInputBorder(
    // borderRadius: BorderRadius.all(Radius.circular(0)),
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(width: 1, color: Colors.red[400]));

///Label Text  Style
TextStyle labelTextStyle = TextStyle(color: Colors.grey[700], fontSize: 18);

///Hint Text  Style
TextStyle hintTextStyle = TextStyle(color: foregroundColor);

///Input Text  Style
TextStyle inputTextStyle =
    TextStyle(color: foregroundColor, fontFamily: "Raleway");

TextStyle vehicleListTextStyle =
    TextStyle(fontSize: 14.0, letterSpacing: 0.5, color: gradientColor2);

/// Theme color scheme
ThemeData theme = ThemeData(
    primaryColor: foregroundColor,
    buttonColor: foregroundColor,
    cursorColor: Colors.blue[400],
    // dividerColor: foregroundColor,
    focusColor: Colors.blue[400],
    errorColor: Colors.red[400],
    fontFamily: "Raleway",

    // unselectedWidgetColor: foregroundColor,
    // accentColor: foregroundColor,
    splashColor: foregroundColor);

class MyFunction extends StatefulWidget {
  final Function function;

  MyFunction({@required this.function});

  @override
  _MyFunctionState createState() => _MyFunctionState();
}

class _MyFunctionState extends State<MyFunction> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        widget.function();
      },
      color: foregroundColor,
      textColor: Colors.white,
      child: Icon(
        Icons.arrow_forward_ios,
        size: 24,
      ),
      padding: EdgeInsets.all(20),
      shape: CircleBorder(),
    );
  }
}

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 8.0),
      decoration: BoxDecoration(
          color: Color(0xff492BC4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              // offset: Offset(0.0, 1.5),
              // blurRadius: 1.5,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
