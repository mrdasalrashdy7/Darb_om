import 'package:darb/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final role = prefs!.getString("role");

    if (role == null) {
      return const RouteSettings(name: "login");
    } else if (role == "customer") {
      return const RouteSettings(name: "customer");
    } else if (role == "driver") {
      return const RouteSettings(name: "driver");
    } else if (role == "company") {
      return const RouteSettings(name: "company");
    } else if (role == "Admin") {
      return const RouteSettings(name: "adminpage");
    }

    return null; // No redirection if none of the conditions are met
  }
}
