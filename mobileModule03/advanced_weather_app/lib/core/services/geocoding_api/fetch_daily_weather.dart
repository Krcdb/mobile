import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:advanced_weather_app/presentation/screens/home_screen.dart';

class DailyWeatherResponse {
  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;
  final DailyWeather daily;
  final DailyUnits dailyUnits;
  String? responseCode;

  DailyWeatherResponse({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
    required this.daily,
    required this.dailyUnits,
  });

  factory DailyWeatherResponse.fromJson(Map<String, dynamic> json) {
    return DailyWeatherResponse(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezone: json['timezone'],
      elevation: json['elevation'],
      daily: DailyWeather.fromJson(json['daily']),
      dailyUnits: DailyUnits.fromJson(json['daily_units']),
    );
  }
}

class DailyWeather {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperatureMax;
  final List<double> temperatureMin;

  DailyWeather({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      time: List<String>.from(json['time']),
      weatherCode: List<int>.from(json['weather_code']),
      temperatureMax: (json['temperature_2m_max'] as List)
          .map((e) => e != null ? (e as num).toDouble() : 0.0)
          .toList(),
      temperatureMin: (json['temperature_2m_min'] as List)
          .map((e) => e != null ? (e as num).toDouble() : 0.0)
          .toList(),
    );
  }

  int get length => time.length;
}

class DailyUnits {
  final String time;
  final String weatherCode;
  final String temperatureMax;
  final String temperatureMin;

  DailyUnits({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) {
    return DailyUnits(
      time: json['time'],
      weatherCode: json['weather_code'],
      temperatureMax: json['temperature_2m_max'],
      temperatureMin: json['temperature_2m_min'],
    );
  }
}

Future<DailyWeatherResponse?> fetchDailyWeatherData(
  double latitude,
  double longitude,
) async {

  final url =
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';
  
  final response = await http.get(Uri.parse(url));

  try {
      final data = json.decode(response.body);
      if (data == null) {
        logger.d('No data found');
        return null;
      }
      logger.d('Daily weather data: $data');
      var dailyWeatherResponse = DailyWeatherResponse.fromJson(data);
      dailyWeatherResponse.responseCode = response.statusCode.toString();
      logger.d('Daily weather response code: ${dailyWeatherResponse.responseCode}');
      return dailyWeatherResponse;
  } catch (e) {
    logger.e('Error fetching daily weather data: $e');
  }
  return null;
}
