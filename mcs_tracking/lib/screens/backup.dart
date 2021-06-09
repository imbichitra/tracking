// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mcs_tracking/Animation/FadeAnimation.dart';
// import 'package:mcs_tracking/Models/login.dart';
// import 'package:mcs_tracking/StateManagement/auth/auth_state.dart';
// import 'package:mcs_tracking/constant.dart';
// import 'package:mcs_tracking/controllers/login_controller.dart';
// import 'package:mcs_tracking/controllers/token_controller.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:provider/provider.dart';
// import 'package:mcs_tracking/screens/dashboard_screen.dart';
// import 'dart:convert';
//
// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   GlobalKey<FormState> _formKey = GlobalKey();
//
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   bool _autoValidate = false;
//   bool visibility = true;
//   String _email;
//   String _password;
//   LoginModel object;
//   LoginController loginController = LoginController();
//   TokenController tokenController = TokenController();
//   var loginTokenObject;
//
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   ProgressDialog _progressDialog;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AuthState>(context);
//     /*return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: backgroundColor,
//         body: Container(
//           // decoration: BoxDecoration(
//           //     image: DecorationImage(image: AssetImage('images/Mobileui.png'))),
//           child: Center(
//             child: Container(
//               padding: EdgeInsets.only(top: 70),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   autovalidate: _autoValidate,
//                   child: _formContents(),
//                 ),
//               ),
//             ),
//           ),
//         ),
//     );*/
//     _progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
//     _progressDialog.style(message: 'Please wait');
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     return Scaffold(
//       resizeToAvoidBottomPadding: false,
//       key: _scaffoldKey,
//       body: Stack(
//         children: [
//           FadeAnimation(
//             1,
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("images/background.png"),
//                       fit: BoxFit.cover)
// //          gradient: LinearGradient(
// //              begin: Alignment.topCenter,
// //              colors: [Colors.blue[900], Colors.blue[800], Colors.blue[400]]),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               margin:
//               EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(60),
//                       topLeft: Radius.circular(60))),
//             ),
//           ),
//           Positioned(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               margin: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.height / 3),
//               color: Colors.white,
//               child: Column(
//                 // mainAxisAlignment: MainAxisAlignment.start,
//                 // crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Hello, Welcome back!!",
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle1
//                         .copyWith(fontSize: 25),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   FadeAnimation(
//                     2,
//                     SingleChildScrollView(
//                       child: Container(
//                         child: Form(
//                           autovalidate: _autoValidate,
//                           key: _formKey,
//                           child: Container(
//                             child: Column(
//                               children: [
//                                 TextFormField(
//                                   autofocus: true,
//                                   controller: _emailController,
//                                   validator: (value) {
//                                     if (value.isEmpty) {
//                                       return 'Please enter UserId';
//                                     }
//                                     return null;
//                                   },
//                                   onSaved: (value) {
//                                     _email = value;
//                                   },
//                                   decoration: InputDecoration(
//                                       prefixIcon: Icon(Icons.email,
//                                           color: Theme.of(context).accentColor),
//                                       isDense: true,
//                                       enabledBorder: enableBorder,
//                                       disabledBorder: disableBorder,
//                                       focusedBorder: focusedBorder,
//                                       errorBorder: errorBorder,
//                                       labelText: "UserId",
//                                       labelStyle: Theme.of(context)
//                                           .textTheme
//                                           .subtitle1),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 TextFormField(
//                                   controller: _passwordController,
//                                   obscureText: visibility,
//                                   onSaved: (value) {
//                                     _password = value;
//                                   },
//                                   decoration: InputDecoration(
//                                     suffix: IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           visibility = !visibility;
//                                         });
//                                       },
//                                       icon: visibility
//                                           ? Icon(Icons.visibility_off,
//                                           color: Theme.of(context)
//                                               .accentColor):Icon(Icons.visibility,
//                                           color:
//                                           Theme.of(context).accentColor)
//                                       ,
//                                     ),
//                                     prefixIcon: Icon(Icons.lock,
//                                         color: Theme.of(context).accentColor),
//                                     isDense: true,
//                                     enabledBorder: enableBorder,
//                                     disabledBorder: disableBorder,
//                                     focusedBorder: focusedBorder,
//                                     errorBorder: errorBorder,
//                                     labelText: "Password",
//                                     labelStyle:
//                                     Theme.of(context).textTheme.subtitle1,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 40,
//                                 ),
//                                 RaisedGradientButton(
//                                   height: 50,
//                                   onPressed: () async {
//                                     if (_formKey.currentState.validate()) {
//                                       _formKey.currentState.save();
//
//                                       // clear the data from field
//                                       var user = jsonEncode({
//                                         "username": _email.trim(),
//                                         "password": _password.trim()
//                                       });
//                                       await appState.loginUser(user);
//                                       if (appState.isLoadin) {
//                                         _progressDialog.show();
//                                       } else {
//                                         _progressDialog.hide();
//                                       }
//
//                                       if (appState.isError) {
// //                                      TODO: appState.errorMessage (data is not comming)
//                                         final snackBar = SnackBar(
//                                           backgroundColor: Colors.blueAccent,
//                                           content: Text(
//                                             "Invalid User name or password",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .subtitle1
//                                                 .copyWith(color: Colors.white),
//                                           ),
//                                         );
//                                         _scaffoldKey.currentState
//                                             .showSnackBar(snackBar);
//                                       } else {
//                                         /*
//                                       SharedPreferences preferences =
//                                           await SharedPreferences.getInstance();
//
//                                       await preferences.setString(
//                                           "REFRESH_TOKEN",
//                                           appState.getToken.refreshtoken);
//
//                                       setState(() {
//                                         refreshGlobalToken = preferences
//                                             .getString('REFRESH_TOKEN');
//                                         accessGlobalToken = appState.getToken.token;
//                                         //print(accessGlobalToken);
//                                       });
//
//                                        */
//                                         _emailController.clear();
//                                         _passwordController.clear();
//                                         print("working--------------->");
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   DashboardScreen(),
//                                             ));
//                                         print("elas");
//                                       }
//                                     } else {
//                                       //If all data are not valid then start auto validation.
//                                       setState(() {
//                                         _autoValidate = true;
//                                       });
//                                     }
//                                   },
//                                   child: Text(
//                                     "Login",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .subtitle1
//                                         .copyWith(color: Colors.white),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 FadeAnimation(
//                                   1.5,
//                                   Text(
//                                     "Forgot Password?",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .subtitle1
//                                         .copyWith(
//                                         color:
//                                         Theme.of(context).accentColor),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   String _emailValidation(String email) {
//     if (EmailValidator.validate(email)) {
//       return null;
//     }
//     return 'Invalid email';
//   }
//
//   String _passwordValidation(String password) {
//     if (password.length != 0) {
//       return null;
//     }
//     return 'This field can not be empty';
//   }
//
//   void _validateForm(BuildContext context, appState) async {
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       // clear the data from field
//       _progressDialog.show();
//       if (appState)
//         loginTokenObject =
//             loginController.getToken(_email.trim(), _password.trim());
//     } else {
//       //If all data are not valid then start auto validation.
//       setState(() {
//         _autoValidate = true;
//       });
//     }
//   }
// }
