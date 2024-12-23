import 'package:darb/view/Driver/routeMap.dart';
import 'package:darb/view/maps.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => RouteMap(
                      TripPoints: [],
                    )); // Navigate to the MapsPage
              },
              child: Text('Go to Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
