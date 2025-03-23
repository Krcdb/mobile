import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:advanced_weather_app/core/utils/weather_code_mapper.dart';
import 'package:flutter/material.dart';

class TodayWeatherInfo extends StatelessWidget {
  final String date;
  final String temperature;
  final String tempUnit;
  final String windSpeed;
  final String windUnit;
  final int weatherCode;

  const TodayWeatherInfo({
    super.key,
    required this.date,
    required this.temperature,
    required this.tempUnit,
    required this.windSpeed,
    required this.windUnit,
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
          '$temperature$tempUnit',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: AppColors.orange),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wind_power_sharp, color: AppColors.blue, size: 20),
            Text(
              "$windSpeed$windUnit",
              style: TextStyle(fontSize: 14, color: AppColors.white),
            ),
          ],
        ),
      ], 
    );
  }
}
