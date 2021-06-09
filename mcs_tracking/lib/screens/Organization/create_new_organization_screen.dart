import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcs_tracking/Animation/FadeAnimation.dart';
import 'package:mcs_tracking/Models/organization/organization.dart';
import 'package:mcs_tracking/StateManagement/Organization/organization_provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/screens/organization/organizationlist_screen.dart';
import 'package:provider/provider.dart';

class CreateNewOrganization extends StatefulWidget {
  @override
  _CreateNewOrganizationState createState() => _CreateNewOrganizationState();
}

class _CreateNewOrganizationState extends State<CreateNewOrganization> {
  GlobalKey<FormState> _formkey = GlobalKey();

  bool _autoValidate = false;
  String organizationName;
  String organizationRefName;
  String desciption;
  String firstName;
  String lastName;
  String contactNumber;
  String email;

  bool hasValidate = false;
  bool start = true;

  bool get canSubmitForm => hasValidate;

  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _orgRefNameController = TextEditingController();

  void checkAvalabilityOrgRefName(String orgRefName) async {
    int statusCode =
        await Provider.of<OrganizationStateManagement>(context, listen: false)
            .checkAvailability(orgRefName);

    if (statusCode != 200) {
      setState(() {
        hasValidate = false;
      });
    }
    if (statusCode == 200) {
      setState(() {
        hasValidate = true;
      });
    }

    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orgRefNameController.addListener(() {
      final orgRefInput = _orgRefNameController.value.text;
      if (orgRefInput.isNotEmpty) {
        checkAvalabilityOrgRefName(orgRefInput);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FadeAnimation(
        1.5,
        Container(
          margin: EdgeInsets.only(top: 5.0,bottom: 10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              autovalidate: _autoValidate,
              child: _getFormContents(),
            ),
          ),
        ),
      ),
    );
  }

  /// method : _getFormContents
  /// description : This method is used to get the Form contents widgets,
  ///               Here Container widget contains all the elements of form
  /// on success : returnContainer widget
  /// on Fail: None
  /// written by : Asiczen
  Widget _getFormContents() {
    return  Container(
        padding: const EdgeInsets.symmetric(horizontal:30.0),
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: _orgRefNameController,
                autovalidate: _autoValidate,
                onChanged: (val){
                  setState(() {
                    start = false;
                  });
                },
                decoration: new InputDecoration(
                    labelText: "Organization Reference Name",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    // hintText: 'e.g XYZ Inc',
                    hintStyle: hintTextStyle,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12),
                    suffixIcon:start? Container(
                      width: 10.0,
                    ):hasValidate
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          )
                    // fillColor: Colors.green
                    ),
                validator: (value) {
                  if (value.length == 0) {
                    return "Required field can not be empty";
                  } else if (value.contains(" ")) {
                    return "Should not contain space";
                  } else if (value.length < 3 || value.length > 10) {
                    return "orgRefName should be between 3 to 10 characters";
                  }
                  if (!hasValidate) {
                    return "Org ref already exist";
                  }

                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline6,
                onSaved: (orgRefName) {
                  organizationRefName = orgRefName;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,

                autovalidate: _autoValidate,
                decoration: new InputDecoration(
                    labelText: "Organization Name",
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

                onSaved: (orgName) {
                  organizationName = orgName;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                autovalidate: _autoValidate,
                decoration: new InputDecoration(
                    labelText: "Description",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    // filled: false,
                    // fillColor: Color(0xFFF2F2F2),
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)
                    // fillColor: Colors.green
                    ),
                // validator: validateEmail,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.headline6,
                validator: _validateFormInputs,

                onSaved: (value) {
                  desciption = value;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,

                autovalidate: _autoValidate,
                decoration: new InputDecoration(
                    labelText: "First Name",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    // filled: false,
                    // fillColor: Color(0xFFF2F2F2),
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)
                    // fillColor: Colors.green
                    ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: _validateFormInputs,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  firstName = value;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,

                autovalidate: _autoValidate,
                decoration: new InputDecoration(
                    labelText: "Last Name",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    // filled: false,
                    // fillColor: Color(0xFFF2F2F2),
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)
                    // fillColor: Colors.green
                    ),
                validator: _validateFormInputs,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  lastName = value;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,

                autovalidate: _autoValidate,
                decoration: new InputDecoration(
                    labelText: "Email",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    // filled: false,
                    // fillColor: Color(0xFFF2F2F2),
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    // hintText: 'e.g Xyz company',
                    hintStyle: hintTextStyle,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)
                    // fillColor: Colors.green
                    ),
                validator: _emailValidation,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  email = value;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: TextFormField(
                // autofocus: true,

                autovalidate: _autoValidate,
                decoration: new InputDecoration(
                    labelText: "Contact Number",
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    // filled: false,
                    // fillColor: Color(0xFFF2F2F2),
                    focusedBorder: focusedBorder,
                    disabledBorder: disableBorder,
                    enabledBorder: enableBorder,
                    border: border,
                    errorBorder: errorBorder,
                    focusedErrorBorder: focusedBorder,
                    // hintText: 'e.g Xyz company',
                    hintStyle: hintTextStyle,
                    isDense: true,
                    contentPadding: EdgeInsets.all(12)
                    // fillColor: Colors.green
                    ),
                validator: (value) {
                  if (value.length < 10 || value.length > 10) {
                    return "Contact number should be 10 digits";
                  }
                  if (double.tryParse(value) == null) {
                    return "Should contain digits";
                  }

                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.headline6,

                onSaved: (value) {
                  contactNumber = value;
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedGradientButton(
              child: Text('Add Organization'),
              gradient: buttonColor,
              onPressed: () async {
                _validateForm();
              },
            ),
          ],
        ),
    );
  }

  String _validateFormInputs(String text) {
    if (text.length == 0) {
      return 'This Field can not be empty';
    }

    return null;
  }

  String _emailValidation(String email) {
    if (EmailValidator.validate(email)) {
      return null;
    }
    return 'Invalid email';
  }

  void _validateForm() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Organization organization = Organization(
          orgName: organizationName,
          orgRefName: organizationRefName,
          description: desciption,
          firstName: firstName,
          lastName: lastName,
          contactEmail: email,
          contactNumber: contactNumber);

      Map<String, dynamic> data = organization.toJson();

      int statusCode =
          await Provider.of<OrganizationStateManagement>(context, listen: false)
              .createOrganization(data);

      if (statusCode == 201) {
        Provider.of<OrganizationStateManagement>(context, listen: false)
            .getOrganizations();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).accentColor,
            content: Text('Organization Added Successfully')));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OrganizationList()));
      } else if (statusCode == 409) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).accentColor,
            content: Text('Ops!! organization reference already exist')));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,

            backgroundColor: Theme.of(context).accentColor,
            content: Text('Ops!! can not add organization',textAlign: TextAlign.center,)));
      }

      /*
      organizationController
          .postOrganization(
          organizationRefName,
          organizationName,
          desciption,
          firstName,
          lastName,
          email,
          contactNumber,
          accessGlobalToken)
          .then((value) {
        if (value != null) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text('Organization Added Successfully')));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OrganizationList()));
        }
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Text('oops !! can not add organization')));

        print(value);
      }).catchError((err) => print(err));

       */
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blueAccent,
      content: Text(text),
      elevation: 7.0,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
