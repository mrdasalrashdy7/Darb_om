import 'package:darb/controller/driver_controller.dart';
import 'package:darb/customfunction/logout.dart';
import 'package:darb/main.dart';
import 'package:darb/view/Driver/trip_details.dart';
import 'package:darb/view/Driver/trips.dart';
import 'package:darb/view/customer/HomeCustomer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDriver extends StatelessWidget {
  HomeDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("ٍDriver"),
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              "Hellow Mr, ${prefs!.getString("username")}",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              InkWell(
                onTap: () => Get.to(() => Trips()),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  color: Colors.orange,
                  width: 150,
                  height: 150,
                  child: const Text(
                    "my trips",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => TripDetails());
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  color: Colors.orange,
                  width: 150,
                  height: 150,
                  child: const Text(
                    "next trip",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                color: Colors.orange,
                width: 150,
                height: 150,
                child: const Text(
                  "my accouunt",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => HomeCustomer()),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  color: Colors.orange,
                  width: 150,
                  height: 150,
                  child: const Text(
                    "Go to Map",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
