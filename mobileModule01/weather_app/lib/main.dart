import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //int _selectedIndex = 0;
  String _searchText = "";
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _onTabSelected(int index) {
    setState(() {
      //_selectedIndex = index;
      _tabController.index = index;
    });
  }

  void _updateText(String text) {
    setState(() {
      _searchText = text.isEmpty ? "" : " - $text";
    });
  }

  void _useGeolocation() {
    setState(() {
      _searchText = " - Geolocation";
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
          Center(child: Text("Currently$_searchText", style: const TextStyle(fontSize: 24))),
          Center(child: Text("Today$_searchText", style: const TextStyle(fontSize: 24))),
          Center(child: Text("Weekly$_searchText", style: const TextStyle(fontSize: 24))),
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
