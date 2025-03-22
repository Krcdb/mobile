import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:advanced_weather_app/presentation/screens/home_screen.dart';

class CurrentWeatherResponse {
  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;
  final CurrentWeather current;
  final WeatherUnits units;
  String? responseCode;

  CurrentWeatherResponse({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
    required this.current,
    required this.units,
  });

  factory CurrentWeatherResponse.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherResponse(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezone: json['timezone'],
      elevation: json['elevation'],
      current: CurrentWeather.fromJson(json['current']),
      units: WeatherUnits.fromJson(json['current_units']),
    );
  }
}

class CurrentWeather {
  final String time;
  final double temperature;
  final int weatherCode;
  final double precipitation;
  final double windSpeed;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.precipitation,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'],
      temperature: json['temperature_2m'].toDouble(),
      weatherCode: json['weather_code'],
      precipitation: json['precipitation'].toDouble(),
      windSpeed: json['wind_speed_10m'].toDouble(),
    );
  }
}

class WeatherUnits {
  final String temperature;
  final String weatherCode;
  final String precipitation;
  final String windSpeed;

  WeatherUnits({
    required this.temperature,
    required this.weatherCode,
    required this.precipitation,
    required this.windSpeed,
  });

  factory WeatherUnits.fromJson(Map<String, dynamic> json) {
    return WeatherUnits(
      temperature: json['temperature_2m'],
      weatherCode: json['weather_code'],
      precipitation: json['precipitation'],
      windSpeed: json['wind_speed_10m'],
    );
  }
}

Future<CurrentWeatherResponse?> fetchCurrentWeatherData(
  double latitude,
  double longitude,
) async {
  
  final url =
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code,precipitation,wind_speed_10m&timezone=auto';

  final response = await http.get(Uri.parse(url));

  try {
      final data = json.decode(response.body);
      if (data == null) {
        logger.d('No data found');
        return null;
      }
      logger.d('Current weather data: $data');
      var currentWeatherResponse = CurrentWeatherResponse.fromJson(data);
      currentWeatherResponse.responseCode = response.statusCode.toString();
      logger.d('Current weather response code: ${currentWeatherResponse.responseCode}');
      return currentWeatherResponse;
  } catch (e) {
    logger.e('Error fetching current weather data: $e');
  }
  return null;
}
