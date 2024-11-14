import 'package:darb/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerController extends GetxController {
  String? name = prefs!.getString("name");
  TextEditingController LocationTitel = TextEditingController();
  TextEditingController wilaya = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController building = TextEditingController();
  TextEditingController custom_instructions = TextEditingController();
  var isdefoultlocation = false.obs;
  var marker = <Marker>[].obs;
  var initialPosition = LatLng(23.614328, 58.545284).obs;
  String userid = prefs!.getString("userid").toString();

  // Observable list to store locations
  var userLocations = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Set up a real-time listener for Firestore data
    userLocations.bindStream(locationStream());
  }

  // Real-time stream from Firestore
  Stream<List<QueryDocumentSnapshot>> locationStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .collection("location")
        .snapshots()
        .map((query) => query.docs);
  }

  Future<void> addLocation(GlobalKey<FormState> addform) async {
    if (!addform.currentState!.validate()) return;

    // Prepare location data
    Map<String, dynamic> locationData = {
      'title': LocationTitel.text,
      'wilaya': wilaya.text,
      'city': city.text,
      'building': building.text,
      'custom_instructions': custom_instructions.text,
      'is_default': isdefoultlocation.value,
      "latlong":
          GeoPoint(marker[0].position.latitude, marker[0].position.longitude),
    };

    // Check if the new location is set as default
    if (isdefoultlocation.value) {
      // Make other locations 'is_default' => false
      var userLocationsRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userid)
          .collection("location");

      // Update all other locations to 'is_default' => false
      var querySnapshot =
          await userLocationsRef.where('is_default', isEqualTo: true).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'is_default': false});
      }
    }

    // Add the new location
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userid)
          .collection("location")
          .add(locationData);

      Get.back(); // Close the dialog

      Get.snackbar("Success", "Location added successfully");

      //clear text controller
      LocationTitel.clear();
      wilaya.clear();
      city.clear();
      building.clear();
      custom_instructions.clear();
      isdefoultlocation.value = false;
    } catch (error) {
      print("Failed to add location: $error");
      Get.snackbar("Failed", "Failed to add location: $error, try again");
    }
  }

  Future<void> deleteLocation(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection("location")
          .doc(docId)
          .delete();
    } catch (e) {
      print("Error deleting location: $e");
    }
  }

  Future<void> setDefaultLocation(String docId) async {
    try {
      // Set all other locations to 'is_default' = false
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection("location")
          .where('is_default', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'is_default': false});
      }

      // Set the selected location to 'is_default' = true
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection("location")
          .doc(docId)
          .update({'is_default': true});
    } catch (e) {
      print("Error setting default location: $e");
    }
  }

  void addCustomPoint(LatLng point) {
    if (marker.isNotEmpty) {
      marker[0] = (Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    } else {
      marker.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    }
  }
}

class cooslocationcontroller extends GetxController {
  @override
  void onReady() {
    chooslocationinstruction();
    super.onReady();
  }

  void chooslocationinstruction() {
    Get.defaultDialog(
      title: "Add your location",
      middleText:
          "navigate to your location and add point by cliking in the map",
    );
  }
}
