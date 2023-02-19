import 'package:geolocator/geolocator.dart';

import '../exceptions/LocationException.dart';

Future<Position> getCurrentPosition() async {
  bool locationEnabled;
  LocationPermission permission;

  locationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locationEnabled) {
    throw LocationException('Location is disabled!');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      throw LocationException('Permission denied!');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw LocationException('Location permissions are denied forever. Please enable!');
  }

  return await Geolocator.getCurrentPosition();
}