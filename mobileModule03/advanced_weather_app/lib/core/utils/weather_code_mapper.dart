import 'package:flutter/material.dart';

class WeatherCodeMapper {
  static const Map<int, String> _weatherDescriptions = {
    0: "Clear sky",
    1: "Mainly clear",
    2: "Partly cloudy",
    3: "Overcast",
    45: "Fog",
    48: "Depositing rime fog",
    51: "Drizzle: Light intensity",
    53: "Drizzle: Moderate intensity",
    55: "Drizzle: Dense intensity",
    56: "Freezing Drizzle: Light intensity",
    57: "Freezing Drizzle: Dense intensity",
    61: "Rain: Slight intensity",
    63: "Rain: Moderate intensity",
    65: "Rain: Heavy intensity",
    66: "Freezing Rain: Light intensity",
    67: "Freezing Rain: Heavy intensity",
    71: "Snow fall: Slight intensity",
    73: "Snow fall: Moderate intensity",
    75: "Snow fall: Heavy intensity",
    77: "Snow grains",
    80: "Rain showers: Slight",
    81: "Rain showers: Moderate",
    82: "Rain showers: Violent",
    85: "Snow showers: Slight",
    86: "Snow showers: Heavy",
    95: "Thunderstorm: Slight or moderate",
    96: "Thunderstorm with slight hail",
    99: "Thunderstorm with heavy hail",
  };

  static const Map<int, IconData> _weatherIcons = {
    0: Icons.wb_sunny,
    1: Icons.cloud_outlined,
    2: Icons.cloud_outlined,
    3: Icons.cloud,
    45: Icons.foggy,
    48: Icons.foggy,
    51: Icons.grain,
    53: Icons.grain,
    55: Icons.grain,
    56: Icons.ac_unit,
    57: Icons.ac_unit,
    61: Icons.umbrella,
    63: Icons.umbrella,
    65: Icons.umbrella,
    66: Icons.ac_unit,
    67: Icons.ac_unit,
    71: Icons.snowing,
    73: Icons.snowing,
    75: Icons.snowing,
    77: Icons.snowing,
    80: Icons.shower,
    81: Icons.shower,
    82: Icons.shower,
    85: Icons.snowing,
    86: Icons.snowing,
    95: Icons.flash_on,
    96: Icons.flash_on,
    99: Icons.flash_on,
  };

  static String getWeatherCodeDescription(int code) {
    return _weatherDescriptions[code] ?? "Unknown weather condition";
  }

  static IconData getWeatherCodeIcon(int code) {
    return _weatherIcons[code] ?? Icons.help_outline;
  }
}
