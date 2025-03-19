import 'package:flutter/material.dart';

class DailyWeatherInfoRow extends StatelessWidget {
  final String date;
  final String minTemperature;
  final String minTempUnit;
  final String maxTemperature;
  final String maxTempUnit;
  final String weatherDescription;

  const DailyWeatherInfoRow({
    super.key,
    required this.date,
    required this.minTemperature,
    required this.minTempUnit,
    required this.maxTemperature,
    required this.maxTempUnit,
    required this.weatherDescription,
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            '$minTemperature$minTempUnit | $maxTemperature$maxTempUnit',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: Text(
            weatherDescription,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
