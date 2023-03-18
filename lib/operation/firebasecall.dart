import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class AuthenticationHelper {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //SIGN UP METHOD
  static Future signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = e.message!;
      }
      return errorMessage;
    }
  }

  static Future createUserwithpassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = e.message!;
      }
      return errorMessage;
    }
  }

  //SIGN IN METHOD
  static Future signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      debugPrint(e.message);
      debugPrint(e.code);

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = e.message!;
      }
      return errorMessage;
    }
  }

  //SIGN OUT METHOD
  static Future signOut() async {
    try {
      await auth.signOut();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  static Future<String?> userDetailSetup(
      username, email, role, password, String randomAvatarString) async {
    User? user = auth.currentUser;
    CollectionReference userCollection = firebaseFirestore.collection('users');
    try {
      userCollection.doc(user!.uid.toString()).set({
        'uid': user.uid.toString(),
        'role': role.toString(),
        'username': username,
        'email': email,
        'password': password,
        'displayImage':
            RandomAvatarString(generateRandomString(10), trBackground: true),
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  static Future<bool> changePassword(
      BuildContext context,
      List<String?>? userData,
      String currentPassword,
      String newPassword) async {
    bool success = false;

    User user = FirebaseAuth.instance.currentUser!;
    // debugPrint("XXXXXXX: ${user.email}");
    CollectionReference userCollection = firebaseFirestore.collection('users');
    final cred = EmailAuthProvider.credential(
        email: userData![1]!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
        userCollection.doc(user.uid).update({"password": newPassword});
      }).catchError((error) {
        debugPrint("ERRROOOOOR: $error");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      });
    }).catchError((err) {
      debugPrint("ERRROOOOOR: $err");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    });

    return success;
  }
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
