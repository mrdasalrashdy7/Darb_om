import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conirmpassword = TextEditingController();
  TextEditingController phone = TextEditingController();
  var roleselected = "customer".obs;

  signup() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'id': userCredential.user?.uid,
        'name': name.text.trim(),
        'phone': phone.text.trim(),
        'email': email.text.trim(),
        'role': roleselected.value,
      });
      Get.offNamed("home");
    } catch (e) {
      print("faild to signup with firbase, because $e");
    }
  }
}
