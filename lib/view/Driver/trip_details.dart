import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/controller/driver_controller.dart';
import 'package:darb/customfunction/select_date.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/functions/anonymizeName.dart';
import 'package:darb/view/Driver/chooseCustomerLocation.dart';
import 'package:darb/view/Driver/routeMap.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    isenable: false,
                    Mycontroller: dController.tripName,
                    hinttext: "Trip Name",
                    validator: (val) => validinput(val, 3, 200),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: CustomTextFormField(
                    isenable: false,
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
                : Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('trips')
                          .doc(dController
                              .tripId.value) // Use the selected trip ID
                          .collection('points')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text('No points added yet.'),
                          );
                        }

                        final points = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: points.length,
                          itemBuilder: (context, index) {
                            print("the points are $points");
                            final pointData =
                                points[index].data() as Map<String, dynamic>;
                            final pointName =
                                pointData['name'] ?? 'Unnamed Point';
                            final pointDetails =
                                pointData['phone'] ?? 'No details available';

                            return ListTile(
                              title: Text(pointName),
                              subtitle: Text(pointDetails),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // Delete the point from Firestore
                                  await FirebaseFirestore.instance
                                      .collection('trips')
                                      .doc(dController.tripId.value)
                                      .collection('points')
                                      .doc(points[index].id)
                                      .delete();
                                  Get.snackbar(
                                      "Success", "Point deleted successfully");
                                },
                              ),
                            );
                          },
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
              child: Row(
                children: [
                  Text("search customer",
                      style: TextStyle(color: Colors.orange)),
                  const Icon(Icons.search, color: Colors.orange),
                ],
              ),
              onTap: () async {
                if (tripstate.currentState!.validate()) {
                  Get.defaultDialog(
                    title: "Search Location by Phone",
                    content: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormField(
                              hinttext: "Phone number",
                              Mycontroller: dController.searchPhone,
                              validator: validatePhone,
                            ),
                            SizedBox(height: 10),
                            MaterialButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                dController.searchCustomerByPhone();
                              },
                              child: Text(dController.customerinfo.isEmpty
                                  ? "Find Customer"
                                  : "Search Again"),
                            ),
                            if (dController.customerinfo.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MaterialButton(
                                    onPressed: () async {
                                      await dController.addPointFromSearch(
                                        dController.customerinfo['name'],
                                        dController.customerinfo['phone'],
                                        dController.customerinfo['latitude']
                                            .toString(),
                                        dController.customerinfo['longitude']
                                            .toString(),
                                      );
                                    },
                                    child: Text("Save Location"),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Customer Info",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Name: ${anonymizeName(dController.customerinfo['name'])}"),
                                  Text(
                                      "City: ${dController.customerinfo['city']}"),
                                ],
                              ),
                          ],
                        )),
                  );
                } else {
                  Get.snackbar("Error", "Please fill out trip details first.");
                }
              }),
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
