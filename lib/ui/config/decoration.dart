import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const kTitleEditInfoInputDecoration = InputDecoration(
  border: OutlineInputBorder(),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
  labelText: "Title",
  labelStyle: TextStyle(color: Colors.white),
);

const kBottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
  ),
);

const kAddAccountTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'Name your new account',
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
  ),
);

const kEmailTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'Email',
  prefixIcon: Icon(
    FontAwesomeIcons.solidEnvelope,
    size: 20.0,
  ),
  prefixIconConstraints: BoxConstraints.tightFor(width: 50, height: 30),
);

const kPasswordTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'Password',
  prefixIcon: Icon(
    FontAwesomeIcons.key,
    size: 20.0,
  ),
  prefixIconConstraints: BoxConstraints.tightFor(width: 50, height: 30),
);

const kConfirmPasswordTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'Confirm Password',
  prefixIcon: Icon(
    FontAwesomeIcons.lock,
    size: 20,
  ),
  prefixIconConstraints: BoxConstraints.tightFor(width: 50, height: 30),
);

InputDecoration kFormInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(3.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(3.0)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.circular(3.0)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(3.0)),
    labelText: "Label",
    labelStyle: TextStyle(color: Colors.grey));
