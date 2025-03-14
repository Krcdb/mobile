import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherSearch extends StatefulWidget {
  const WeatherSearch({super.key});

  @override
  WeatherSearchState createState() => WeatherSearchState();
}

class WeatherSearchState extends State<WeatherSearch> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _suggestions = [];

  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    final url =
        'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        setState(() {
          _suggestions = List<Map<String, dynamic>>.from(data['results']);
        });
      }
    }
  }

  void fetchWeather(double lat, double lon) {
    // Implement API call to fetch weather using lat & lon
    print("Fetching weather for lat: $lat, lon: $lon");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search city...',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            fetchCitySuggestions(value);
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final city = _suggestions[index];
              return ListTile(
                title: Text('${city["name"]}, ${city["country"]}'),
                subtitle: Text(city["admin1"] ?? ''),
                onTap: () {
                  _controller.text = city["name"];
                  fetchWeather(city["latitude"], city["longitude"]);
                  setState(() {
                    _suggestions = [];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
