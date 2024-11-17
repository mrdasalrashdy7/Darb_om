import 'package:darb/controller/driver_controller.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:darb/view/customwedgits/globalformfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Trips extends StatelessWidget {
  Trips({super.key});

  DriverController dController = Get.put(DriverController());
  GlobalKey<FormState> addtripstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my Trips"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
              title: "Add Trip",
              content: Form(
                key: addtripstate,
                child: Column(
                  children: [
                    CustomTextFormField(
                      Mycontroller: dController.tripName,
                      hinttext: "Trip Name",
                    ),
                    Globaltextformfield(
                      keyboardtype: TextInputType.datetime,
                      hinttext: "تاريخ الإنجاز",
                      Mycontroller: dController.tripDate,
                      titel: 'تاريخ الإنجاز',
                      OnTap: () {
                        _selectDate(context);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى اختيار تاريخ الإنجاز';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      Mycontroller: dController.tripDate,
                      hinttext: "Trip date",
                    ),
                    MaterialButton(
                        child: Text("Add Trip"),
                        onPressed: () {
                          if (addtripstate.currentState!.validate()) {
                            dController.add_trip(dController.tripName.text,
                                dController.tripDate.text);
                          }
                        })
                  ],
                ),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text("MY trips"),
          ),
          // ListView.builder(
          //   itemCount: 5,
          //   itemBuilder: (context, index) {},
          // ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dController.tripDate.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }
}
