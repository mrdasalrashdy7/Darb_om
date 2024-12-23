import 'package:darb/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerController extends GetxController {
  String? name = prefs!.getString("username");
  TextEditingController LocationTitel = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController building = TextEditingController();
  TextEditingController custom_instructions = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  final GlobalKey<FormState> addform = GlobalKey();
  var selectedWilaya = "".obs;

  var isdefoultlocation = false.obs;
  var marker = <Marker>[].obs;
  var initialPosition = LatLng(23.614328, 58.545284).obs;
  String userid = prefs!.getString("userid").toString();
  final dropDownKey = GlobalKey<DropdownSearchState>();

  // Observable list to store locations
  var userLocations = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Set up a real-time listener for Firestore data
    userLocations.bindStream(locationStream());
    if (prefs!.getString("phone") != null) {
      phoneNo.text = prefs!.getString("phone").toString();
    }
  }

  // Real-time stream from Firestore
  Stream<List<QueryDocumentSnapshot>> locationStream() {
    return FirebaseFirestore.instance
        .collection('location')
        .where('userid', isEqualTo: userid)
        .snapshots()
        .map((query) => query.docs);
  }

  Future<void> addLocation(GlobalKey<FormState> addform) async {
    // Ensure marker has valid data
    if (marker.isEmpty) {
      Get.snackbar("Error", "Please set a valid location marker");
      return;
    }

    // Prepare location data
    Map<String, dynamic> locationData = {
      'userid': userid,
      'title': LocationTitel.text,
      'phone': phoneNo.text,
      'wilaya': selectedWilaya.value,
      'city': city.text,
      'building': building.text,
      'custom_instructions': custom_instructions.text,
      'is_default': isdefoultlocation.value,
      'latlong':
          GeoPoint(marker[0].position.latitude, marker[0].position.longitude),
    };

    // Check if the new location is set as default
    if (isdefoultlocation.value) {
      try {
        // Update all other locations to 'is_default' => false
        var userLocationsRef =
            FirebaseFirestore.instance.collection("location");
        var querySnapshot = await userLocationsRef
            .where('userid', isEqualTo: userid)
            .where('is_default', isEqualTo: true)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.update({'is_default': false});
        }
      } catch (error) {
        print("Failed to update default locations: $error");
        Get.snackbar(
            "Error", "Failed to update default locations. Please try again.");
        return;
      }
    }

    // Add the new location
    try {
      await FirebaseFirestore.instance.collection("location").add(locationData);

      Get.back(); // Close the dialog

      Get.snackbar("Success", "Location added successfully");

      // Clear text controllers
      LocationTitel.clear();
      selectedWilaya..value = "";
      city.clear();
      building.clear();
      phoneNo.clear();
      marker.clear();
      custom_instructions.clear();
      isdefoultlocation.value = false;
    } catch (error) {
      print("Failed to add location: $error");
      Get.snackbar(
          "Error", "Failed to add location: $error. Please try again.");
    }
  }

  Future<void> deleteLocation(String docId) async {
    try {
      await FirebaseFirestore.instance
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
          .collection('location')
          .where('userid', isEqualTo: userid)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'is_default': false});
      }

      // Set the selected location to 'is_default' = true
      await FirebaseFirestore.instance
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
