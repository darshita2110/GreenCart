// lib/firebase_options.dart
// ⚠️ IMPORTANT: Replace all YOUR_*_KEY / YOUR_*_ID placeholders with your
// actual Firebase project values from the Firebase Console.
// After running `flutterfire configure`, this file is auto-generated.
// DO NOT commit real keys to version control.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions are not supported for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for Linux.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for Fuchsia.',
        );
    }
  }

  // ---------------------------------------------------------------------------
  // WEB — replace with values from Firebase Console → Project settings → Web
  // ---------------------------------------------------------------------------
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: '',
    authDomain: '',
    storageBucket: '',
  );

  // ---------------------------------------------------------------------------
  // ANDROID — replace with values from google-services.json
  // ---------------------------------------------------------------------------
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: '',
    storageBucket: '',
  );

  // ---------------------------------------------------------------------------
  // iOS — replace with values from GoogleService-Info.plist
  // ---------------------------------------------------------------------------
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: '',
    storageBucket: '',
    iosBundleId: '',
  );

  // ---------------------------------------------------------------------------
  // macOS — replace with values from GoogleService-Info.plist (macOS target)
  // ---------------------------------------------------------------------------
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'green-cart-5c809',
    storageBucket: 'green-cart-5c809.appspot.com',
    iosBundleId: 'com.example.greencart',
  );
}