import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

Future<String> selectDate(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(3000),
  );
  if (pickedDate != null && pickedDate != DateTime.now) {
    return DateFormat('dd-MM-yyyy').format(pickedDate); // Update reactive date
  } else {
    return DateFormat('dd-MM-yyyy').format(DateTime.now());
  }
}
