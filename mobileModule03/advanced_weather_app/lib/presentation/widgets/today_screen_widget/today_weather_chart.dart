import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:advanced_weather_app/services/geocoding_api/fetch_hourly_weather.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TodayWeatherChart extends StatelessWidget {
  final HourlyWeatherResponse hourlyWeatherData;

  const TodayWeatherChart({super.key, required this.hourlyWeatherData});

  @override
  Widget build(BuildContext context) {
    double minTemp = hourlyWeatherData.hourly.temperature
        .map((e) => e)
        .reduce((a, b) => a < b ? a : b);
    double maxTemp = hourlyWeatherData.hourly.temperature
        .map((e) => e)
        .reduce((a, b) => a > b ? a : b);

    return Center(
      // Centers the entire widget
      child: Container(
        padding: const EdgeInsets.all(16), // Padding inside the background
        decoration: BoxDecoration(
          color: AppColors.dark.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title of the Chart
            Text(
              "Today's Temperatures", // Change this title as needed
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine:
                        (value) => FlLine(
                          color: Colors.white.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                    getDrawingVerticalLine:
                        (value) => FlLine(
                          color: Colors.white.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                  ),
                  minY: minTemp - 2,
                  maxY: maxTemp + 2,
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget:
                            (value, meta) => Text(
                              '${value.toInt()}°C',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                            ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 &&
                              index < hourlyWeatherData.hourly.length) {
                            return Text(
                              hourlyWeatherData.hourly.time[index].substring(
                                11,
                                16,
                              ),
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots:
                          hourlyWeatherData.hourly.temperature
                              .asMap()
                              .entries
                              .map(
                                (entry) => FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.toDouble(),
                                ),
                              )
                              .toList(),
                      isCurved: true,
                      color: AppColors.orange,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter:
                            (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.orange,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
