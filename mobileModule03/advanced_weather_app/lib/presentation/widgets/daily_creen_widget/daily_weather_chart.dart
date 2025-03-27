import 'package:advanced_weather_app/core/theme/app_colors.dart';
import 'package:advanced_weather_app/core/utils/date.dart';
import 'package:advanced_weather_app/services/geocoding_api/fetch_daily_weather.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyWeatherChart extends StatelessWidget {
  final DailyWeatherResponse dailyWeatherData;

  const DailyWeatherChart({super.key, required this.dailyWeatherData});

  @override
  Widget build(BuildContext context) {
    double minTemp = dailyWeatherData.daily.temperatureMin
        .map((e) => e)
        .reduce((a, b) => a < b ? a : b);
    double maxTemp = dailyWeatherData.daily.temperatureMax
        .map((e) => e)
        .reduce((a, b) => a > b ? a : b);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.dark.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Weekly Temperatures",
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
                  minY: minTemp - 2,
                  maxY: maxTemp + 2,
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
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
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
                        interval: 1,
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 &&
                              index < dailyWeatherData.daily.time.length) {
                            return Text(
                              formatDate(dailyWeatherData.daily.time[index]),
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
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
                      spots: List.generate(
                        dailyWeatherData.daily.time.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          dailyWeatherData.daily.temperatureMax[index]
                              .toDouble(),
                        ),
                      ),
                      isCurved: true,
                      color: AppColors.lightRed,
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
                    LineChartBarData(
                      spots: List.generate(
                        dailyWeatherData.daily.time.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          dailyWeatherData.daily.temperatureMin[index]
                              .toDouble(),
                        ),
                      ),
                      isCurved: true,
                      color: AppColors.blue,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(width: 10, height: 10, color: AppColors.blue),
                    const SizedBox(width: 4),
                    Text(
                      "Min",
                      style: TextStyle(color: AppColors.white, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 10, height: 10, color: AppColors.lightRed),
                    const SizedBox(width: 4),
                    Text(
                      "Max",
                      style: TextStyle(color: AppColors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
