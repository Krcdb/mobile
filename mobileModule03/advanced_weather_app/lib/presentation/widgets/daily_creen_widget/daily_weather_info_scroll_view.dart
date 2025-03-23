import 'package:advanced_weather_app/core/utils/date.dart';
import 'package:advanced_weather_app/presentation/widgets/daily_creen_widget/daily_weather_info.dart';
import 'package:advanced_weather_app/services/geocoding_api/fetch_daily_weather.dart';
import 'package:flutter/material.dart';

class DailyWeatherInfoScrollView extends StatelessWidget {
  final DailyWeatherResponse dailyWeatherData;

  const DailyWeatherInfoScrollView({super.key, required this.dailyWeatherData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 15,
        children: List.generate(
          dailyWeatherData.daily.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DailyWeatherInfo(
              date: formatDate(dailyWeatherData.daily.time[index]),
              minTemperature:
                  dailyWeatherData.daily.temperatureMin[index].toString(),
              minTempUnit: dailyWeatherData.dailyUnits.temperatureMin,
              maxTemperature:
                  dailyWeatherData.daily.temperatureMax[index].toString(),
              maxTempUnit: dailyWeatherData.dailyUnits.temperatureMax,
              weatherCode: dailyWeatherData.daily.weatherCode[index],
            ),
          ),
        ),
      ),
    );
  }
}
