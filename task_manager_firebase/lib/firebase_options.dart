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
    apiKey: 'AIzaSyARGOo_KfRqZi5mycB6XMW22-BCItdauh8',
    appId: '1:19222874887:web:1c108f2dfe4f7742f553a2',
    messagingSenderId: '19222874887',
    projectId: 'tp3-task-manager',
    authDomain: 'tp3-task-manager.firebaseapp.com',
    storageBucket: 'tp3-task-manager.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDY7lUOxktE8FFkP7my7M5aBI4TXXziDBY',
    appId: '1:19222874887:android:e378fc9d027c84aff553a2',
    messagingSenderId: '19222874887',
    projectId: 'tp3-task-manager',
    storageBucket: 'tp3-task-manager.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsR1HxF6Wnz54ohWECSLu_Qk72hnZcfuo',
    appId: '1:19222874887:ios:8a0a1b56255810b5f553a2',
    messagingSenderId: '19222874887',
    projectId: 'tp3-task-manager',
    storageBucket: 'tp3-task-manager.firebasestorage.app',
    iosClientId: '19222874887-erlnbirfs06qeiihl477k33c50boa0rd.apps.googleusercontent.com',
    iosBundleId: 'org.tp3fb.taskManagerFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsR1HxF6Wnz54ohWECSLu_Qk72hnZcfuo',
    appId: '1:19222874887:ios:8a0a1b56255810b5f553a2',
    messagingSenderId: '19222874887',
    projectId: 'tp3-task-manager',
    storageBucket: 'tp3-task-manager.firebasestorage.app',
    iosClientId: '19222874887-erlnbirfs06qeiihl477k33c50boa0rd.apps.googleusercontent.com',
    iosBundleId: 'org.tp3fb.taskManagerFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARGOo_KfRqZi5mycB6XMW22-BCItdauh8',
    appId: '1:19222874887:web:db091a4cc7aa4188f553a2',
    messagingSenderId: '19222874887',
    projectId: 'tp3-task-manager',
    authDomain: 'tp3-task-manager.firebaseapp.com',
    storageBucket: 'tp3-task-manager.firebasestorage.app',
  );
}
