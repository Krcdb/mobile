import 'package:advanced_weather_app/presentation/widgets/city_display.dart';
import 'package:advanced_weather_app/presentation/widgets/daily_creen_widget/daily_weather_chart.dart';
import 'package:advanced_weather_app/presentation/widgets/daily_creen_widget/daily_weather_info_scroll_view.dart';
import 'package:advanced_weather_app/presentation/widgets/error_text_display.dart';
import 'package:flutter/material.dart';
import 'package:advanced_weather_app/services/geocoding_api/fecth_city_suggestions.dart';
import 'package:advanced_weather_app/services/geocoding_api/fetch_daily_weather.dart';

class WeeklyScreen extends StatefulWidget {
  final City? city;
  final bool isCityFound;
  final bool isConnectionOk;

  const WeeklyScreen({
    super.key,
    required this.city,
    required this.isCityFound,
    required this.isConnectionOk,
  });

  @override
  WeeklyScreenState createState() => WeeklyScreenState();
}

class WeeklyScreenState extends State<WeeklyScreen> {
  City? _city;
  DailyWeatherResponse? _dailyWeatherData;
  bool _isCityFound = true;
  bool _isConnectionOk = true;

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant WeeklyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _isCityFound = widget.isCityFound;
      _isConnectionOk = widget.isConnectionOk;
    });

    if (oldWidget.city != widget.city) {
      setState(() {
        _city = widget.city;
      });
    }

    if (_city != null) {
      _fetchDailyWeatherData();
    }
  }

  void _fetchDailyWeatherData() async {
    if (_city != null) {
      final dailyWeatherData = await fetchDailyWeatherData(
        _city!.latitude,
        _city!.longitude,
      );
      setState(() {
        _dailyWeatherData = dailyWeatherData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnectionOk || !_isCityFound) {
      return ErrorTextDisplay(
        isCityFound: _isCityFound,
        isConnectionOk: _isConnectionOk,
      );
    }
    return _city == null || _dailyWeatherData == null
        ? Center(
          child: Text(
            "",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
        : Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CityDisplay(
              cityName: _city!.name,
              stateName: _city!.admin1 ?? "Region Unknown",
              countryName: _city!.country,
            ),
            DailyWeatherChart(dailyWeatherData: _dailyWeatherData!),
            DailyWeatherInfoScrollView(dailyWeatherData: _dailyWeatherData!)
          ],
        );
  }
}
