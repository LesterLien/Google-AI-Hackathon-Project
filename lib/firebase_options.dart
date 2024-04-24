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
    apiKey: 'AIzaSyAI2pY8fECgr7ZcDuEBW0J0kM80E4ha-M8',
    appId: '1:88998535706:web:8e4aad90f17c5eb19527a3',
    messagingSenderId: '88998535706',
    projectId: 'aihackathon-739ad',
    authDomain: 'aihackathon-739ad.firebaseapp.com',
    databaseURL: 'https://aihackathon-739ad-default-rtdb.firebaseio.com',
    storageBucket: 'aihackathon-739ad.appspot.com',
    measurementId: 'G-HZQS0T02SL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbGaAXTJBfLVg6Wfa4oCT493Ky8eYT0Bc',
    appId: '1:88998535706:android:c07bd93275877b659527a3',
    messagingSenderId: '88998535706',
    projectId: 'aihackathon-739ad',
    databaseURL: 'https://aihackathon-739ad-default-rtdb.firebaseio.com',
    storageBucket: 'aihackathon-739ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGBpqOm09mRNlJVPgk6nlSJsa7iHbFx6E',
    appId: '1:88998535706:ios:2fc534d2349612f19527a3',
    messagingSenderId: '88998535706',
    projectId: 'aihackathon-739ad',
    databaseURL: 'https://aihackathon-739ad-default-rtdb.firebaseio.com',
    storageBucket: 'aihackathon-739ad.appspot.com',
    iosBundleId: 'com.fiveheads.hackathonproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGBpqOm09mRNlJVPgk6nlSJsa7iHbFx6E',
    appId: '1:88998535706:ios:2fc534d2349612f19527a3',
    messagingSenderId: '88998535706',
    projectId: 'aihackathon-739ad',
    databaseURL: 'https://aihackathon-739ad-default-rtdb.firebaseio.com',
    storageBucket: 'aihackathon-739ad.appspot.com',
    iosBundleId: 'com.fiveheads.hackathonproject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAI2pY8fECgr7ZcDuEBW0J0kM80E4ha-M8',
    appId: '1:88998535706:web:e1dabebfd7cdb6f79527a3',
    messagingSenderId: '88998535706',
    projectId: 'aihackathon-739ad',
    authDomain: 'aihackathon-739ad.firebaseapp.com',
    databaseURL: 'https://aihackathon-739ad-default-rtdb.firebaseio.com',
    storageBucket: 'aihackathon-739ad.appspot.com',
    measurementId: 'G-TMEGMM203F',
  );

}