import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TodayWeatherInfoRow extends StatelessWidget {
  final String date;
  final String temperature;
  final String tempUnit;
  final String windSpeed;
  final String windUnit;

  const TodayWeatherInfoRow({
    super.key,
    required this.date,
    required this.temperature,
    required this.tempUnit,
    required this.windSpeed,
    required this.windUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
          ),
        ),
        Expanded(
          child: Text(
            '$temperature$tempUnit',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.white),
          ),
        ),
        Expanded(
          child: Text(
            '$windSpeed$windUnit',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
