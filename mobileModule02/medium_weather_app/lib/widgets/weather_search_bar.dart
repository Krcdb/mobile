import 'package:flutter/material.dart';

import 'package:medium_weather_app/data/repository/geocoding_api.dart';

class WeatherSearch extends StatefulWidget {
  const WeatherSearch({super.key});

  @override
  WeatherSearchState createState() => WeatherSearchState();
}

class WeatherSearchState extends State<WeatherSearch> {
  final TextEditingController _controller = TextEditingController();
  GeocodingResponse _suggestions = GeocodingResponse(results: []);

  Future<void> updateCitySuggestions(String query) async {
    setState(() async {
      _suggestions = await fetchCitySuggestions(query) ?? GeocodingResponse(results: []);
    });
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
            itemCount: _suggestions.results.length,
            itemBuilder: (context, index) {
              final city = _suggestions.results[index];
              return ListTile(
                title: Text('${city.name}, ${city.country}'),
                subtitle: Text(city.admin1 ?? ''),
                onTap: () {
                  _controller.text = city.name;
                  fetchWeather(city.latitude, city.longitude);
                  setState(() {
                    _suggestions = GeocodingResponse(results: []);
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
