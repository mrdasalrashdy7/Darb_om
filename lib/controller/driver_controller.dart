import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/customfunction/dateformat.dart';
import 'package:darb/main.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DriverController extends GetxController {
  TextEditingController tripName = TextEditingController();
  TextEditingController tripDatecontroller = TextEditingController();
  TextEditingController OTlocation = TextEditingController();
  TextEditingController OTname = TextEditingController();
  TextEditingController OTPhone = TextEditingController();

  var marker = <Marker>[].obs;
  var initialPosition = const LatLng(23.614328, 58.545284).obs;
/*
firbase firstore structure

users
  -email
  -id
  -name
  -phone
  -role

locations
  -phone
  -userid
  -location
  -discription
  -status

trips
  -titel
  -date
  -driverid
  -points
    -name
    -status
    -lcationid
  
*/
  Rx<DateTime> tripDate = DateTime.now().obs;
  var points = <Point>[].obs;
  var tripId = "".obs; // To store the trip ID after saving the trip
  var isLoading = false.obs;

  // Save trip and get trip ID
  Future<void> saveTrip() async {
    if (tripId.value.isNotEmpty) return; // Trip already saved

    try {
      isLoading.value = true;
      var docRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(prefs!.getString("userid"))
          .collection("trips")
          .add({
        "name": tripName.text,
        "date": Timestamp.fromDate(tripDate.value),
        "createdAt": FieldValue.serverTimestamp(),
      });

      tripId.value = docRef.id; // Save the trip ID
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Failed to save trip: $e");
      isLoading.value = false;
    }
  }

  // Add point to Firestore under the saved trip
  Future<void> addPoint(String name, String details, String location) async {
    if (tripId.value.isEmpty) {
      Get.snackbar("Error", "Please save the trip before adding points.");
      return;
    }

    try {
      isLoading.value = true;

      double latitude = double.parse(location.split(',').first.trim());
      double longitude = double.parse(location.split(',').last.trim());

      var point = Point(
        name: name,
        details: details,
        location: LatLng(latitude, longitude),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(prefs!.getString("userid"))
          .collection("trips")
          .doc(tripId.value)
          .collection("points")
          .add(point.toMap());

      points.add(point); // Update local list
      OTname.clear();
      OTPhone.clear();
      OTlocation.clear();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Failed to add point: $e");
      isLoading.value = false;
    }
  }

  Future<void> fetchTripByDate(DateTime date) async {
    try {
      isLoading.value = true;

      // Query Firestore for a trip with the given date
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(prefs!.getString("userid"))
          .collection("trips")
          .where("date", isEqualTo: Timestamp.fromDate(date))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Trip found
        var doc = snapshot.docs.first;
        var data = doc.data() as Map<String, dynamic>;

        tripId.value = doc.id; // Set trip ID
        tripName.text = data["name"] ?? ""; // Load trip name
        tripDatecontroller.text = formatDate(date); // Set trip date

        // Fetch points for this trip
        await fetchPointsForTrip(doc.id);
      } else {
        // No trip found
        tripId.value = ""; // Reset trip ID
        tripName.clear();
        tripDatecontroller.text = DateFormat('dd/MM/yyyy').format(date);
        points.clear();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch trip: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch points for a specific trip
  Future<void> fetchPointsForTrip(String tripId) async {
    try {
      isLoading.value = true;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(prefs!.getString("userid"))
          .collection("trips")
          .doc(tripId)
          .collection("points")
          .get();

      points.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Point(
          name: data["name"],
          details: data["details"],
          location: LatLng(
            data["location"]["latitude"],
            data["location"]["longitude"],
          ),
        );
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch points: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    fetchTripByDate(DateTime.now());

    tripDatecontroller.text = formatDate(DateTime.now());
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

// Model class for a trip
class Trip {
  final String id;
  final String name;
  final String date;

  Trip({
    required this.id,
    required this.name,
    required this.date,
  });
}

//=========================================================
//=========================================================
class Point {
  final String name;
  final String details;
  final LatLng location;

  Point({
    required this.name,
    required this.details,
    required this.location,
  });

  // Convert Point to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "details": details,
      "location": {
        "latitude": location.latitude,
        "longitude": location.longitude,
      },
    };
  }
}

// Method to save trip and its points to Firestore
Future<void> saveTripWithPointsToFirebase(
  String userId,
  String tripName,
  String tripDate,
  List<Point> points,
) async {
  try {
    // Ensure the userId, tripName, and tripDate are valid
    if (userId.isEmpty || tripName.isEmpty || tripDate.isEmpty) {
      throw Exception("User ID, Trip Name, and Trip Date cannot be empty.");
    }

    // Reference to the trips collection in Firestore
    CollectionReference tripsCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("trips");

    // Add trip document
    DocumentReference tripDocRef = await tripsCollection.add({
      "tripName": tripName,
      "tripDate": tripDate,
      "createdAt": FieldValue.serverTimestamp(),
    });

    // Reference to the points collection under the trip
    CollectionReference pointsCollection = tripDocRef.collection("points");

    // Batch write for efficiency
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (Point point in points) {
      DocumentReference docRef = pointsCollection.doc(); // Generate unique ID
      batch.set(docRef, point.toMap()); // Add the point to the batch
    }

    // Commit the batch
    await batch.commit();

    print("Trip and points saved successfully!");
  } catch (e) {
    print("Failed to save trip and points: $e");
  }
}
