import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';

class WeatherSearchBar extends StatefulWidget {
  final Function(City) onCitySelected;
  final VoidCallback onUseGeolocation;

  const WeatherSearchBar({
    super.key,
    required this.onCitySelected,
    required this.onUseGeolocation,
  });

  @override
  WeatherSearchBarState createState() => WeatherSearchBarState();
}

class WeatherSearchBarState extends State<WeatherSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<City> _suggestions = [];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    setState(() => _isLoading = true);

    final geocodingResponse = await fetchCitySuggestions(query);

    if (geocodingResponse != null) {
      setState(() {
        _suggestions = geocodingResponse.results;
        _isLoading = false;
      });

      _showOverlay();
    }
  }

  void _onCityTapped(City city) {
    widget.onCitySelected(city);
    _searchController.clear();
    _removeOverlay();
  }

  void _showOverlay() {
    _removeOverlay(); // Remove previous overlay if any

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.9, // Adjust width
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 40), // Position it below TextField
          child: Material(
            elevation: 4,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _suggestions.map((city) {
                return ListTile(
                  title: Text("${city.name}, ${city.admin1}, ${city.country}"),
                  onTap: () => _onCityTapped(city),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search city...',
          border: InputBorder.none,
          suffixIcon: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Icon(Icons.my_location),
                  onPressed: widget.onUseGeolocation,
                ),
        ),
      ),
    );
  }
}
