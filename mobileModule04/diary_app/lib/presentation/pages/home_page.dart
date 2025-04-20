import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _resetSession(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Déconnexion réussie')),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Login"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _resetSession(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Reset Session"),
            ),
          ],
        ),
      ),
    );
  }
}
