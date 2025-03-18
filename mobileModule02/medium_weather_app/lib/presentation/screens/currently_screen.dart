import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fectch_current_weather.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:medium_weather_app/core/utils/weather_code_mapper.dart';

class CurrentlyScreen extends StatefulWidget {
  final City? city;

  const CurrentlyScreen({super.key, required this.city});

  @override
  CurrentlyScreenState createState() => CurrentlyScreenState();
}

class CurrentlyScreenState extends State<CurrentlyScreen> {
  City? _city;
  CurrentWeatherResponse? _currentWeatherData;
  final String _title = 'Currently';

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant CurrentlyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.city != widget.city) {
      setState(() {
        _city = widget.city;
      });

      if (_city != null) {
        _fetchCurrentWeatherData(); // Call an async function separately
      }
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
    return _city == null || _currentWeatherData == null
        ? Center(
          child: Text(
            _title,
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
            Icon(WeatherCodeMapper.getWeatherCodeIcon(_currentWeatherData!.current.weatherCode), size: 50),
            Text(
              WeatherCodeMapper.getWeatherCodeDescription(_currentWeatherData!.current.weatherCode),
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
