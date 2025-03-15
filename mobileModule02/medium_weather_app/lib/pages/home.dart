import 'package:flutter/material.dart';
import 'package:medium_weather_app/pages/default_page.dart';
import 'package:medium_weather_app/utils/geolocation.dart';
import 'package:logger/logger.dart';

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

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchText = "";
  
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

  void _updateText(String text) {
    setState(() {
      _searchText = text.isEmpty ? "" : "$text";
    });
  }

  void _useGeolocation() {
    setState(() {
      logger.i("Using geolocation");
      getCurrentLocation().then((position) {
        logger.i("Got position: $position");
        if (position != null) {
          getAddressFromCoordinates(position).then((address) {
              logger.i("Got address: $address");
              setState(() {
                _searchText = address;
              });
          });
        }
      });
    });
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
          onChanged: _updateText,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DefaultPage(title: "Currently", searchParameter: _searchText),
          DefaultPage(title: "Today", searchParameter: _searchText),
          DefaultPage(title: "Weekly", searchParameter: _searchText),
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
