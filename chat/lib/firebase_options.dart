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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrHx2aXh_91lk3i5Mkp86UUWb1CvO6Prk',
    appId: '1:579654691871:android:1ad7fead0e83031815b92a',
    messagingSenderId: '579654691871',
    projectId: 'chat-82764',
    storageBucket: 'chat-82764.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9hE7KXtMKH5-WgP_WFkHYc1RsOoL0Xwc',
    appId: '1:579654691871:ios:48df0a7e8b62d81b15b92a',
    messagingSenderId: '579654691871',
    projectId: 'chat-82764',
    storageBucket: 'chat-82764.appspot.com',
    androidClientId: '579654691871-ib31obd0h2qjni4ifcujmgck02isen3g.apps.googleusercontent.com',
    iosClientId: '579654691871-qm38bsc0ih7ag1sneohl86lopbc74snv.apps.googleusercontent.com',
    iosBundleId: 'com.google.kaitokudou2468110921.chat',
  );
}
