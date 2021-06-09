import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';



class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {


  String _firstName;
  String _lastName;
  String _contactNumber;
  String _contactEmail;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: Theme
              .of(context)
              .textTheme
              .headline3,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: _getFormContents(),
        ),
      ),
    );
  }

  Widget _getFormContents(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Column(
        children: [
          SearchBar(
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
            headerPadding: EdgeInsets.symmetric(horizontal: 10),
            listPadding: EdgeInsets.symmetric(horizontal: 10),
            onSearch: null,
            searchBarController: null,
            placeHolder: Text("Search"),
            cancellationWidget: Text("Cancel"),
            emptyWidget: Text("empty"),
            onItemFound: null,
          ),
          SizedBox(
            height: 10,
          ),
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
            child: Text('Reset Password',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6
                    .apply(
                  color: Colors.white,
                )),
            gradient: buttonColor,
            onPressed: () {
              // submit();
            },
          )
        ],
      ),
    );
  }
}
