// ignore_for_file: use_build_context_synchronously

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:medium_weather_app/presentation/popup/geolocation_permission.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Hide method calls
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);

Future<bool> handleLocationPermission(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      logger.e("Location permission denied");
      showGeolocationPermissionDialog(context);
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    logger.e("Location permission denied forever");
    showGeolocationPermissionDialog(context, permanentlyDenied: true);
    return false;
  }

  return true;
}

Future<Position?> getCurrentLocation(BuildContext context) async {
  bool hasPermission = await handleLocationPermission(context);
  if (!hasPermission) return null;

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<String> getAddressFromCoordinates(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks.first;
    return "${place.locality}, ${place.country}";
  } catch (e) {
    return "Unknown location";
  }
}
