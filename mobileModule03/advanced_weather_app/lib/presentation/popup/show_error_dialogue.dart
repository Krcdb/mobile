import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, {String? title, String? message}) {
  if (!context.mounted) return;

   if (ModalRoute.of(context)?.isCurrent != true) {
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title ?? "Error"),
        content: Text(message ?? "An error occurred. Please try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}