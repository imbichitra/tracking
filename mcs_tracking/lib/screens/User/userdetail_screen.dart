import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/user/user.dart';
import 'package:mcs_tracking/constant.dart';


class UserDetailScreen extends StatelessWidget {
  final User object;
  UserDetailScreen({this.object});

  String email;
  String userName;
  String firstName;
  String lastName;

  final GlobalKey _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    email = object.email;
    userName = object.userName;
    firstName = object.firstName;
    lastName = object.lastName;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Detail",
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50,left: 20.0,right: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: getFormContents(context),
          ),
        ),
      ),
    );
  }

  Widget getFormContents(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Container(
            child: TextFormField(
              initialValue: email,
              validator: (String value){
                if(value.length == 0){
                  return "Required field can not be empty";
                }
                if(!RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)){
                  return "Not a valid email";
                }
                return null;
              },
              onChanged: (value) {
                email = value;
              },
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Email',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              initialValue: firstName,
              validator: (value){
                if(value.length==0){
                  return "Required field an not be empty";
                }

                return null;
              },
              onChanged: (value) {
                firstName = value;
              },
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'First Name',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              initialValue: lastName,
              validator: (value){
                if(value.length==0){
                  return "Required field an not be empty";
                }

                return null;
              },
              onChanged: (value) {
                lastName = value;
              },
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  labelText: 'Last Name',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedGradientButton(
            child: Text(
              "Update",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .apply(color: Colors.white),
            ),
            onPressed: () {
            },
            // gradient: buttonColor,
          ),
        ],
      ),
    );
  }
}

