import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/main.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DriverController extends GetxController {
  TextEditingController tripName = TextEditingController();
  TextEditingController tripDate = TextEditingController();
  String? name = prefs!.getString("name");
  String userid = prefs!.getString("userid").toString();

  add_trip(name, date) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .collection("trips")
        .add({"name": "$name", "date": "$date"});
  }
}
