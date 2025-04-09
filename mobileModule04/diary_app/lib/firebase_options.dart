// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDVQ3NWao7tzjrBpffbFRxLf3VEUN4VTa4',
    appId: '1:154137296860:web:b8a23d4c8a2af4f02d5919',
    messagingSenderId: '154137296860',
    projectId: 'diaryapp-6f0e6',
    authDomain: 'diaryapp-6f0e6.firebaseapp.com',
    storageBucket: 'diaryapp-6f0e6.firebasestorage.app',
    measurementId: 'G-4KGFMWF8ED',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsTInOHpfwFvq3pJMVBn6h16fnAxCbhwU',
    appId: '1:154137296860:android:51c74edae607e6d22d5919',
    messagingSenderId: '154137296860',
    projectId: 'diaryapp-6f0e6',
    storageBucket: 'diaryapp-6f0e6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwe-mQ-I59Jv8itnDWug4Q8P9-PjoSgBY',
    appId: '1:154137296860:ios:1776a78aa99ae72a2d5919',
    messagingSenderId: '154137296860',
    projectId: 'diaryapp-6f0e6',
    storageBucket: 'diaryapp-6f0e6.firebasestorage.app',
    iosBundleId: 'com.example.diaryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwe-mQ-I59Jv8itnDWug4Q8P9-PjoSgBY',
    appId: '1:154137296860:ios:1776a78aa99ae72a2d5919',
    messagingSenderId: '154137296860',
    projectId: 'diaryapp-6f0e6',
    storageBucket: 'diaryapp-6f0e6.firebasestorage.app',
    iosBundleId: 'com.example.diaryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVQ3NWao7tzjrBpffbFRxLf3VEUN4VTa4',
    appId: '1:154137296860:web:9d1e23ec699165ea2d5919',
    messagingSenderId: '154137296860',
    projectId: 'diaryapp-6f0e6',
    authDomain: 'diaryapp-6f0e6.firebaseapp.com',
    storageBucket: 'diaryapp-6f0e6.firebasestorage.app',
    measurementId: 'G-QFFYELQLMF',
  );
}
