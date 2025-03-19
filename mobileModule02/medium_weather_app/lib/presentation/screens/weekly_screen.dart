import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fetch_daily_weather.dart';
import 'package:medium_weather_app/core/utils/weather_code_mapper.dart';
import 'package:medium_weather_app/presentation/widgets/daily_weather_info_row.dart';

class WeeklyScreen extends StatefulWidget {
  final City? city;
  const WeeklyScreen({super.key, required this.city});

  @override
  WeeklyScreenState createState() => WeeklyScreenState();
}

class WeeklyScreenState extends State<WeeklyScreen> {
  City? _city;
  DailyWeatherResponse? _dailyWeatherData;
  final String _title = 'Weekly';

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant WeeklyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.city != widget.city) {
      setState(() {
        _city = widget.city;
      });
    }

    if (_city != null) {
      _fetchDailyWeatherData();
    }
  }

  void _fetchDailyWeatherData() async {
    if (_city != null) {
      final dailyWeatherData = await fetchDailyWeatherData(
        _city!.latitude,
        _city!.longitude,
      );
      setState(() {
        _dailyWeatherData = dailyWeatherData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _city == null || _dailyWeatherData == null
        ? Center(
          child: Text(
            _title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_city!.name, style: TextStyle(fontSize: 30)),
            Text(
              _city!.admin1 ?? "Region Unknown",
              style: TextStyle(fontSize: 24),
            ),
            Text(_city!.country, style: TextStyle(fontSize: 24)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    _dailyWeatherData!.daily.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: DailyWeatherInfoRow(
                        date: _dailyWeatherData!.daily.time[index],
                        minTemperature:
                            _dailyWeatherData!.daily.temperatureMin[index]
                                .toString(),
                        minTempUnit:
                            _dailyWeatherData!.dailyUnits.temperatureMin,
                        maxTemperature:
                            _dailyWeatherData!.daily.temperatureMax[index]
                                .toString(),
                        maxTempUnit:
                            _dailyWeatherData!.dailyUnits.temperatureMax,
                        weatherDescription:
                            WeatherCodeMapper.getWeatherCodeDescription(
                              _dailyWeatherData!.daily.weatherCode[index],
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
  }
}
