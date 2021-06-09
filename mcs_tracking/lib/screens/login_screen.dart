import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mcs_tracking/Models/login.dart';
import 'package:mcs_tracking/StateManagement/auth/auth_state.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mcs_tracking/screens/dashboard_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AnimationController animationController;
  Animation<double> animation1;

  bool _autoValidate = false;
  bool visibility = true;
  String _email;
  String _password;
  LoginModel object;

  var loginTokenObject;
  int popped = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog _progressDialog;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation1 =
        Tween<double>(begin: 0, end: pi + pi).animate(animationController);
    super.initState();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AuthState>(context);
    _progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    _progressDialog.style(message: 'Please wait');

    var device = MediaQuery.of(context).size;

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () async {
        DateTime initTime = DateTime.now();
        popped += 1;
        if (popped >= 2) return true;
        await _scaffoldKey.currentState
            .showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Tap one more time to exit.',
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 2),
            ))
            .closed;
        if (DateTime.now().difference(initTime) >= Duration(seconds: 2)) {
          popped = 0;
        }
        popped = 0;
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "images/login_background.png",
                    width: device.width / 1.8,
                    height: device.height / 1.8,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: device.height / 2.5,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              autofocus: false,
                              controller: _emailController,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.grey),
                              validator: (value) {
                                if (value.length == 0) {
                                  return 'Please enter UserId';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value;
                              },
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  prefixIcon: Container(
                                    child: Icon(FontAwesomeIcons.userAlt,
                                        size: 20.0, color: Colors.grey),
                                  ),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  disabledBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  focusedErrorBorder: new OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  errorBorder: new OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: "UserId",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(color: Colors.grey)),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            child: TextFormField(
                              autofocus: false,
                              controller: _passwordController,
                              obscureText: visibility,
                              cursorColor: Colors.grey,
                              onSaved: (value) {
                                _password = value;
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.grey),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return "Password Field can not empty";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      visibility = !visibility;
                                    });
                                  },
                                  child: visibility
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                prefixIcon: Container(
                                  child: Icon(FontAwesomeIcons.key,
                                      size: 20.0, color: Colors.grey),
                                ),
                                isDense: true,
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: new OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                disabledBorder: new OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                focusedErrorBorder: new OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                errorBorder: new OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _rotateChildContinuously();
                                // clear the data from field
                                var user = jsonEncode({
                                  "username": _email.trim(),
                                  "password": _password.trim()
                                });
                                await appState.loginUser(user);
                                if (appState.isLoadin) {
                                  _progressDialog.show();
                                } else {
                                  _progressDialog.hide();
                                }

                                if (appState.isError) {
//                                      TODO: appState.errorMessage (data is not comming)
                                  final snackBar = SnackBar(
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    content: Text(
                                      "Invalid User name or password",
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                } else {
                                  /*
                                          SharedPreferences preferences =
                                              await SharedPreferences.getInstance();

                                          await preferences.setString(
                                              "REFRESH_TOKEN",
                                              appState.getToken.refreshtoken);

                                          setState(() {
                                            refreshGlobalToken = preferences
                                                .getString('REFRESH_TOKEN');
                                            accessGlobalToken = appState.getToken.token;
                                            //print(accessGlobalToken);
                                          });

                                           */
                                  _emailController.clear();
                                  _passwordController.clear();
                                  print("working--------------->");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DashboardScreen(),
                                      ));
                                  print("elas");
                                }
                              } else {
                                //If all data are not valid then start auto validation.
                                setState(() {
                                  _autoValidate = true;
                                });
                              }
                            },
                            child: Container(
                              child: Center(
                                child: RotateTransition(
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 25.0,
                                      color: Colors.white,
                                    ),
                                    animation1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
//           Container(
//             // decoration: BoxDecoration(
//             //     gradient: LinearGradient(
//             //   begin: Alignment.topRight,
//             //   end: Alignment.bottomLeft,
//             //   colors: [Color(0xff5B54FA), Color(0xff538FFB)],
//             // )),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   // padding: EdgeInsets.only(),
//                   margin: EdgeInsets.only(
//                     top: 25.0,
//                   ),
//                   child: Container(
//                     height: 150.0,
//                       child: Lottie.asset("images/login-lotte.json")
//                   )
//
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Container(
//                   // margin: EdgeInsets.only(left: 30),
//                   child: Text("Let's get started ...",
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                           fontFamily: "Raleway",
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w500,
//                           color: Theme.of(context).primaryColor)),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   decoration: BoxDecoration(
//                     color: Color(0xff538FFB).withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(
//                       10,
//                     ),
//                     // border: Border.all(
//                     //   width: 1.5,
//                     //   color: Theme.of(context).primaryColor,
//                     // ),
//                     boxShadow: [
//                       new BoxShadow(
//                           color: Colors.transparent,
//                           // offset: Offset(2, 3),
//                           blurRadius: 2.0,
//                           spreadRadius: 2.0),
//                       new BoxShadow(
//                           color: Colors.transparent,
//                           // offset: Offset(2, 3),
//                           blurRadius: 2.5,
//                           spreadRadius: 3.0),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                     child: Form(
//                       autovalidate: _autoValidate,
//                       key: _formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 5.0),
//                             padding:
//                                 const EdgeInsets.only(top: 12.0, bottom: 5.0),
//                             child: TextFormField(
//                               autofocus: false,
//                               controller: _emailController,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .subtitle1
//                                   .copyWith(color: Colors.white),
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Please enter UserId';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _email = value;
//                               },
//                               cursorColor: Colors.white,
//                               decoration: InputDecoration(
//                                   prefixIcon: Container(
//                                     child: Icon(FontAwesomeIcons.userAlt,
//                                         size: 20.0,
//                                         color: Theme.of(context).primaryColor),
//                                   ),
//                                   isDense: true,
//                                   filled: true,
//                                   fillColor: Color(0xff538FFB).withOpacity(0.5),
//                                   border: new OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                     borderRadius: const BorderRadius.all(
//                                       const Radius.circular(10.0),
//                                     ),
//                                   ),
//
//                                   enabledBorder: new OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                     borderRadius: const BorderRadius.all(
//                                       const Radius.circular(10.0),
//                                     ),
//                                   ),
//                                   disabledBorder: new OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                     borderRadius: const BorderRadius.all(
//                                       const Radius.circular(10.0),
//                                     ),
//                                   ),
//                                   focusedBorder: new OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                     borderRadius: const BorderRadius.all(
//                                       const Radius.circular(10.0),
//                                     ),
//                                   ),
//                                   focusedErrorBorder: new OutlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.redAccent),
//                                     borderRadius: const BorderRadius.all(
//                                       const Radius.circular(10.0),
//                                     ),
//                                   ),
//                                   errorBorder: new OutlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.redAccent),
//                                     borderRadius: const BorderRadius.all(
//                                       const Radius.circular(10.0),
//                                     ),
//                                   ),
//                                   hintText: "UserId",
//                                   hintStyle: Theme.of(context)
//                                       .textTheme
//                                       .subtitle1
//                                       .copyWith(color: Colors.white)),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 5.0),
//                             padding:
//                                 const EdgeInsets.only(top: 12.0, bottom: 5.0),
//                             child: TextFormField(
//                               autofocus: false,
//                               controller: _passwordController,
//                               obscureText: visibility,
//                               cursorColor: Colors.white,
//                               onSaved: (value) {
//                                 _password = value;
//                               },
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .subtitle1
//                                   .copyWith(color: Colors.white),
//                               validator: (value) {
//                                 if (value == null || value.length == 0) {
//                                   return "Password Field can not empty";
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 suffix: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       visibility = !visibility;
//                                     });
//                                   },
//                                   child: visibility
//                                       ? Icon(
//                                           Icons.visibility_off,
//                                           color: Colors.white,
//                                         )
//                                       : Icon(
//                                           Icons.visibility,
//                                           color: Colors.white,
//                                         ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Color(0xff538FFB).withOpacity(0.5),
//                                 prefixIcon: Container(
//                                   child: Icon(FontAwesomeIcons.key,
//                                       size: 20.0,
//                                       color: Theme.of(context).primaryColor),
//                                 ),
//                                 isDense: true,
//                                 border: new OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                   borderRadius: const BorderRadius.all(
//                                     const Radius.circular(10.0),
//                                   ),
//                                 ),
//                                 enabledBorder: new OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                   borderRadius: const BorderRadius.all(
//                                     const Radius.circular(10.0),
//                                   ),
//                                 ),
//                                 disabledBorder: new OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                   borderRadius: const BorderRadius.all(
//                                     const Radius.circular(10.0),
//                                   ),
//                                 ),
//                                 focusedBorder: new OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                   borderRadius: const BorderRadius.all(
//                                     const Radius.circular(10.0),
//                                   ),
//                                 ),
//                                 focusedErrorBorder: new OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.redAccent),
//                                   borderRadius: const BorderRadius.all(
//                                     const Radius.circular(10.0),
//                                   ),
//                                 ),
//                                 errorBorder: new OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.redAccent),
//                                   borderRadius: const BorderRadius.all(
//                                     const Radius.circular(10.0),
//                                   ),
//                                 ),
//                                 hintText: "Password",
//                                 hintStyle: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1
//                                     .copyWith(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Center(
//                             child: GestureDetector(
//                               child: RotateTransition(
//                                   Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 25.0,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                   animation1),
//                               onTap: () async {
//                                 SystemChannels.textInput
//                                     .invokeMethod('TextInput.hide');
//                                 if (_formKey.currentState.validate()) {
//                                   _formKey.currentState.save();
//                                   _rotateChildContinuously();
//                                   // clear the data from field
//                                   var user = jsonEncode({
//                                     "username": _email.trim(),
//                                     "password": _password.trim()
//                                   });
//                                   await appState.loginUser(user);
//                                   if (appState.isLoadin) {
//                                     _progressDialog.show();
//                                   } else {
//                                     _progressDialog.hide();
//                                   }
//
//                                   if (appState.isError) {
// //                                      TODO: appState.errorMessage (data is not comming)
//                                     final snackBar = SnackBar(
//                                       backgroundColor:
//                                           Theme.of(context).accentColor,
//                                       content: Text(
//                                         "Invalid User name or password",
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     );
//                                     _scaffoldKey.currentState
//                                         .showSnackBar(snackBar);
//                                   } else {
//                                     /*
//                                           SharedPreferences preferences =
//                                               await SharedPreferences.getInstance();
//
//                                           await preferences.setString(
//                                               "REFRESH_TOKEN",
//                                               appState.getToken.refreshtoken);
//
//                                           setState(() {
//                                             refreshGlobalToken = preferences
//                                                 .getString('REFRESH_TOKEN');
//                                             accessGlobalToken = appState.getToken.token;
//                                             //print(accessGlobalToken);
//                                           });
//
//                                            */
//                                     _emailController.clear();
//                                     _passwordController.clear();
//                                     print("working--------------->");
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               DashboardScreen(),
//                                         ));
//                                     print("elas");
//                                   }
//                                 } else {
//                                   //If all data are not valid then start auto validation.
//                                   setState(() {
//                                     _autoValidate = true;
//                                   });
//                                 }
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//
//                 /*
//                 Center(
//                   child: AnimatedBuilder(
//                     animation: animationController,
//                     builder: (context, child) {
//                       return Container(
//                         decoration: ShapeDecoration(
//                           color: Colors.white.withOpacity(0.5),
//                           shape: CircleBorder(),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(8.0 * animationController.value),
//                           child: child,
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: ShapeDecoration(
//                         color: Colors.white,
//                         shape: CircleBorder(),
//                       ),
//                       child: IconButton(
//                         onPressed: () async {
//                           SystemChannels.textInput.invokeMethod('TextInput.hide');
//                           if (_formKey.currentState.validate()) {
//                             _formKey.currentState.save();
//
//                             // clear the data from field
//                             var user = jsonEncode({
//                               "username": _email.trim(),
//                               "password": _password.trim()
//                             });
//                             await appState.loginUser(user);
//                             if (appState.isLoadin) {
//                               _progressDialog.show();
//                             } else {
//                               _progressDialog.hide();
//                             }
//
//                             if (appState.isError) {
// //                                      TODO: appState.errorMessage (data is not comming)
//                               final snackBar = SnackBar(
//                                 backgroundColor: Theme.of(context).accentColor,
//                                 content: Text(
//                                   "Invalid User name or password",
//                                   textAlign: TextAlign.center,
//
//                                 ),
//                               );
//                               _scaffoldKey.currentState.showSnackBar(snackBar);
//                             } else {
//                               /*
//                                           SharedPreferences preferences =
//                                               await SharedPreferences.getInstance();
//
//                                           await preferences.setString(
//                                               "REFRESH_TOKEN",
//                                               appState.getToken.refreshtoken);
//
//                                           setState(() {
//                                             refreshGlobalToken = preferences
//                                                 .getString('REFRESH_TOKEN');
//                                             accessGlobalToken = appState.getToken.token;
//                                             //print(accessGlobalToken);
//                                           });
//
//                                            */
//                               _emailController.clear();
//                               _passwordController.clear();
//                               print("working--------------->");
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => DashboardScreen(),
//                                   ));
//                               print("elas");
//                             }
//                           } else {
//                             //If all data are not valid then start auto validation.
//                             setState(() {
//                               _autoValidate = true;
//                             });
//                           }
//                         },
//                         color: Colors.blue,
//                         icon: Icon(Icons.arrow_forward_ios, size: 25),
//                       ),
//                     ),
//                   ),
//                 )
//
//                 */
//               ],
//             ),
//           )
          ),
    );
  }

  _rotateChildContinuously() {
    setState(() {
      animationController.forward(from: 0);
    });
  }
}

class RotateTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  RotateTransition(this.child, this.animation);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Color(0xff187bcd),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.transparent, width: 2.0),
              // color: Colors.transparent,
              boxShadow: [
                // BoxShadow(
                //     color: Colors.grey, blurRadius: 0.5, spreadRadius: 1.0)
              ]),
          child: Transform.rotate(
            angle: animation.value,
            child: Container(
              color: Colors.transparent,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
