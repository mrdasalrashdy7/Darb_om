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
  //fields for search by phone
  TextEditingController searchPhone = TextEditingController();
  var customerinfo =
      {}.obs; //{"name": "n***e", "phone": "phone", "city":"city"}
  var tripid = "".obs;

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
  -latlong
  -custom_instructions
  -is_default

trips
  -titel
  -date
  -driverid
  -points
    -status
    -lcationid
    -name (optional)
    -order(optemized order)
  
*/
  Rx<DateTime> tripDate = DateTime.now().obs;
  var points = <Point>[].obs;
  var tripId = "".obs; // To store the trip ID after saving the trip
  var isLoading = false.obs;

  // Save trip and get trip ID
  Future<void> saveTrip() async {
    // Generate a unique trip ID
    final tripIdValue =
        "${prefs!.getString("phone")}_${DateTime.now().millisecondsSinceEpoch}";
    tripid.value = tripIdValue;

    if (tripId.value.isNotEmpty) {
      // If a trip is already saved, do not proceed
      Get.snackbar("Info", "Trip already saved!");
      tripid.value = tripIdValue;
      return;
    }

    try {
      isLoading.value = true;

      // Save trip details in the trips collection
      await FirebaseFirestore.instance
          .collection("trips")
          .doc(tripIdValue)
          .set({
        "name": tripName.text,
        "date": Timestamp.fromDate(tripDate.value),
        "createdAt": FieldValue.serverTimestamp(),
        "driverid": prefs!.getString("userid"),
        "tripid": tripIdValue,
      });

      // Set the trip ID locally
      tripId.value = tripIdValue;

      isLoading.value = false;

      Get.snackbar("Success", "Trip saved successfully!");
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to save trip: $e");
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

      Map<String, dynamic> locationData = {
        "name": point.name,
        "phone": point.details,
        "latlong":
            GeoPoint(marker[0].position.latitude, marker[0].position.longitude),
      };

      await FirebaseFirestore.instance
          .collection("trips")
          .doc(tripId.value)
          .collection("points")
          .add(locationData);

      points.add(point); // Update local list
      OTname.clear();
      OTPhone.clear();
      OTlocation.clear();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Failed to add point: $e");
      print(" the erroer from marker $marker");

      isLoading.value = false;
    }
  }

  addPointFromSearch(
      String name, String details, String latitude, String longitude) async {
    if (tripId.value.isEmpty) {
      Get.snackbar("Error", "Please save the trip before adding points.");
      return;
    }

    try {
      isLoading.value = true;
      double latitude1 = double.parse(latitude);
      double longitude1 = double.parse(longitude);

      var point = Point(
        name: name,
        details: details,
        location: LatLng(latitude1, longitude1),
      );
      print("the latlong is $point");

      Map<String, dynamic> locationData = {
        "name": point.name,
        "phone": point.details,
        "latlong": GeoPoint(latitude1, longitude1),
      };

      await FirebaseFirestore.instance
          .collection("trips")
          .doc(tripid.value)
          .collection("points")
          .add(locationData);

      points.add(point); // Update local list
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Failed to add point: $e");
      print(" the erroer from marker $marker");
      print("The customer info is: ${customerinfo}");
      print("tripid.value: ${tripid.value}");

      isLoading.value = false;
    }
  }

  Future<void> fetchTripByDate(DateTime date) async {
    try {
      isLoading.value = true;

      // Query Firestore for a trip with the given date
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("trips")
          .where("tripid", isEqualTo: tripid.value)
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
          .collection("trips")
          .doc(tripid.value)
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

  Future<void> searchCustomerByPhone() async {
    try {
      // Clear previous results
      customerinfo.clear();

      // Query the location collection by phone number
      var locationQuery = await FirebaseFirestore.instance
          .collection("location")
          .where("phone", isEqualTo: searchPhone.text)
          .get();

      if (locationQuery.docs.isNotEmpty) {
        var locationData = locationQuery.docs.first.data();
        String userId = locationData['userid'];

        // Query the customer collection by userid
        var customerQuery = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .get();

        if (customerQuery.exists) {
          var customerData = customerQuery.data();

          // Extract GeoPoint fields explicitly
          GeoPoint latlong = locationData['latlong'];

          // Combine the data from both collections
          customerinfo.value = {
            'userid': userId,
            'phone': locationData['phone'],
            'latlong': latlong, // Keep GeoPoint for further processing
            'latitude': latlong.latitude.toString(), // Add latitude explicitly
            'longitude':
                latlong.longitude.toString(), // Add longitude explicitly
            'name': customerData?['name'] ?? "Unknown",
            'city': locationData['city'],
          };

          print("Customer Information: ${customerinfo}");
        } else {
          Get.snackbar("Error", "Customer not found.");
        }
      } else {
        Get.snackbar("Error", "Location not found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data: $e");
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
