import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fetch_daily_weather.dart';
import 'package:medium_weather_app/core/utils/weather_code_mapper.dart';
import 'package:medium_weather_app/presentation/widgets/daily_weather_info_row.dart';

class WeeklyScreen extends StatefulWidget {
  final City? city;
  final bool isCityFound;
  final bool isConnectionOk;

  const WeeklyScreen({
    super.key,
    required this.city,
    required this.isCityFound,
    required this.isConnectionOk,
  });

  @override
  WeeklyScreenState createState() => WeeklyScreenState();
}

class WeeklyScreenState extends State<WeeklyScreen> {
  City? _city;
  DailyWeatherResponse? _dailyWeatherData;
  bool _isCityFound = true;
  bool _isConnectionOk = true;

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant WeeklyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _isCityFound = widget.isCityFound;
      _isConnectionOk = widget.isConnectionOk;
    });

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
    if (!_isConnectionOk) {
      return Center(
        child: Text(
          "The service connection is lost, please check your internet connection or try again later.",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    } else if (!_isCityFound) {
      return Center(
        child: Text(
          "Could not find any result for the supplied address or coordinates.",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }
    return _city == null || _dailyWeatherData == null
        ? Center(
          child: Text(
            "",
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
                      padding: const EdgeInsets.only(bottom: 16.0),
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
