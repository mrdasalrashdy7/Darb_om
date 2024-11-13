import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/controller/Customer_Controller.dart';
import 'package:darb/customfunction/logout.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/main.dart';
import 'package:darb/view/auth/login.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCustomer extends StatelessWidget {
  HomeCustomer({super.key});
  CustomerController Ccontroller = Get.put(CustomerController());
  GlobalKey<FormState> addform = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.defaultDialog(
              title: "Add Location",
              content: Form(
                key: addform,
                child: Column(
                  children: [
                    CustomTextFormField(
                        hinttext: "Titel",
                        Mycontroller: Ccontroller.LocationTitel,
                        validator: (val) => validinput(val, 4, 200)),
                    CustomTextFormField(
                        hinttext: "wilayah",
                        Mycontroller: Ccontroller.wilaya,
                        validator: (val) => validinput(val, 4, 200)),
                    CustomTextFormField(
                        hinttext: "city",
                        Mycontroller: Ccontroller.city,
                        validator: (val) => validinput(val, 4, 200)),
                    CustomTextFormField(
                        hinttext: "building",
                        Mycontroller: Ccontroller.building,
                        validator: (val) => validinput(val, 4, 200)),
                    CustomTextFormField(
                        hinttext: "custom instructions",
                        Mycontroller: Ccontroller.custom_instructions),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("make this my default location"),
                            Checkbox(
                                value: Ccontroller.isdefoultlocation.value,
                                onChanged: (val) {
                                  Ccontroller.isdefoultlocation.value =
                                      val ?? false;
                                }),
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (addform.currentState!.validate()) {
                          // Prepare location data
                          Map<String, dynamic> locationData = {
                            'title': Ccontroller.LocationTitel.text,
                            'wilaya': Ccontroller.wilaya.text,
                            'city': Ccontroller.city.text,
                            'building': Ccontroller.building.text,
                            'custom_instructions':
                                Ccontroller.custom_instructions.text,
                            'is_default': Ccontroller.isdefoultlocation.value,
                          };

                          String userId = prefs!.getString("userid").toString();
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(userId) // Specific user document
                              .collection(
                                  "location") // Subcollection for locations
                              .add(locationData)
                              .then((value) => print("Location added"))
                              .catchError((error) =>
                                  print("Failed to add location: $error"));
                        }
                      },
                      child: Text(
                        "Add Location",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      color: Colors.orange,
                    )
                  ],
                ),
              ));
        },
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
                Get.to(() => Login());
              },
              icon: Icon(Icons.login)),
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
