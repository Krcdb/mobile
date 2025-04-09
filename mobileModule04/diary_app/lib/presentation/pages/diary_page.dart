import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Diary"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Center(
        child: Text("Welcome to your diary!"),
      ),
    );
  }
}
