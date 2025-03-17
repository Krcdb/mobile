import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api/fecth_city_suggestions.dart';

class TodayScreen extends StatefulWidget {
  final City? city;
  const TodayScreen({super.key, required this.city});

  @override
  TodayScreenState createState() => TodayScreenState();
}

class TodayScreenState extends State<TodayScreen> {
  City? _city;
  final String _title = 'Today';

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant TodayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.city != widget.city) {
      setState(() {
        _city = widget.city;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _city == null ? _title : "$_title - ${_city?.name}",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),),
    );
  }
}
