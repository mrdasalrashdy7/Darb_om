import 'package:darb/controller/driver_controller.dart';
import 'package:darb/customfunction/select_date.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/main.dart';
import 'package:darb/view/Driver/chooseCustomerLocation.dart';
import 'package:darb/view/Driver/routeMap.dart';
import 'package:darb/view/customer/chooslocation.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripDetails extends StatelessWidget {
  TripDetails({super.key});

  final DriverController dController = Get.put(DriverController());
  final GlobalKey<FormState> tripstate = GlobalKey();
  final GlobalKey<FormState> addtripstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Trips"),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: customFloatingButton(context),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Form(
            key: tripstate,
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: CustomTextFormField(
                    Mycontroller: dController.tripName,
                    hinttext: "Trip Name",
                    validator: (val) => validinput(val, 3, 200),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: CustomTextFormField(
                    Mycontroller: dController.tripDatecontroller,
                    keyboardType: TextInputType.datetime,
                    OnTap: () async {
                      dController.tripDatecontroller.text =
                          await selectDate(context);
                    },
                    hinttext: "Date:",
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Customers",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Obx(
            () => dController.isLoading.value
                ? CircularProgressIndicator()
                : dController.points.isEmpty
                    ? Center(child: Text("No points added yet."))
                    : Flexible(
                        child: ListView.builder(
                          itemCount: dController.points.length,
                          itemBuilder: (context, index) {
                            final point = dController.points[index];
                            return ListTile(
                              title: Text(point.name),
                              subtitle: Text(point.details),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Delete logic here
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton customFloatingButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.black,
      onPressed: () {},
      label: Row(
        children: [
          InkWell(
            onTap: () => Get.to(RouteMap(TripPoints: dController.points)),
            child: Row(children: [
              Icon(Icons.route_outlined, color: Colors.orange),
              Text(
                "Go to Map",
                style: TextStyle(color: Colors.orange),
              )
            ]),
          ),
          Container(
            height: 30,
            width: 2,
            color: Colors.orange,
            margin: EdgeInsets.symmetric(horizontal: 4),
          ),
          InkWell(
            onTap: () async {
              // Validate trip before adding points
              if (tripstate.currentState!.validate()) {
                await dController.saveTrip(); // Save trip if form is valid
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Add Point"),
                      content: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: Form(
                            key: addtripstate,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextFormField(
                                  hinttext: "Customer Name",
                                  Mycontroller: dController.OTname,
                                  validator: (val) => validinput(val, 1, 255),
                                ),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  hinttext: "Phone Number",
                                  Mycontroller: dController.OTPhone,
                                  keyboardType: TextInputType.phone,
                                  validator: (val) => validinput(val, 1, 700),
                                ),
                                const SizedBox(height: 10),
                                MaterialButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    // Open map picker logic
                                    Get.to(() => ChooslocationDriver());
                                  },
                                  child: const Text("choose location from map"),
                                ),
                                const SizedBox(height: 20),
                                MaterialButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    await dController.addPoint(
                                      dController.OTname.text,
                                      dController.OTPhone.text,
                                      dController.OTlocation.text,
                                    );
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: const Text("Add Point"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                Get.snackbar("Error", "Please fill out trip details first.");
              }
            },
            child: Row(
              children: [
                Text("Add Location", style: TextStyle(color: Colors.orange)),
                const Icon(Icons.add_location_outlined, color: Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
