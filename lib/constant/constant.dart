import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { ADMIN, VIEWER }

enum FormValidation { PENDING, SUCCESS, FAILED }

emailValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your email';
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

passwordValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your password';
  } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
      .hasMatch(value)) {
    return 'Password must must contain at least 1 capital ,1 symbol, minimum 8 characters';
  }
  return null;
}

usernameValidator(value) {
  if (value.isEmpty) {
    return 'Username cannot be empty';
  } else if (value.length > 10) {
    return 'Username should not be more than 10 characters';
  } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
    return 'Username should contain only alphanumeric characters';
  }
  return null;
}

void snackBarMSG(BuildContext context,
    {required String message, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.red,
    ),
  );
}

class SharedPref {
  SharedPref._();
  static late SharedPreferences sharedPreference;

  static Future setUserdata(String username, String email, String role,
      String uid, String svgstring, String password) async {
    sharedPreference = await SharedPreferences.getInstance();
    return Future.value(sharedPreference.setStringList(
        'userdata', <String>[username, email, role, uid, svgstring, password]));
  }

  static Future<List<String>> getUserData() async {
    sharedPreference = await SharedPreferences.getInstance();
    return Future.value(sharedPreference.getStringList('userdata'));
  }

  static Future clearUserData() async {
    sharedPreference = await SharedPreferences.getInstance();
    return Future.value(sharedPreference.remove("userdata"));
  }


}
