import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:advanced_weather_app/core/utils/weather_code_mapper.dart';
import 'package:flutter/material.dart';

class DailyWeatherInfo extends StatelessWidget {
  final String date;
  final String minTemperature;
  final String maxTemperature;
  final String minTempUnit;
  final String maxTempUnit;
  final int weatherCode;

  const DailyWeatherInfo({
    super.key,
    required this.date,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minTempUnit,
    required this.maxTempUnit,
    required this.weatherCode,
  });

 @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        Icon(
          WeatherCodeMapper.getWeatherCodeIcon(weatherCode),
          size: 50,
          color: Colors.blue,
        ),
        Text(
          '$maxTemperature$maxTempUnit max',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.lightRed),
        ),
        Text(
          '$minTemperature$minTempUnit min',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.lightBlue),
        ),
      ], 
    );
  }
}
