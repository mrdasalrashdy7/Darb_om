import 'package:darb/main.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  String? name = prefs!.getString("name");
}
