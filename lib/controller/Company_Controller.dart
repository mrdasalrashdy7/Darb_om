import 'package:get/get.dart';

class CompanyController extends GetxController {
  var screenWidth = 0.0.obs;

  void updateScreenWidth(double width) {
    screenWidth.value = width;
  }
}
