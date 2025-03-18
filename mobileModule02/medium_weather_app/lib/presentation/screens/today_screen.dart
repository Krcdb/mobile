import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fetch_hourly_weather.dart';
import 'package:medium_weather_app/presentation/widgets/today_weather_info_row.dart';

class TodayScreen extends StatefulWidget {
  final City? city;

  const TodayScreen({super.key, required this.city});

  @override
  TodayScreenState createState() => TodayScreenState();
}

class TodayScreenState extends State<TodayScreen> {
  City? _city;
  HourlyWeatherResponse? _hourlyWeatherData;
  final String _title = 'Today';

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant TodayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.city != widget.city) {
      setState(() {
        _city = widget.city;
      });
    }

    if (_city != null) {
      _fetchHourlyWeatherData();
    }
  }

  void _fetchHourlyWeatherData() async {
    if (_city != null) {
      final hourlyWeatherData = await fetchHourlyWeatherData(
        _city!.latitude,
        _city!.longitude,
      );
      setState(() {
        _hourlyWeatherData = hourlyWeatherData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _city == null || _hourlyWeatherData == null
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
                    _hourlyWeatherData!.hourly.length,
                    (index) => TodayWeatherInfoRow(
                      date: _hourlyWeatherData!.hourly.time[index].substring(11, 16),
                      temperature: _hourlyWeatherData!.hourly.temperature[index].toString(),
                      tempUnit: _hourlyWeatherData!.hourlyUnits.temperature,
                      windSpeed: _hourlyWeatherData!.hourly.windSpeed[index].toString(),
                      windUnit: _hourlyWeatherData!.hourlyUnits.windSpeed,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
  }
}
