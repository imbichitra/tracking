import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Animation/FadeAnimation.dart';
import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/StateManagement/User/user_provider.dart';

import '../../constant.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final key = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _firstName;
  String _lastName;
  String _contactNumber;
  String _contactEmail;
  String _orgRefName;

  UserStateManagement _userStateManagement;

  @override
  void initState() {
    super.initState();
    _userStateManagement = UserStateManagement();
    _orgRefName = CurrentUserSingleton.getInstance.getCurrentUser.orgRefName;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Add User',
          style: Theme
              .of(context)
              .textTheme
              .headline3,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child:
              SingleChildScrollView(
                child: Form(
                  autovalidate: _autoValidate,
                  key: _formkey,
                  child: _getFormContents(),
                ),
              ),
            ),
    );
  }


  Widget _getFormContents(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) {
              _firstName = value;
            },
            validator: (value) {
              if(value.length == 0)
                return "Required field can not be empty";

                return null;
            },
            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .subtitle1,
              labelText: 'First Name',
              border: border,
              enabledBorder: enableBorder,
              focusedBorder: focusedBorder,
              disabledBorder: disableBorder,
              errorBorder: errorBorder,
              isDense: true,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) =>
            value.length == 0 ? "Required field can not be empty" : null,
            onSaved: (value) => _lastName = value,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
                labelText: 'Last Name',
                border: border,
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                isDense: true,
                contentPadding: EdgeInsets.all(12)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (!(value.length == 10)) {
                return "Contact number must contain 10 digits";
              }
              if (num.tryParse(value) == null) {
                return "Should contain number";
              }
              return null;
            },
            onSaved: (value) => _contactNumber = value,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
                labelText: 'Contact Number',
                border: border,
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                isDense: true,
                contentPadding: EdgeInsets.all(12)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value.length==0 || !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)) {
                return "Please enter correct email";
              }

              return null;
            },
            onSaved: (value) => _contactEmail = value,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
            decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
                labelText: 'Email',
                border: border,
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                disabledBorder: disableBorder,
                errorBorder: errorBorder,
                isDense: true,
                contentPadding: EdgeInsets.all(12)),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedGradientButton(
            child: Text('Add User',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6
                    .apply(
                  color: Colors.white,
                )),
            gradient: buttonColor,
            onPressed: () {
              submit();
            },
          )
        ],
      ),
    );
  }

  void submit() async{

    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      var data = jsonEncode({
        "orgRefName": _orgRefName,
        "contactNumber": _contactNumber,
        "userName": _contactEmail,
        "firstName": _firstName,
        "lastName": _lastName
      });

      _userStateManagement.postUser(data);
      key.currentState.showSnackBar(SnackBar(
        content: Text("User created"),
      ));

    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
