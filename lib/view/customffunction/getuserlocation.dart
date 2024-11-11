import 'package:darb/services/locationservice.dart';

import 'package:geolocator/geolocator.dart';

void getLocation() async {
  LocationService locationService = LocationService();
  String location = "مالك";
  try {
    Position? pos = await locationService.getCurrentLocation();

    if (pos != null) {
      location = "Latitude: ${pos.latitude}, Longitude: ${pos.longitude}";
    }
  } catch (e) {
    location = e.toString();
  }
}
