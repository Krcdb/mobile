// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:advanced_weather_app/presentation/screens/home_screen.dart';

class GeocodingResponse {
  final List<City> results;
  String? responseCode;

  GeocodingResponse({required this.results});

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] == null) return GeocodingResponse(results: []);
    return GeocodingResponse(
      results: (json['results'] as List).map((e) => City.fromJson(e)).toList(),
    );
  }
}

class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double? elevation;
  final String featureCode;
  final String countryCode;
  final String country;
  final String? admin1;
  final String? admin2;
  final String? admin3;
  final String? admin4;
  final String timezone;
  final int? population;
  final List<String>? postcodes;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.elevation,
    required this.featureCode,
    required this.countryCode,
    required this.country,
    this.admin1,
    this.admin2,
    this.admin3,
    this.admin4,
    required this.timezone,
    this.population,
    this.postcodes,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      elevation: json['elevation']?.toDouble(),
      featureCode: json['feature_code'],
      countryCode: json['country_code'],
      country: json['country'],
      admin1: json['admin1'],
      admin2: json['admin2'],
      admin3: json['admin3'],
      admin4: json['admin4'],
      timezone: json['timezone'],
      population: json['population'],
      postcodes:
          (json['postcodes'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}

Future<GeocodingResponse?> fetchCitySuggestions(
  String query,
  BuildContext context,
) async {
  if (query.isEmpty) return null;

  final url =
      'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json';

  try {
    final response = await http.get(Uri.parse(url));
    logger.d("Response code: ${response.statusCode}");
    final data = json.decode(response.body);
    var geocodingResponse = GeocodingResponse.fromJson(data);
    geocodingResponse.responseCode = response.statusCode.toString();
    return geocodingResponse;
  } catch (e) {
    logger.e("Connection issue: $e");
  }

  return null;
}
