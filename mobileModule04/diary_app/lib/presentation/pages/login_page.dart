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
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

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
    logger.d(
      "Firebase Sign-In successful: ${FirebaseAuth.instance.currentUser?.email}",
    );

    Navigator.pushReplacementNamed(context, '/diary');
  }

  Future<void> _signInWithGitHub(context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final OAuthProvider githubProvider = OAuthProvider("github.com");

      final UserCredential userCredential = await auth.signInWithProvider(
        githubProvider,
      );

      final User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
        } else {
          //Logique si l'utilisateur n'est pas nouveau
        }
        logger.d("Connexion réussie avec GitHub !");
        Navigator.pushReplacementNamed(context, '/diary');
      } else {
        logger.d("Erreur lors de la connexion");
      }
    } catch (e) {
      logger.d("Une erreur est survenue lors de la connexion : $e");
    }
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text("Retourner à l'accueil"),
            ),
          ],
        ),
      ),
    );
  }
}
