import 'package:darb/controller/Customer_Controller.dart';
import 'package:darb/controller/driver_controller.dart';
import 'package:darb/controller/map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooslocationDriver extends StatelessWidget {
  ChooslocationDriver({super.key});
  DriverController dcontroller = Get.put(DriverController());
  cooslocationcontroller czcontroller = Get.put(cooslocationcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Row(
            children: [
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  dcontroller.marker.clear();
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 3,
                height: 50,
                color: Colors.black,
              ),
              InkWell(
                child: Text("Save location"),
                onTap: () {
                  if (dcontroller.marker.isNotEmpty) {
                    Get.back();
                    Get.snackbar("Saved", "your location saved seccsessfuly");
                  } else {
                    Get.snackbar("Notis", "you need to add point");
                  }
                },
              )
            ],
          )),
      body: Container(
        child: Obx(
          () => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: dcontroller.marker.isEmpty
                  ? dcontroller.initialPosition.value
                  : dcontroller.marker[0].position,
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(dcontroller.marker),
            onTap: (point) {
              dcontroller.addCustomPoint(point);
            },
          ),
        ),
      ),
    );
  }
}
