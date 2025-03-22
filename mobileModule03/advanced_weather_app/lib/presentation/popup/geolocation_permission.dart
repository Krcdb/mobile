import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void showGeolocationPermissionDialog(BuildContext context, {bool permanentlyDenied = false}) {
  if (context.mounted == false) return;
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Location Permission"),
        content: Text(permanentlyDenied
            ? "Location permission is permanently denied. Please enable it from settings."
            : "Location permission is required to use this feature."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (permanentlyDenied) {
                Geolocator.openAppSettings();
              }
            },
            child: Text(permanentlyDenied ? "Open Settings" : "OK"),
          ),
        ],
      );
    },
  );
}