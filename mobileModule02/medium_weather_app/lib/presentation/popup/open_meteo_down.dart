import 'package:flutter/material.dart';

void showApiErrorDialog(BuildContext context) {
  if (!context.mounted) return; // Prevents using context after async calls

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Connection Error"),
        content: const Text("Unable to reach the weather service. Please check your internet connection and try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(), // Close dialog
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}