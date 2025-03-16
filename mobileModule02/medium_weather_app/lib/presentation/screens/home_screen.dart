import 'package:flutter/material.dart';
import 'package:medium_weather_app/core/services/geocoding_api.dart';
import 'package:medium_weather_app/presentation/screens/currently_screen.dart';
import 'package:medium_weather_app/core/utils/geolocation.dart';
import 'package:logger/logger.dart';
import 'package:medium_weather_app/presentation/screens/today_screen.dart';
import 'package:medium_weather_app/presentation/screens/weekly_screen.dart';
import 'package:medium_weather_app/presentation/widgets/weather_search_bar.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Hide method calls
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  City? _cityToSearch;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _onTabSelected(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void _updateCity(City city) {
    setState(() {
      logger.i("Updating city: ${city.name}, ${city.country}");
      _cityToSearch = city;
    });
  }

  void _useGeolocation() async {
    logger.i("Using geolocation");
    final position = await getCurrentLocation(); // Get current location
    logger.i("Got position: $position");

    if (position != null) {
      final address = await getAddressFromCoordinates(position);
      logger.i("Got address: $address");

      final geocodingResponse = await fetchCitySuggestions(
        address,
      ); // Fetch city suggestions

      if (geocodingResponse != null && geocodingResponse.results.isNotEmpty) {
        final firstCity =
            geocodingResponse.results.first; // Pick the first city
        logger.i("Selected city: ${firstCity.name}, ${firstCity.country}");

        setState(() {
          _cityToSearch = firstCity;
        });
      } else {
        logger.w("No cities found for the given query.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _useGeolocation,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CurrentlyScreen(city: _cityToSearch),
          TodayScreen(city: _cityToSearch),
          WeeklyScreen(city: _cityToSearch),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          controller: _tabController,
          onTap: _onTabSelected,
          tabs: const [
            Tab(icon: Icon(Icons.cloud), text: 'Currently'),
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.calendar_view_week), text: 'Weekly'),
          ],
        ),
      ),
    );
  }
}
