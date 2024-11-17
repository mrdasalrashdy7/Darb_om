import 'package:darb/controller/Company_Controller.dart';
import 'package:darb/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

logout() async {
  await FirebaseAuth.instance.signOut();
  prefs!.clear();
  Get.offAllNamed("/middleware");
}
