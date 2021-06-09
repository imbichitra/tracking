import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/organization/organization.dart';
import 'package:mcs_tracking/StateManagement/Organization/organization_provider.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class VehicleParametersScreen extends StatefulWidget {
  @override
  _VehicleParametersScreenState createState() =>
      _VehicleParametersScreenState();
}

class _VehicleParametersScreenState extends State<VehicleParametersScreen> {
  String overSpeed,
      overUtilizedHours,
      overUtilizedKms,
      underSpeed,
      underUtilizedHours,
      underUtilizedKms,
      fuelAlert,
      orgName;
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  List orgNameList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OrganizationStateManagement>(context, listen: false)
        .getOrganizationList
        .forEach((element) {
      orgNameList.add(element.orgRefName);
    });

    return Container(
      child: Column(
        children: [
          SingleChildScrollView(child: getFormContents()),
          RaisedGradientButton(
            child: Text('Add Parameters'),
            gradient: buttonColor,
            onPressed: () async {

            },
          ),
        ],
      ),
    );
  }

  Widget getFormContents() {
    return Container(
      child: Form(
        key: formKey,
        autovalidateMode: autoValidate,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Over Speed(Km/Hr)",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)),
                validator: (value) {
                  if (value.length == 0) {
                    return "Required field can not be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  overSpeed = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Over Utilized Hours",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)),
                validator: (value) {
                  if (value.length == 0) {
                    return "Required field can not be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  overUtilizedHours = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Over Utilized Kms",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)),
                validator: (value) {
                  if (value.length == 0) {
                    return "Required field can not be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  overUtilizedKms = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Under Speed(Km/Hr)",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)),
                validator: (value) {
                  if (value.length == 0) {
                    return "Required field can not be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  underSpeed = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Under Utilized Kms(Km)",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)),
                validator: (value) {
                  if (value.length == 0) {
                    return "Required field can not be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  underUtilizedKms = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Fuel Alert(%)",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)),
                validator: (value) {
                  if (value.length == 0) {
                    return "Required field can not be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  fuelAlert = value;
                },
              ),
            ),
            Container(
              child: Consumer<OrganizationStateManagement>(builder: (
                final BuildContext context,
                final OrganizationStateManagement orgStateManagement,
                final Widget child,
              ) {
                return DropdownButton<String>(
                  value: orgName == null
                      ? orgStateManagement.getOrganizationList[0]?.orgRefName
                      : orgName,
                  items: orgStateManagement.getOrganizationList
                      .map<DropdownMenuItem<String>>(
                          (Organization organization) {
                    return DropdownMenuItem<String>(
                        child: Text(organization.orgRefName.toString()),
                        value: organization.orgRefName.toString());
                  }).toList(),
                  onChanged: (String newValue) {
                    orgName = newValue;
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
