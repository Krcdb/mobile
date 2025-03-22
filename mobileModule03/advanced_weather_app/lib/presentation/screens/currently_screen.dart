import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:advanced_weather_app/presentation/screens/home_screen.dart';
import 'package:advanced_weather_app/presentation/widgets/city_display.dart';
import 'package:advanced_weather_app/presentation/widgets/error_text_display.dart';
import 'package:flutter/material.dart';
import 'package:advanced_weather_app/services/geocoding_api/fectch_current_weather.dart';
import 'package:advanced_weather_app/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:advanced_weather_app/core/utils/weather_code_mapper.dart';

class CurrentlyScreen extends StatefulWidget {
  final City? city;
  final bool isCityFound;
  final bool isConnectionOk;

  const CurrentlyScreen({
    super.key,
    required this.city,
    required this.isCityFound,
    required this.isConnectionOk,
  });

  @override
  CurrentlyScreenState createState() => CurrentlyScreenState();
}

class CurrentlyScreenState extends State<CurrentlyScreen> {
  City? _city;
  CurrentWeatherResponse? _currentWeatherData;
  bool _isCityFound = true;
  bool _isConnectionOk = true;

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant CurrentlyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _isConnectionOk = widget.isConnectionOk;
      _isCityFound = widget.isCityFound;
    });

    if (oldWidget.city != widget.city) {
      setState(() {
        _city = widget.city;
      });
    }

    if (_city != null) {
      _fetchCurrentWeatherData();
    }
  }

  void _fetchCurrentWeatherData() async {
    if (_city != null) {
      final currentWeatherData = await fetchCurrentWeatherData(
        _city!.latitude,
        _city!.longitude,
      );
      setState(() {
        _currentWeatherData = currentWeatherData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnectionOk || !_isCityFound) {
      logger.d("_isConnectionOk: $_isConnectionOk, _isCityFound: $_isCityFound");
      return ErrorTextDisplay(
        isCityFound: _isCityFound,
        isConnectionOk: _isConnectionOk,
      );
    }
    return _city == null || _currentWeatherData == null
        ? Center(
          child: Text(
            "",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
        : Padding(
          padding: EdgeInsets.only(top: 80, bottom: 350),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CityDisplay(
                cityName: _city!.name,
                stateName: _city!.admin1 ?? "Region Unknown",
                countryName: _city!.country,
              ),
              Text(
                "${_currentWeatherData!.current.temperature}${_currentWeatherData!.units.temperature}",
                style: TextStyle(fontSize: 60, color: AppColors.orange),
              ),
              Text(
                WeatherCodeMapper.getWeatherCodeDescription(
                  _currentWeatherData!.current.weatherCode,
                ),
                style: TextStyle(fontSize: 30, color: AppColors.white),
              ),
              Icon(
                color: AppColors.blue,
                WeatherCodeMapper.getWeatherCodeIcon(
                  _currentWeatherData!.current.weatherCode,
                ),
                size: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wind_power_sharp, color: AppColors.blue, size: 30),
                  Text(
                    "${_currentWeatherData!.current.windSpeed}${_currentWeatherData!.units.windSpeed}",
                    style: TextStyle(fontSize: 20, color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}
