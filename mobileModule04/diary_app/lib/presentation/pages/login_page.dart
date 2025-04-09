import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Hide method calls
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    logger.d("Google Sign-In initiated");
    if (googleUser == null) {
      logger.d("Google Sign-In cancelled");
      return;
    }
    logger.d("Google Sign-In successful: ${googleUser.email}");
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      logger.d("Google Sign-In failed: No access token or ID token");
      return;
    }
    logger.d("Google Sign-In authentication successful");
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    logger.d("Google Sign-In successful: ${googleUser.email}");
    await FirebaseAuth.instance.signInWithCredential(credential);
    logger.d("Firebase Sign-In successful: ${FirebaseAuth.instance.currentUser?.email}");
    
    Navigator.pushReplacementNamed(context, '/diary');
  }

  Future<void> _signInWithGitHub(BuildContext context) async {
    final githubProvider = GithubAuthProvider();
    await FirebaseAuth.instance.signInWithProvider(githubProvider);
    Navigator.pushReplacementNamed(context, '/diary');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/diary'));
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _signInWithGoogle(context),
              child: Text("Login with Google"),
            ),
            ElevatedButton(
              onPressed: () => _signInWithGitHub(context),
              child: Text("Login with GitHub"),
            ),
          ],
        ),
      ),
    );
  }
}
