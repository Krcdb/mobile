import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<bool> handleLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

Future<Position?> getCurrentLocation() async {
  bool hasPermission = await handleLocationPermission();
  if (!hasPermission) return null;

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}


Future<String> getAddressFromCoordinates(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude,
    );
    Placemark place = placemarks.first;
    return "${place.locality}, ${place.country}";
  } catch (e) {
    return "Unknown location";
  }
}

