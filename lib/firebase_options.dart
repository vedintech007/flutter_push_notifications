// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB2NkkzqTVLgteh_wtMTtdKIO5YD5sQc48',
    appId: '1:689516090319:web:8b5bd1d89e3f8fd236f8ba',
    messagingSenderId: '689516090319',
    projectId: 'flutter-fcm-proj',
    authDomain: 'flutter-fcm-proj.firebaseapp.com',
    storageBucket: 'flutter-fcm-proj.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVIn1QM1siARRXtbWY2zNhM-GCOdBtuuc',
    appId: '1:689516090319:android:5a8c7b6f2f911f6336f8ba',
    messagingSenderId: '689516090319',
    projectId: 'flutter-fcm-proj',
    storageBucket: 'flutter-fcm-proj.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaUJlrkIRkLf98ciGfEyzVnJYsfBhgYak',
    appId: '1:689516090319:ios:40db9ad680096b5a36f8ba',
    messagingSenderId: '689516090319',
    projectId: 'flutter-fcm-proj',
    storageBucket: 'flutter-fcm-proj.appspot.com',
    iosBundleId: 'com.codeconline.flutterFcm',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaUJlrkIRkLf98ciGfEyzVnJYsfBhgYak',
    appId: '1:689516090319:ios:5638b18d108ff25836f8ba',
    messagingSenderId: '689516090319',
    projectId: 'flutter-fcm-proj',
    storageBucket: 'flutter-fcm-proj.appspot.com',
    iosBundleId: 'com.codeconline.flutterFcm.RunnerTests',
  );
}