import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:advanced_weather_app/services/geocoding_api/fecth_city_suggestions.dart';

class WeatherSearchBar extends StatefulWidget {
  final Function(City) onCitySelected;
  final VoidCallback onUseGeolocation;
  final Function(bool) setIsConnectionOk;
  final Function(bool) setIsCityFound;

  const WeatherSearchBar({
    super.key,
    required this.onCitySelected,
    required this.onUseGeolocation,
    required this.setIsConnectionOk,
    required this.setIsCityFound,
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

    final geocodingResponse = await fetchCitySuggestions(query, context);

    if (geocodingResponse != null) {
      setState(() {
        _suggestions = geocodingResponse.results;
        widget.setIsConnectionOk(true);
        widget.setIsCityFound(_suggestions.isNotEmpty);
        _isLoading = false;
      });

      _showOverlay();
    } else {
      widget.setIsConnectionOk(false);
      setState(() {
        _isLoading = false;
      });
      _removeOverlay();
    }
  }

  void _onCityTapped(City city) {
    widget.onCitySelected(city);
    _searchController.clear();
    _removeOverlay();
  }

  void _showOverlay() {
    _removeOverlay();

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: MediaQuery.of(context).size.width * 0.9,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 40),
              child: Material(
                elevation: 4,
                color: AppColors.dark,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      _suggestions.map((city) {
                        return ListTile(
                          title: Text(
                            "${city.name}, ${city.admin1}, ${city.country}",
                            style: TextStyle(color: AppColors.white),
                          ),
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

  void _onSearchSubmit(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    setState(() => _isLoading = true);

    final geocodingResponse = await fetchCitySuggestions(query, context);

    if (geocodingResponse != null && geocodingResponse.results.isNotEmpty) {
      widget.onCitySelected(geocodingResponse.results.first);
      _searchController.clear();
      _removeOverlay();
    } else if (geocodingResponse != null && geocodingResponse.results.isEmpty) {
      widget.setIsCityFound(false);
      _removeOverlay();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        cursorColor: AppColors.white,
        style: TextStyle(color: AppColors.white),
        controller: _searchController,
        onSubmitted: _onSearchSubmit,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search city...',
          hintStyle: TextStyle(color: AppColors.white),
          border: InputBorder.none,
          suffixIcon:
              _isLoading
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : IconButton(
                    color: AppColors.white,
                    icon: Icon(Icons.my_location),
                    onPressed: widget.onUseGeolocation,
                  ),
        ),
      ),
    );
  }
}
