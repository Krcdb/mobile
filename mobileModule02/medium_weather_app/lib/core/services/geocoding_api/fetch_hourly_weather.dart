import 'package:http/http.dart' as http;
import 'dart:convert';

class HourlyWeatherResponse {
  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;
  
  final HourlyWeather hourly;
  final HourlyWeatherUnits hourlyUnits;

  HourlyWeatherResponse({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
    required this.hourly,
    required this.hourlyUnits,
  });

  factory HourlyWeatherResponse.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherResponse(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezone: json['timezone'],
      elevation: json['elevation'],
      hourly: HourlyWeather.fromJson(json['hourly']),
      hourlyUnits: HourlyWeatherUnits.fromJson(json['hourly_units']), // Parse hourly_units
    );
  }
}

class HourlyWeatherUnits {
  final String time;
  final String temperature;
  final String windSpeed;

  HourlyWeatherUnits({
    required this.time,
    required this.temperature,
    required this.windSpeed,
  });

  factory HourlyWeatherUnits.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherUnits(
      time: json['time'],
      temperature: json['temperature_2m'],
      windSpeed: json['wind_speed_10m'],
    );
  }
}

class HourlyWeather {
  final List<String> time;
  final List<double> temperature;
  final List<double> windSpeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.windSpeed,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: List<String>.from(json['time']),
      temperature:
          (json['temperature_2m'] as List)
              .map((e) => e != null ? (e as num).toDouble() : 0.0)
              .toList(),
      windSpeed:
          (json['wind_speed_10m'] as List)
              .map((e) => e != null ? (e as num).toDouble() : 0.0)
              .toList(),
    );
  }

  int get length => time.length;
}

Future<HourlyWeatherResponse?> fetchHourlyWeatherData(
  double latitude,
  double longitude,
) async {
  final url =
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,wind_speed_10m&timezone=auto&forecast_days=1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return HourlyWeatherResponse.fromJson(data);
  }
  return null;
}
