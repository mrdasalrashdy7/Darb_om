import 'package:darb/controller/driver_controller.dart';
import 'package:darb/customfunction/select_date.dart';
import 'package:darb/customfunction/validat.dart';
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.defaultDialog(
      //       title: "Add Trip",
      //       content: Container(
      //         child: Obx(
      //           () => Form(
      //             key: addtripstate,
      //             child: Column(
      //               mainAxisSize:
      //                   MainAxisSize.min, // Adjusts dialog size to content
      //               children: [
      //                 CustomTextFormField(
      //                   Mycontroller: dController.tripName,
      //                   hinttext: "Trip Name",
      //                   validator: (val) => validinput(val, 3, 200),
      //                 ),
      //                 MaterialButton(
      //                   onPressed: () {
      //                     dController.tripDate.value =
      //                         selectDate(context) as DateTime;
      //                   },
      //                   child: Text(
      //                       "date: ${DateFormat('dd-MM-yyyy').format(dController.tripDate.value)}, /n click to change"),
      //                 ),
      //                 const SizedBox(height: 20),
      //                 MaterialButton(
      //                   onPressed: () {
      //                     if (addtripstate.currentState!.validate()) {
      //                       dController.add_trip(
      //                         dController.tripName.text,
      //                         dController.tripDate,
      //                       );
      //                       Get.back(); // Close the dialog after adding the trip
      //                     }
      //                   },
      //                   color: Theme.of(context).primaryColor,
      //                   textColor: Colors.white,
      //                   child: const Text("Add Trip"),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
      // body: Column(
      //   children: [
      //     const SizedBox(height: 20),
      //     const Text(
      //       "My Trips",
      //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //     ),
      //     const SizedBox(height: 10),
      //     Obx(
      //       () => Expanded(
      //         child: ListView.builder(
      //           itemCount: dController.trips.length, // Assuming trips is a list
      //           itemBuilder: (context, index) {
      //             final trip = dController.trips[index];
      //             return ListTile(
      //               title: Text(trip.name), // Replace with trip name property
      //               subtitle:
      //                   Text(trip.date), // Replace with trip date property
      //               trailing: IconButton(
      //                 icon: const Icon(Icons.delete),
      //                 onPressed: () {
      //                   dController
      //                       .delete_trip(trip.id); // Assuming delete method
      //                 },
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
