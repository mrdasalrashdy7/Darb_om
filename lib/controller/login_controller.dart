import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      String? uid = userCredential.user?.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String role = userDoc['role']; // Default to 'Student'
      String name = userDoc['name'];

      prefs!.setString("role", role);
      prefs!.setString("username", name);
      prefs!.setString("userid", uid!);

      Get.offNamed("home");
    } catch (e) {
      print("faild to login with firbase, because $e");
    }
  }
}
