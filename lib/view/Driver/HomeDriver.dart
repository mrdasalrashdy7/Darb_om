import 'package:darb/controller/driver_controller.dart';
import 'package:darb/customfunction/logout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDriver extends StatelessWidget {
  HomeDriver({super.key});
  DriverController Dcontroller = Get.put(DriverController());
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
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Hellow Mr, ${Dcontroller.name}",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                color: Colors.orange,
                width: 150,
                height: 150,
                child: Text(
                  "Coming trip",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                color: Colors.orange,
                width: 150,
                height: 150,
                child: Text(
                  "list of customer",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                color: Colors.orange,
                width: 150,
                height: 150,
                child: Text(
                  "my accouunt",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                color: Colors.orange,
                width: 150,
                height: 150,
                child: Text(
                  "Go to Map",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
