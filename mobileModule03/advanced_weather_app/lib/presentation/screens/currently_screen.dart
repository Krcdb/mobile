import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fectch_current_weather.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:medium_weather_app/core/utils/weather_code_mapper.dart';

class CurrentlyScreen extends StatefulWidget {
  final City? city;
  final bool isCityFound;
  final bool isConnectionOk;

  const CurrentlyScreen({
    super.key,
    required this.city,
    required this.isCityFound,
    required this.isConnectionOk,
  });

  @override
  CurrentlyScreenState createState() => CurrentlyScreenState();
}

class CurrentlyScreenState extends State<CurrentlyScreen> {
  City? _city;
  CurrentWeatherResponse? _currentWeatherData;
  bool _isCityFound = true;
  bool _isConnectionOk = true;

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant CurrentlyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _isConnectionOk = widget.isConnectionOk;
      _isCityFound = widget.isCityFound;
    });

    if (oldWidget.city != widget.city) {
      setState(() {
        _city = widget.city;
      });
    }

    if (_city != null) {
      _fetchCurrentWeatherData();
    }
  }

  void _fetchCurrentWeatherData() async {
    if (_city != null) {
      final currentWeatherData = await fetchCurrentWeatherData(
        _city!.latitude,
        _city!.longitude,
      );
      setState(() {
        _currentWeatherData = currentWeatherData;
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
    return _city == null || _currentWeatherData == null
        ? Center(
          child: Text(
            "",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.start, // Vertically center
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
          children: [
            Text(_city!.name, style: TextStyle(fontSize: 30)),
            Text(
              _city!.admin1 ?? "Region Unknown",
              style: TextStyle(fontSize: 24),
            ),
            Text(_city!.country, style: TextStyle(fontSize: 24)),
            Icon(
              WeatherCodeMapper.getWeatherCodeIcon(
                _currentWeatherData!.current.weatherCode,
              ),
              size: 50,
            ),
            Text(
              WeatherCodeMapper.getWeatherCodeDescription(
                _currentWeatherData!.current.weatherCode,
              ),
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "Temperature: ${_currentWeatherData!.current.temperature}${_currentWeatherData!.units.temperature}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Wind: ${_currentWeatherData!.current.windSpeed}${_currentWeatherData!.units.windSpeed}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        );
  }
}
