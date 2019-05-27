//import 'package:flutter/material.dart';

class ValidatorMixin {
  String validateEmail(String value) {
    return isEmpty(value) ? 'Email can\'t be empty' : null;
  }

  String validatePassword(String value) {
    return isEmpty(value) ? 'Password can\'t be empty' : null;
  }

  bool isEmpty(String value) {
    return value.isEmpty ? true : false;
  }
}
