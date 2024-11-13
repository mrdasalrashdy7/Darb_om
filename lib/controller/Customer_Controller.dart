import 'package:darb/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  String? name = prefs!.getString("name");
  TextEditingController LocationTitel = TextEditingController();
  TextEditingController wilaya = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController building = TextEditingController();
  TextEditingController custom_instructions = TextEditingController();
  var isdefoultlocation = false.obs;
}
