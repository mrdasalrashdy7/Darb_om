import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darb/controller/driver_controller.dart';
import 'package:darb/customfunction/dateformat.dart';
import 'package:darb/customfunction/select_date.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/main.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Trips extends StatelessWidget {
  Trips({super.key});

  final DriverController dController = Get.put(DriverController());
  final GlobalKey<FormState> addtripstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Trips"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.defaultDialog(
              title: "Add Trip",
              content: Container(
                child: Obx(
                  () => Form(
                    key: addtripstate,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextFormField(
                          Mycontroller: dController.tripName,
                          hinttext: "Trip Name",
                          validator: (val) => validinput(val, 3, 200),
                        ),
                        MaterialButton(
                          onPressed: () {
                            dController.tripDate.value =
                                selectDate(context) as DateTime;
                          },
                          child: Text(
                              "date: ${DateFormat('dd-MM-yyyy').format(dController.tripDate.value)}, \n click to change"),
                        ),
                        const SizedBox(height: 20),
                        MaterialButton(
                          onPressed: () {
                            if (addtripstate.currentState!.validate()) {
                              dController.saveTrip();
                              Get.back();
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: const Text("Add Trip"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('trips')
              .where('driverid',
                  isEqualTo:
                      prefs!.getString("userid")) // Filter trips by driverId
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No trips found for this driver'),
              );
            }

            final trips = snapshot.data!.docs;

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final tripId = trip.id;
                final title = trip['name'];
                final date = trip['date'];

                return FutureBuilder<int>(
                  future: dController.getPointsCount(tripId),
                  builder: (context, pointsSnapshot) {
                    if (pointsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        title: Text(title),
                        subtitle: Text('Loading points...'),
                      );
                    }

                    final pointsCount = pointsSnapshot.data ?? 0;

                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(title),
                        subtitle: Text(
                            'Date: ${formatDate((date as Timestamp).toDate())}\nPoints: $pointsCount'),
                        onTap: () {
                          Get.toNamed("tripdetails");
                          dController.tripName.text = title;
                          dController.tripDate.value =
                              (date as Timestamp).toDate();
                          dController.tripId.value = tripId;
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
