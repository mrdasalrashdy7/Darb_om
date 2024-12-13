import 'package:darb/controller/driver_controller.dart';
import 'package:darb/services/locationservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
Steps Description
Order Points with Nearest Neighbor:

Determines an initial stop order by visiting the nearest unvisited marker.
Fetch Directions Using Google Maps API:

Retrieves route details (distances, durations, and polylines) for the nearest neighbor order in batches.
Optimize with OPT2:

Refines the stop order by swapping segments to find a shorter route.
Refetch Directions with Google Maps API:

Updates route details and polylines based on the optimized stop order.
*/
//todo: make the start point as my location or defirent location more efficint,
//todo: prepare to conver locations from tripDetails page to mapsPage
//todo: add GO botton and its functionaloty

class MyMapController extends GetxController {
  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var optimizedOrder = <int>[].obs;
  var distances = <double>[].obs;
  var durations = <double>[].obs;
  var bottomSheetHeight = 500.0.obs;
  LatLng? startPoint;
  LatLng? endPoint;

  var startPointType = 'Me'.obs;
  var endPointType = 'Custom Point'.obs;

  LocationService locationService = LocationService();
  var initialPosition = LatLng(23.614328, 58.545284).obs;
  GoogleMapController? mapController;

  @override
  void onInit() {
    getLocation();

    super.onInit();
  }

  addTripPoints(List<Point> trippoints) {
//todo: add markers for trip points
    for (int i = 0; i < trippoints.length; i++) {
      markers.add(Marker(
        markerId: MarkerId([i].toString()),
        position: trippoints[i].location,
        infoWindow: InfoWindow(
          onTap: () {
            Get.defaultDialog(
              title: "Customer Info",
              content: Column(
                children: [
                  Image.asset("assets/logo.jpg"),
                  Text(trippoints[i].name),
                  InkWell(
                    child: Text(trippoints[i].details),
                    onTap: () => Get.snackbar(
                        "Calling >>>", "Navigating to call this user"),
                  ),
                  Text(trippoints[i].details),
                ],
              ),
            );
          },
          title: 'Custom Point ${markers.length + 1}',
          snippet: 'Tap for more info',
        ),
      ));
    }
  }

  Future<void> getLocation() async {
    try {
      Position? pos = await locationService.getCurrentLocation();
      if (pos != null) {
        initialPosition.value = LatLng(pos.latitude, pos.longitude);

        // Update the circle position
        userLocationCircle.value = Circle(
          circleId: CircleId("user_location"),
          center: LatLng(pos.latitude, pos.longitude),
          radius: 100, // Adjust the radius as needed
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );

        mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: initialPosition.value, zoom: 14.0),
        ));
      }
    } catch (e) {
      print("Error getting location: $e");
      Get.snackbar(
          'Error', 'Could not get location. Please check permissions.');
    }
  }

  var userLocationCircle = Circle(
    circleId: CircleId("user_location"),
    center: LatLng(0.0, 0.0),
    radius: 100, // 100 meters, adjust as needed
    fillColor: Colors.blue.withOpacity(0.2),
    strokeColor: Colors.blue,
    strokeWidth: 2,
  ).obs;

  void addCustomPoint(LatLng point) {
    markers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      infoWindow: InfoWindow(
        onTap: () {
          Get.defaultDialog(
            title: "Customer Info",
            content: Column(
              children: [
                Image.asset("assets/logo.jpg"),
                Text("Name: Customer Name"),
                InkWell(
                  child: Text("Phone: 99999999"),
                  onTap: () => Get.snackbar(
                      "Calling >>>", "Navigating to call this user"),
                ),
                Text("I'm on floor 2, door no.3. Please knock the door."),
              ],
            ),
          );
        },
        title: 'Custom Point ${markers.length + 1}',
        snippet: 'Tap for more info',
      ),
    ));
  }

  List<List<LatLng>> batchWaypoints(List<LatLng> waypoints) {
    const int maxWaypoints = 23;
    List<List<LatLng>> batches = [];
    for (int i = 0; i < waypoints.length; i += maxWaypoints) {
      int end = (i + maxWaypoints < waypoints.length)
          ? i + maxWaypoints
          : waypoints.length;
      batches.add(waypoints.sublist(i, end));
    }
    return batches;
  }

  void optimizeStopOrderUsingNearestNeighbor() {
    if (markers.length < 2) {
      Get.snackbar('Insufficient Stops', 'Please add more stops.');
      return;
    }

    int n = markers.length;
    List<bool> visited = List.filled(n, false);
    optimizedOrder.clear();
    optimizedOrder.add(0); // Start from the first marker
    visited[0] = true;

    int current = 0;
    for (int i = 1; i < n; i++) {
      double minDistance = double.infinity;
      int next = -1;

      for (int j = 0; j < n; j++) {
        if (!visited[j]) {
          LatLng origin = markers[current].position;
          LatLng destination = markers[j].position;
          double distance = Geolocator.distanceBetween(
            origin.latitude,
            origin.longitude,
            destination.latitude,
            destination.longitude,
          );

          if (distance < minDistance) {
            minDistance = distance;
            next = j;
          }
        }
      }

      if (next != -1) {
        optimizedOrder.add(next);
        visited[next] = true;
        current = next;
      }
    }
  }

  void optimizeWithOPT2() {
    int n = optimizedOrder.length;
    if (n < 3) return; // OPT2 requires at least 3 stops to perform swaps

    bool improvement = true;
    while (improvement) {
      improvement = false;
      for (int i = 1; i < n - 1; i++) {
        for (int k = i + 1; k < n; k++) {
          double currentDistance = calculateRouteDistance(optimizedOrder);
          swap(optimizedOrder, i, k);
          double newDistance = calculateRouteDistance(optimizedOrder);

          if (newDistance < currentDistance) {
            improvement = true; // Keep the new order
          } else {
            // Revert the swap if no improvement
            swap(optimizedOrder, i, k);
          }
        }
      }
    }
  }

  void swap(List<int> order, int i, int k) {
    // Reverse the order of elements between indices i and k
    while (i < k) {
      int temp = order[i];
      order[i] = order[k];
      order[k] = temp;
      i++;
      k--;
    }
  }

  double calculateRouteDistance(List<int> order) {
    // Calculate total distance of the route based on the current order
    double totalDistance = 0.0;
    for (int i = 0; i < order.length - 1; i++) {
      LatLng origin = markers[order[i]].position;
      LatLng destination = markers[order[i + 1]].position;
      totalDistance += Geolocator.distanceBetween(
        origin.latitude,
        origin.longitude,
        destination.latitude,
        destination.longitude,
      );
    }
    return totalDistance;
  }

  Future<void> fetchFinalRoute() async {
    String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null) throw Exception('API key not found');

    List<LatLng> waypoints =
        optimizedOrder.map((index) => markers[index].position).toList();
    List<List<LatLng>> waypointBatches = batchWaypoints(waypoints);
    polylines.clear();

    for (int i = 0; i < waypointBatches.length; i++) {
      final batch = waypointBatches[i];
      LatLng origin = batch.first;
      LatLng destination = batch.last;
      List<LatLng> intermediateWaypoints = batch.sublist(1, batch.length - 1);

      String waypointsString = intermediateWaypoints
          .map((point) => '${point.latitude},${point.longitude}')
          .join('|');
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=$waypointsString&key=$apiKey&optimizeWaypoints=false&departure_time=now';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final points =
            decodePolyline(data['routes'][0]['overview_polyline']['points']);

        polylines.add(Polyline(
          polylineId: PolylineId("route_batch_$i"),
          points: points,
          color: Colors.blue,
          width: 4,
        ));

        final distance = data['routes'][0]['legs']
                .fold(0, (sum, leg) => sum + leg['distance']['value']) /
            1000;
        final duration = data['routes'][0]['legs']
                .fold(0, (sum, leg) => sum + leg['duration']['value']) /
            60;
        distances.add(distance);
        durations.add(duration);
      } else {
        throw Exception('Failed to fetch route');
      }
    }
  }

  void clearMap() {
    markers.clear();
    polylines.clear();
    optimizedOrder.clear();
    distances.clear();
    durations.clear();
  }

  void setStartPoint(String type) {
    startPointType.value = type;
    if (type == 'Me') {
      getLocation();
      startPoint = initialPosition.value;
    } else if (markers.isNotEmpty) {
      startPoint = markers.first.position;
    }
  }

  void setEndPoint(String type) {
    endPointType.value = type;
    if (type == 'Me') {
      getLocation();
      endPoint = initialPosition.value;
    } else if (type == 'Return to Start' && startPoint != null) {
      endPoint = startPoint;
    } else if (markers.isNotEmpty) {
      endPoint = markers.last.position;
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  void showMainBottomSheet(BuildContext context) {
    Get.bottomSheet(
      isScrollControlled: true,
      Obx(() => Container(
            padding: const EdgeInsets.all(16.0),
            height: bottomSheetHeight.value,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (bottomSheetHeight.value < 600.0) {
                          bottomSheetHeight.value += 100.0;
                        }
                      },
                      icon: const Icon(Icons.arrow_upward),
                    ),
                    IconButton(
                      onPressed: () {
                        if (bottomSheetHeight.value > 200.0) {
                          bottomSheetHeight.value -= 100.0;
                        }
                      },
                      icon: const Icon(Icons.arrow_downward),
                    ),
                    IconButton(
                      onPressed: () => addCustomPoint(initialPosition.value),
                      icon: const Icon(Icons.add),
                    ),
                    IconButton(
                      onPressed: clearMap,
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select Start and End Points',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      _buildDropdownTile(
                        title: 'Start Point',
                        currentSelection: startPointType.value,
                        onSelected: (type) {
                          setStartPoint(type);
                        },
                        items: [
                          const DropdownMenuItem(
                              value: 'Me', child: Text('Me Location')),
                          const DropdownMenuItem(
                              value: 'Custom Point',
                              child: Text('Custom Point')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownTile(
                        title: 'End Point',
                        currentSelection: endPointType.value,
                        onSelected: (type) {
                          setEndPoint(type);
                        },
                        items: [
                          const DropdownMenuItem(
                              value: 'Me', child: Text('Me Location')),
                          const DropdownMenuItem(
                              value: 'Custom Point',
                              child: Text('Custom Point')),
                          const DropdownMenuItem(
                              value: 'Return to Start',
                              child: Text('Return to Start')),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (markers.length > 1) {
                            Get.dialog(
                                Center(child: CircularProgressIndicator()),
                                barrierDismissible: false);

                            // Step 1: Order stops using Nearest Neighbor
                            optimizeStopOrderUsingNearestNeighbor();

                            // Step 2: Refine order using OPT2
                            optimizeWithOPT2();

                            // Step 3: Fetch final route from Google Maps API
                            await fetchFinalRoute();

                            Get.back(); // Dismiss loading dialog
                          } else {
                            Get.snackbar('Insufficient Markers',
                                'Please add at least two markers on the map.');
                          }
                        },
                        child: const Text('Optimize Route'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: optimizedOrder.length,
                    itemBuilder: (context, index) {
                      final stopIndex = optimizedOrder[index];
                      final marker = markers[stopIndex];
                      final distance =
                          index < distances.length ? distances[index] : 0.0;
                      final duration =
                          index < durations.length ? durations[index] : 0.0;

                      return ListTile(
                        title: Text(
                            'Stop No. ${index + 1} - ${marker.infoWindow.title ?? ''}'),
                        subtitle: Text(
                          'Distance: ${distance.toStringAsFixed(2)} km, '
                          'Duration: ${duration.toStringAsFixed(2)} minutes (in traffic)',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String currentSelection,
    required Function(String) onSelected,
    required List<DropdownMenuItem<String>> items,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: currentSelection,
        items: items,
        onChanged: (value) {
          if (value != null) {
            onSelected(value);
          }
        },
      ),
    );
  }
}
