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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB92p6H1KsDvHBXJBUENwNLYoPTceA2NY0',
    appId: '1:175485785588:web:e8199c22d4a6d0b66155a1',
    messagingSenderId: '175485785588',
    projectId: 'keywordly-0235',
    authDomain: 'keywordly-0235.firebaseapp.com',
    storageBucket: 'keywordly-0235.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAX-o51QFzsrZM7BEGYGfZJDyFaIz69II',
    appId: '1:175485785588:android:869c36410a170ee16155a1',
    messagingSenderId: '175485785588',
    projectId: 'keywordly-0235',
    storageBucket: 'keywordly-0235.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBeS5i3sDXiS4yNnm7RS6F9URlJSySWpm0',
    appId: '1:175485785588:ios:99ba27a94c1b30ff6155a1',
    messagingSenderId: '175485785588',
    projectId: 'keywordly-0235',
    storageBucket: 'keywordly-0235.appspot.com',
    iosClientId: '175485785588-dsdai3t42guqu2gc1tckg0aqqndg0alb.apps.googleusercontent.com',
    iosBundleId: 'com.example.keywordlyApp',
  );
}