import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class CityDisplay extends StatelessWidget {
  final String cityName;
  final String stateName;
  final String countryName;

  const CityDisplay({
    super.key,
    required this.cityName,
    required this.stateName,
    required this.countryName,
  });

  @override
  Widget build(BuildContext context) { 
    return Column(
      children: [
        Text( 
          cityName,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.blue),
        ),
        Text(
          '$stateName, $countryName',
          style: TextStyle(fontSize: 24, color: AppColors.white),
        ),
      ],
    );
  }
}
