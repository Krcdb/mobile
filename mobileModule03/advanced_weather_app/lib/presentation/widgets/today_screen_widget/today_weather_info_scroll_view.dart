import 'package:advanced_weather_app/presentation/widgets/today_screen_widget/today_weather_info.dart';
import 'package:advanced_weather_app/services/geocoding_api/fetch_hourly_weather.dart';
import 'package:flutter/material.dart';

class TodayWeatherInfoScrollView extends StatelessWidget {
  final HourlyWeatherResponse hourlyWeatherData;

  const TodayWeatherInfoScrollView({
    super.key,
    required this.hourlyWeatherData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 15,
        children: List.generate(
          hourlyWeatherData.hourly.length,
          (index) => TodayWeatherInfo(
            date: hourlyWeatherData.hourly.time[index].substring(11, 16),
            temperature:
                hourlyWeatherData.hourly.temperature[index].toString(),
            tempUnit: hourlyWeatherData.hourlyUnits.temperature,
            windSpeed: hourlyWeatherData.hourly.windSpeed[index].toString(),
            windUnit: hourlyWeatherData.hourlyUnits.windSpeed,
            weatherCode: hourlyWeatherData.hourly.weatherCode[index],
          ),
        ),
      ),
    );
  }
}
