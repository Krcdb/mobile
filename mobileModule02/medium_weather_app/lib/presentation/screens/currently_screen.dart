import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fectch_current_weather.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';

class CurrentlyScreen extends StatefulWidget {
  final City? city;

  const CurrentlyScreen({super.key, required this.city});

  @override
  CurrentlyScreenState createState() => CurrentlyScreenState();
}

class CurrentlyScreenState extends State<CurrentlyScreen> {
  City? _city;
  CurrentWeatherResponse? _currentWeatherResponse;
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
        _fetchWeatherData(); // Call an async function separately
      }
    }
  }

  void _fetchWeatherData() async {
    if (_city != null) {
      final currentWeatherData = await fetchCurrentWeatherData(
        _city!.latitude,
        _city!.longitude,
      );
      setState(() {
        _currentWeatherResponse = currentWeatherData;
      });
    }
  }

  /* 
Weather variable documentation
WMO Weather interpretation codes (WW)
Code	Description
0	Clear sky
1, 2, 3	Mainly clear, partly cloudy, and overcast
45, 48	Fog and depositing rime fog
51, 53, 55	Drizzle: Light, moderate, and dense intensity
56, 57	Freezing Drizzle: Light and dense intensity
61, 63, 65	Rain: Slight, moderate and heavy intensity
66, 67	Freezing Rain: Light and heavy intensity
71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
77	Snow grains
80, 81, 82	Rain showers: Slight, moderate, and violent
85, 86	Snow showers slight and heavy
95 *	Thunderstorm: Slight or moderate
96, 99 *	Thunderstorm with slight and heavy hail
 */
  @override
  Widget build(BuildContext context) {
    return _city == null || _currentWeatherResponse == null
        ? Center(
          child: Text(
            _title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
          children: [
            Text(_city!.name, style: TextStyle(fontSize: 24)),
            Text(
              _city!.admin1 ?? "Region Unknown",
              style: TextStyle(fontSize: 24),
            ),
            Text(_city!.country, style: TextStyle(fontSize: 24)),
            Text(
              "Temperature: ${_currentWeatherResponse!.current.temperature}${_currentWeatherResponse!.units.temperature}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Wind: ${_currentWeatherResponse!.current.windSpeed}${_currentWeatherResponse!.units.windSpeed}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        );
  }
}
