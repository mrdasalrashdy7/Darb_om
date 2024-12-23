import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var errorMessage = ''.obs;
  var isLoading = false.obs;

  Future<void> login() async {
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
      errorMessage.value = "Email and password must not be empty.";
      return;
    }

    isLoading.value = true; // Indicate loading starts
    try {
      // Authenticate user
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      String? uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception("User ID is null after authentication.");
      }

      // Fetch user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore.");
      }

      Map<String, dynamic>? userData = userDoc.data();
      if (userData == null) {
        throw Exception("User data is null.");
      }

      // Safely fetch role and name
      String role = userData['role'] ?? 'Student';
      String name = userData['name'] ?? 'Unknown';
      String phone = userData['phone'] ?? 'Unknown';

      // Store data in shared preferences
      await prefs?.setString("role", role);
      await prefs?.setString("username", name);
      await prefs?.setString("userid", uid);
      await prefs?.setString("phone", phone);

      // Navigate to home page
      Get.offNamed("home");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage.value = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage.value = "Incorrect password.";
          break;
        case 'network-request-failed':
          errorMessage.value = "Network error. Please check your connection.";
          break;
        default:
          errorMessage.value = "An unknown error occurred.";
      }
    } catch (e) {
      errorMessage.value = "Login failed: $e";
    } finally {
      isLoading.value = false; // Indicate loading ends
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
