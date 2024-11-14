import 'package:darb/controller/Customer_Controller.dart';
import 'package:darb/controller/map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Chooslocation extends StatelessWidget {
  Chooslocation({super.key});
  CustomerController mcontroller = Get.put(CustomerController());
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
                  mcontroller.marker.clear();
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
                  if (mcontroller.marker.isNotEmpty) {
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
              target: mcontroller.marker.isEmpty
                  ? mcontroller.initialPosition.value
                  : mcontroller.marker[0].position,
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(mcontroller.marker),
            onTap: (point) {
              mcontroller.addCustomPoint(point);
            },
          ),
        ),
      ),
    );
  }
}
