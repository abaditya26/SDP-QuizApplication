import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/screens/dashboard_page.dart';
import 'package:sdp_quiz_app/screens/home_page.dart';
import 'package:sdp_quiz_app/services/shared_pref.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> loginUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user!.uid;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return "";
    }
  }

  Future<String> registerUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user!.uid;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return "";
    }
  }

  void signOut(BuildContext context) {
    try {
      _auth.signOut().then((value) {
        SharedPrefMethods.saveUserLoginState(false, "");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false);
    }
  }
}
