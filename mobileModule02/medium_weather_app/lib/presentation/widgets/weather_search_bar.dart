import 'package:flutter/material.dart';

import 'package:medium_weather_app/core/services/geocoding_api.dart';

class WeatherSearch extends StatefulWidget {
  final Function(City) onSearch;
  final Function() onGeolocation;

  const WeatherSearch({super.key, required this.onSearch, required this.onGeolocation});

  @override
  WeatherSearchState createState() => WeatherSearchState();
}

class WeatherSearchState extends State<WeatherSearch> {
  final TextEditingController _controller = TextEditingController();
  GeocodingResponse _suggestions = GeocodingResponse(results: []);

  Future<void> updateCitySuggestions(String query) async {
    final suggestions = await fetchCitySuggestions(query);
    setState(() {
      _suggestions = suggestions ?? GeocodingResponse(results: []);
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
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                widget.onGeolocation();
              },
            ),
          ),
          onChanged: (value) {
            updateCitySuggestions(value);
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
                  widget.onSearch(city);
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
