import 'package:darb/main.dart';
import 'package:get/get.dart';

class DriverController extends GetxController {
  String? name = prefs!.getString("name");
}
