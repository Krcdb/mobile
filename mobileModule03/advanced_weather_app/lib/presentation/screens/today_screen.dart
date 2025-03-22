import 'package:flutter/material.dart';
import 'package:advanced_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:advanced_weather_app/core/services/geocoding_api/fetch_hourly_weather.dart';
import 'package:advanced_weather_app/presentation/widgets/today_weather_info_row.dart';

class TodayScreen extends StatefulWidget {
  final City? city;
  final bool isCityFound;
  final bool isConnectionOk;

  const TodayScreen({
    super.key,
    required this.city,
    required this.isCityFound,
    required this.isConnectionOk,
  });

  @override
  TodayScreenState createState() => TodayScreenState();
}

class TodayScreenState extends State<TodayScreen> {
  City? _city;
  HourlyWeatherResponse? _hourlyWeatherData;
  bool _isCityFound = true;
  bool _isConnectionOk = true;

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant TodayScreen oldWidget) {
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
    return _city == null || _hourlyWeatherData == null
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
                    _hourlyWeatherData!.hourly.length,
                    (index) => TodayWeatherInfoRow(
                      date: _hourlyWeatherData!.hourly.time[index].substring(
                        11,
                        16,
                      ),
                      temperature:
                          _hourlyWeatherData!.hourly.temperature[index]
                              .toString(),
                      tempUnit: _hourlyWeatherData!.hourlyUnits.temperature,
                      windSpeed:
                          _hourlyWeatherData!.hourly.windSpeed[index]
                              .toString(),
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
