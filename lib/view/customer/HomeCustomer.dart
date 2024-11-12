import 'dart:ffi';

import 'package:darb/controller/Customer_Controller.dart';
import 'package:darb/customfunction/logout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCustomer extends StatelessWidget {
  HomeCustomer({super.key});
  CustomerController Ccontroller = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {},
        child: Icon(
          Icons.add_location_alt_outlined,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("ٍCustomer"),
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
            height: 30,
          ),
          Container(
            child: Text("Hellow mr, ${Ccontroller.name}"),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.orange,
                  child: Text(
                    "Locations",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.orangeAccent,
                  child: Text(
                    "Ordars",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
// ListView.builder(itemBuilder: itemBuilder)
          Column(
            children: [
              Card(
                child: ListTile(
                  title: Text("My defoult location"),
                  subtitle: Text("Oman, Muscat, Alkhoud-6"),
                  leading:
                      IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
