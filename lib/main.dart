import 'package:darb/Middleware/middleware.dart';
import 'package:darb/customfunction/logout.dart';
import 'package:darb/firebase_options.dart';
import 'package:darb/view/Driver/HomeDriver.dart';
import 'package:darb/view/Driver/routeMap.dart';
import 'package:darb/view/Google_Maps_Learn.dart';
import 'package:darb/view/auth/login.dart';
import 'package:darb/view/auth/signup.dart';
import 'package:darb/view/company/HomeCompany.dart';
import 'package:darb/view/customer/HomeCustomer.dart';
import 'package:darb/view/customer/chooslocation.dart';
import 'package:darb/view/home.dart';
import 'package:darb/view/maps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO List
/*
adding sliding_up_panel package instade of buttomsheet

Y?5TqtfwqJr!DArb
darbMerdas
*/

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

Map route = {"dist": 100, "time": 2};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // initialRoute: "/middleware",
      home: HomeCustomer(),
      getPages: [
        GetPage(
            name: "/middleware",
            page: () => HomePage(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: "/home",
            page: () => HomePage(),
            middlewares: [AuthMiddleware()]),
        GetPage(name: "/login", page: () => Login()),
        GetPage(name: "/signup", page: () => Signup()),
        // GetPage(name: "/DriverMap", page: () => MapsPage()),
        GetPage(
            name: "/RouteMap",
            page: () => RouteMap(
                  TripPoints: [],
                )),
        GetPage(name: "/Hdriver", page: () => HomeDriver()),
        GetPage(name: "/Hcustomer", page: () => HomeCustomer()),
        GetPage(name: "/Hcompany", page: () => HomeCompany()),
        GetPage(name: "/clocation", page: () => Chooslocation()),
      ],
    );
  }
}
