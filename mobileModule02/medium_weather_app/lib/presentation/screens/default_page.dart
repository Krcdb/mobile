import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  final String _title;
  final String _searchParameter;

  const DefaultPage({
    super.key,
    required String title,
    required String searchParameter,
  }) : _title = title,
       _searchParameter = searchParameter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _searchParameter.isEmpty ? _title : "$_title - $_searchParameter",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
