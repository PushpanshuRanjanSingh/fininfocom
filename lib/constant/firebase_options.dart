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
    apiKey: 'AIzaSyDr9jr_wEKkgAJBIwwlo86wLHIyuc4uIGk',
    appId: '1:61041269897:web:144cb357c88a58b200fa58',
    messagingSenderId: '61041269897',
    projectId: 'fininfocom-uk',
    authDomain: 'fininfocom-uk.firebaseapp.com',
    storageBucket: 'fininfocom-uk.appspot.com',
    measurementId: 'G-5P308BECLS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7G4RtIWdmX6I5bVde0TUWfpHz3JkyOg0',
    appId: '1:61041269897:android:c6044ab9f854750400fa58',
    messagingSenderId: '61041269897',
    projectId: 'fininfocom-uk',
    storageBucket: 'fininfocom-uk.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRGiPPdMMEcOo7XMHmKDGwX4pYuGcf2kY',
    appId: '1:61041269897:ios:6fadb5db0115a7b600fa58',
    messagingSenderId: '61041269897',
    projectId: 'fininfocom-uk',
    storageBucket: 'fininfocom-uk.appspot.com',
    iosClientId: '61041269897-kaekeu7hjau7poqel4ghakqs4nh2ck3s.apps.googleusercontent.com',
    iosBundleId: 'com.example.fininfocom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDRGiPPdMMEcOo7XMHmKDGwX4pYuGcf2kY',
    appId: '1:61041269897:ios:6fadb5db0115a7b600fa58',
    messagingSenderId: '61041269897',
    projectId: 'fininfocom-uk',
    storageBucket: 'fininfocom-uk.appspot.com',
    iosClientId: '61041269897-kaekeu7hjau7poqel4ghakqs4nh2ck3s.apps.googleusercontent.com',
    iosBundleId: 'com.example.fininfocom',
  );
}