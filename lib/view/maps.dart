import 'package:darb/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatelessWidget {
  final MyMapController mapController = Get.put(MyMapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search location...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10.0),
          ),
          onSubmitted: (value) {
            // You can add functionality here to handle search actions
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              mapController.clearMap();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (mapController.initialPosition.value.latitude == 0.0 &&
            mapController.initialPosition.value.longitude == 0.0) {
          return Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: mapController.initialPosition.value,
            zoom: 11.0,
          ),
          markers: Set<Marker>.of(mapController.markers),
          polylines: Set<Polyline>.of(mapController.polylines),
          circles: Set<Circle>.of(
              [mapController.userLocationCircle.value]), // Add the circle here
          onMapCreated: (GoogleMapController controller) {
            mapController.mapController = controller;
          },
          onTap: (point) {
            mapController.addCustomPoint(point);
          },
          // Set gesture handling for Flutter Web
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          mapController.showMainBottomSheet(context);
        },
        label: Row(
          children: const [
            Icon(Icons.route),
            SizedBox(width: 5),
            Text("show options"),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
