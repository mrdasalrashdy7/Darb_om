import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/customfunction/logout.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/customfunction/wilaya.dart';
import 'package:darb/main.dart';

import 'package:darb/view/auth/login.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:latlong2/latlong.dart';
import 'package:darb/controller/Customer_Controller.dart';

class HomeCustomer extends StatelessWidget {
  HomeCustomer({super.key});
  final CustomerController Ccontroller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: customFbuton(context),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Customer"),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Container(child: Text("Hello Mr, ${Ccontroller.name}")),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.orange,
                  child: const Text(
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
                  child: const Text(
                    "Orders",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (Ccontroller.userLocations.isEmpty) {
                return const Center(
                  child: Text(
                      "You have not added any location. Add one to start."),
                );
              }

              return ListView.builder(
                itemCount: Ccontroller.userLocations.length,
                itemBuilder: (context, index) {
                  var location = Ccontroller.userLocations[index];
                  GeoPoint geoPoint = location['latlong'];
                  LatLng position =
                      LatLng(geoPoint.latitude, geoPoint.longitude);
                  String docId = location.id;

                  return Slidable(
                    key: Key(docId),
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            if (location['is_default']) {
                              Get.snackbar(
                                "Cannot delete default location",
                                "Please choose another default location before deleting this one.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.withOpacity(0.8),
                                colorText: Colors.white,
                              );
                            } else {
                              bool? confirm = await Get.defaultDialog<bool>(
                                title: "Delete!",
                                middleText:
                                    "Do you want to delete this location?",
                                textConfirm: "Yes",
                                textCancel: "No",
                                confirmTextColor: Colors.white,
                                onConfirm: () => Get.back(result: true),
                                onCancel: () => Get.back(result: false),
                              );

                              if (confirm == true) {
                                await Ccontroller.deleteLocation(docId);
                                Get.snackbar(
                                  "Success",
                                  "Location deleted successfully.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            if (location['is_default']) {
                              Get.snackbar(
                                "Already Default",
                                "This location is already set as the default.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                colorText: Colors.white,
                              );
                            } else {
                              await Ccontroller.setDefaultLocation(docId);
                              Get.snackbar(
                                "Success",
                                "Location set as default.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.withOpacity(0.8),
                                colorText: Colors.white,
                              );
                            }
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          label: 'Make Default',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(location['title']),
                        subtitle: Text(
                          "Wilaya ${location['wilaya']} | City ${location['city']} | Building ${location['building']}",
                        ),
                        leading: location['is_default']
                            ? Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.location_on, color: Colors.grey),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  FloatingActionButton customFbuton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.orange,
      onPressed: () {
        if (prefs!.getString("phone") != null) {
          Ccontroller.phoneNo.text = prefs!.getString("phone").toString();
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("أضف موقع"),
              content: SingleChildScrollView(
                child: Form(
                  key: Ccontroller.addform,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        hinttext: "تسمية الموقع",
                        Mycontroller: Ccontroller.LocationTitel,
                        validator: (val) => validinput(val, 4, 200),
                      ),
                      Select_wilaya(),
                      CustomTextFormField(
                        hinttext: "القرية",
                        Mycontroller: Ccontroller.city,
                      ),
                      CustomTextFormField(
                        hinttext: "المبنى / الطابق",
                        Mycontroller: Ccontroller.building,
                      ),
                      CustomTextFormField(
                        hinttext: "هاتف التواصل",
                        Mycontroller: Ccontroller.phoneNo,
                        validator: (val) => validatePhone(val),
                      ),
                      CustomTextFormField(
                        minLine: 2,
                        maxLine: 3,
                        hinttext: "تعليمات الموقع",
                        Mycontroller: Ccontroller.custom_instructions,
                      ),
                      const SizedBox(height: 10),
                      Obx(() => MaterialButton(
                            color: Ccontroller.marker.isEmpty
                                ? Colors.grey
                                : Colors.orange,
                            onPressed: () {
                              Get.toNamed("clocation");
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.map),
                                SizedBox(width: 8),
                                Text(Ccontroller.marker.isEmpty
                                    ? "اختر موقع"
                                    : "حدث الموقع"),
                              ],
                            ),
                          )),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("موقعي الافتراضي"),
                            Checkbox(
                              value: Ccontroller.isdefoultlocation.value,
                              onChanged: (val) {
                                Ccontroller.isdefoultlocation.value =
                                    val ?? false;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        color: Colors.orange,
                        onPressed: () {
                          if (Ccontroller.addform.currentState!.validate()) {
                            try {
                              Ccontroller.addLocation(Ccontroller.addform);
                              Get.back();
                            } catch (e) {
                              Get.defaultDialog(title: "Error in save: $e ");
                              print("Error in save locationm $e");
                            }
                          } else {
                            print("Erorrrrrrrrrrrrrrrr");
                          }
                        },
                        child: const Text(
                          "أضف الموقع",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

        ;
      },
      child: const Icon(
        Icons.add_location_alt_outlined,
        color: Colors.white,
      ),
    );
  }

  DropdownSearch<String> Select_wilaya() {
    return DropdownSearch<String>(
      selectedItem: Ccontroller.selectedWilaya.value,
      items: (filter, infiniteScrollProps) => Wilayat,
      onChanged: (value) {
        Ccontroller.selectedWilaya.value = value.toString();
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: "الولاية",
          border: OutlineInputBorder(),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "اختر ولاية";
        }
        return null;
      },
    );
  }
}
