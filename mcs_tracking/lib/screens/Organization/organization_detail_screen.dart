import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcs_tracking/Models/organization/organization.dart';
import 'package:mcs_tracking/StateManagement/Organization/organization_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:provider/provider.dart';

class OrganizationDetailView extends StatefulWidget {
//  final Map object;
  final Organization object;

  OrganizationDetailView({this.object});

  @override
  _OrganizationDetailViewState createState() => _OrganizationDetailViewState();
}

class _OrganizationDetailViewState extends State<OrganizationDetailView> {
  String _appbarTitle = 'Organization  Details';
  GlobalKey<FormState> _formkey = GlobalKey();
  String _orgRefName;
  String _orgName;
  String _description;
  String _raisedGradientButtonTitle = 'Update';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  bool _status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _orgName = widget.object.orgName;
    _orgRefName = widget.object.orgRefName;
    _description = widget.object.description;
    _status = widget.object.status;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                _appbarTitle,
                style: Theme.of(context).textTheme.headline3,
              ),
              elevation: 0,
              centerTitle: true,
              actions: [
                CupertinoSwitch(
                  activeColor: Colors.green,
                  trackColor: Colors.red,
                  value: _status,
                  onChanged: (bool value) async {
                    setState(() {
                      _status = value;
                    });
                    print("--------------------------->");
                    print(value);

                    Organization updatedOrganization =
                        await Provider.of<OrganizationStateManagement>(context,
                                listen: false)
                            .statusUpdate(widget.object.orgId, _status);
                    if (updatedOrganization != null) {
                      List<Organization> listOfOrganization =
                          Provider.of<OrganizationStateManagement>(context,
                                  listen: false)
                              .getOrganizationList;

                      for (var obj in listOfOrganization) {
                        if (obj?.orgId == widget.object.orgId) {
                          obj.status = updatedOrganization?.status;
                        }
                      }
                      if (updatedOrganization.status) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Organization Enable"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Theme.of(context).accentColor,
                        ));
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Organization Disable"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Theme.of(context).accentColor,
                        ));
                      }
                    } else {
                      setState(() {
                        _status = !_status;
                      });
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("ops!! something went wrong"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Theme.of(context).accentColor,
                      ));
                    }
                  },
                ),
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(top: 100.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: _getFormContents(),
                ),
              ),
            ),
          );
  }

  Widget _getFormContents() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: TextFormField(
                initialValue: _orgRefName,
                onChanged: (value) {
                  setState(() {
                    _orgRefName = value;
                  });
                },
                validator: (value) {
                  if (value.length > 10 || value.length < 3) {
                    return "Organization Ref name should be 3 to 10 letters";
                  } else
                    return null;
                },
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: enableBorder,
                    disabledBorder: disableBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errorBorder,
                    labelText: "Organization Name",
                    labelStyle: Theme.of(context).textTheme.subtitle1),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                initialValue: _orgName,
                onChanged: (value) {
                  setState(() {
                    _orgName = value;
                  });
                },
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                    isDense: true,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errorBorder,
                    labelText: "Organization Name",
                    labelStyle: Theme.of(context).textTheme.subtitle1),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                initialValue: _description,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                    isDense: true,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errorBorder,
                    labelText: "Description",
                    labelStyle: Theme.of(context).textTheme.subtitle1),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedGradientButton(
              child: Text(_raisedGradientButtonTitle.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: Colors.white)),
              gradient: buttonColor,
              onPressed: () {
                _updateValue();
              },
            )
          ],
        ),
      ),
    );
  }

  void _updateValue() async {
    if (_formkey.currentState.validate()) {
      
      _formkey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      Map<String, dynamic> organization = {
        "orgId": widget.object.orgId,
        "orgRefName": _orgRefName,
        "orgName": _orgName,
        "description": _description
      };

      int statusCode =
          await Provider.of<OrganizationStateManagement>(context, listen: false)
              .updateOrganization(jsonEncode(organization));
      Provider.of<OrganizationStateManagement>(context, listen: false)
          .getOrganizations();
      if (statusCode == 200) {
        showCustomSnackBar("Successfully Updated");
      } else if (statusCode == 409) {
        showCustomSnackBar(
            "Organization Reference name already exist !! please try some other name");
      } else {
        showCustomSnackBar("Ops !! can not update");
      }
    }
  }

  void showCustomSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ));
  }
}
