import 'package:flutter/material.dart';
import 'package:mcs_tracking/constant.dart';

class VehicleDetailEdit extends StatefulWidget {
  @override
  _VehicleDetailEditState createState() => _VehicleDetailEditState();
}

class _VehicleDetailEditState extends State<VehicleDetailEdit> {
  GlobalKey<FormState> _formkey = GlobalKey();
  bool _autoValidate = false;
  FocusNode _vehicleNoFocusNode = FocusNode();
  // FocusNode _vehicleModelNoFocusNode = FocusNode();
  FocusNode _vehicleModelTypeFocusNode = FocusNode();
  FocusNode _vehicleOwnerNameFocusNode = FocusNode();
  FocusNode _vehicleOwnerNumberFocusNode = FocusNode();
  FocusNode _driverNameFocusNode = FocusNode();
  FocusNode _driverNumberFocusNode = FocusNode();

  String _buttonTitle = 'Update';
  bool _isActivate = true;
  bool _autoFocus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Vehicle Information'),
        centerTitle: true,
        flexibleSpace: getAppbarGradient(),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: _getFormContents(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('Delete'),
        icon: Icon(Icons.delete),
        backgroundColor: foregroundColor,
      ),
    );
  }

  Widget _getFormContents() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Container(
            child: TextFormField(
              enabled: _isActivate,
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              // initialValue: _trackerImeiNo,
              validator: null,
              focusNode: _vehicleNoFocusNode,
              onFieldSubmitted: (v) {
                _fieldFocusChange(
                    context, _vehicleNoFocusNode, _vehicleModelTypeFocusNode);
              },
              style: inputTextStyle,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: labelTextStyle,
                  labelText: 'Vehicle Number',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              enabled: _isActivate,
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              // initialValue: _trackerModelName,
              validator: null,
              focusNode: _vehicleModelTypeFocusNode,
              onFieldSubmitted: (v) {
                _fieldFocusChange(
                    context, _vehicleModelTypeFocusNode, _vehicleOwnerNameFocusNode);
              },
              style: inputTextStyle,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: labelTextStyle,
                  labelText: 'Vehicle Model Type',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              enabled: _isActivate,
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              // initialValue: _trackerModelName,
              validator: null,
              focusNode: _vehicleOwnerNameFocusNode,
              onFieldSubmitted: (v) {
                _fieldFocusChange(context, _vehicleOwnerNameFocusNode,
                    _vehicleOwnerNumberFocusNode);
              },
              style: inputTextStyle,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: labelTextStyle,
                  labelText: 'Vehicle Owner Name',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              enabled: _isActivate,
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              // initialValue: _trackerModelName,
              validator: null,
              focusNode: _vehicleOwnerNumberFocusNode,
              onFieldSubmitted: (v) {
                _fieldFocusChange(context, _vehicleOwnerNumberFocusNode,
                    _driverNameFocusNode);
              },
              style: inputTextStyle,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: labelTextStyle,
                  labelText: 'Vehicle Owner Number',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              enabled: _isActivate,
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              // initialValue: _trackerModelName,
              validator: null,
              focusNode: _driverNameFocusNode,
              onFieldSubmitted: (v) {
                _fieldFocusChange(context, _driverNameFocusNode,
                    _driverNumberFocusNode);
              },
              style: inputTextStyle,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: labelTextStyle,
                  labelText: 'Driver Name',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              enabled: _isActivate,
              autofocus: _autoFocus,
              autovalidate: _autoValidate,
              // initialValue: _trackerModelName,
              validator: null,
              focusNode: _driverNumberFocusNode,
              onFieldSubmitted: (v) {
                _driverNumberFocusNode.unfocus();
              },
              style: inputTextStyle,
              decoration: InputDecoration(
                  enabledBorder: enableBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disableBorder,
                  errorBorder: errorBorder,
                  labelStyle: labelTextStyle,
                  labelText: 'Driver Number',
                  isDense: true),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Material(
            elevation: 5,
            child: RaisedGradientButton(
              child: Text(_buttonTitle),
              onPressed: () {},
              gradient: buttonColor,
            ),
          )
        ],
      ),
    );
  }

  /// method : _fieldFocusChange
  /// description : This method is used change the focus,
  /// on success :
  /// on Fail:
  /// written by : Asiczen
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

// _vechileModelTypeFocusNode.unfocus();