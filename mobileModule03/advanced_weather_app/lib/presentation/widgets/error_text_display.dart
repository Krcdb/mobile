import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ErrorTextDisplay extends StatelessWidget {
  final bool isCityFound;
  final bool isConnectionOk;

  const ErrorTextDisplay({
    super.key,
    required this.isCityFound,
    required this.isConnectionOk,
  });

  @override
  Widget build(BuildContext context) {
    if (!isConnectionOk) {
      return Center(
        child: Text(
          "The service connection is lost, please check your internet connection or try again later.",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.orange),
          textAlign: TextAlign.center,
        ),
      );
    } else if (!isCityFound) {
      return Center(
        child: Text(
          "Could not find any result for the supplied address or coordinates.",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.orange),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
