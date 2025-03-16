import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api.dart';

class WeeklyScreen extends StatefulWidget {
  final City? city;
  const WeeklyScreen({super.key, required this.city});

  @override
  WeeklyScreenState createState() => WeeklyScreenState();
}

class WeeklyScreenState extends State<WeeklyScreen> {
  City? _city;
  final String _title = 'Weekly';

  @override
  void initState() {
    super.initState();
    _city = widget.city;
  }

  @override
  void didUpdateWidget(covariant WeeklyScreen oldWidget) {
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
