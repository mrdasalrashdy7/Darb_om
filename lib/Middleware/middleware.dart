import 'package:darb/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final role = prefs?.getString("role");

    if (role == null) {
      return const RouteSettings(name: Routes.login);
    }

    switch (role.toLowerCase()) {
      case "customer":
        return const RouteSettings(name: Routes.customer);
      case "driver":
        return const RouteSettings(name: Routes.driver);
      case "company":
        return const RouteSettings(name: Routes.company);
      case "admin":
        return const RouteSettings(name: Routes.admin);
      default:
        return const RouteSettings(
            name: Routes.login); // Redirect to login for undefined roles
    }
  }
}

class Routes {
  static const String login = "login";
  static const String customer = "Hcustomer";
  static const String driver = "Hdriver";
  static const String company = "Hcompany";
  static const String admin = "adminpage";
}
