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
    apiKey: 'AIzaSyAmt6eFJ7rvE-ke6AVJ01wDzUwpbUqnVKI',
    appId: '1:10879165640:web:e8fc1af81bacce30dff1fd',
    messagingSenderId: '10879165640',
    projectId: 'justsharelah-6dca5',
    authDomain: 'justsharelah-6dca5.firebaseapp.com',
    storageBucket: 'justsharelah-6dca5.appspot.com',
    measurementId: 'G-G1LWCXS2T0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCp1VNKc82AuklUJVaLTWczmSflEcmYAzE',
    appId: '1:10879165640:android:c657eaf794db8614dff1fd',
    messagingSenderId: '10879165640',
    projectId: 'justsharelah-6dca5',
    storageBucket: 'justsharelah-6dca5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQsTMIfIVUGUi9bfyHjBpgQPzo-4vHPhc',
    appId: '1:10879165640:ios:f463674769a076dadff1fd',
    messagingSenderId: '10879165640',
    projectId: 'justsharelah-6dca5',
    storageBucket: 'justsharelah-6dca5.appspot.com',
    androidClientId:
        '10879165640-ipqeaemtarv9h5kpgsr216su9r9pueqk.apps.googleusercontent.com',
    iosClientId:
        '10879165640-q602g5sl8aupgj1vmh1mfj22u8qp9vf6.apps.googleusercontent.com',
    iosBundleId: 'com.example.justsharelah_v1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQsTMIfIVUGUi9bfyHjBpgQPzo-4vHPhc',
    appId: '1:10879165640:ios:f463674769a076dadff1fd',
    messagingSenderId: '10879165640',
    projectId: 'justsharelah-6dca5',
    storageBucket: 'justsharelah-6dca5.appspot.com',
    androidClientId:
        '10879165640-ipqeaemtarv9h5kpgsr216su9r9pueqk.apps.googleusercontent.com',
    iosClientId:
        '10879165640-q602g5sl8aupgj1vmh1mfj22u8qp9vf6.apps.googleusercontent.com',
    iosBundleId: 'com.example.justsharelah_v1',
  );
}
