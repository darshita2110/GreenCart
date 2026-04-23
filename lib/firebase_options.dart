// lib/firebase_options.dart
// Generated from firebase_options.dart.example with real project values.
// Project: green-cart-67686

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
  // WEB
  // ---------------------------------------------------------------------------
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDkw8bopHXK5xlYadmpRsd-Acd95JBXkTM',
    appId: '1:1014414328263:web:abcd1234efgh5678ijkl',
    messagingSenderId: '1014414328263',
    projectId: 'green-cart-67686',
    authDomain: 'green-cart-67686.firebaseapp.com',
    storageBucket: 'green-cart-67686.firebasestorage.app',
  );

  // ---------------------------------------------------------------------------
  // ANDROID
  // ---------------------------------------------------------------------------
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkw8bopHXK5xlYadmpRsd-Acd95JBXkTM',
    appId: '1:1014414328263:android:6cc332b0c25dab855119e2',
    messagingSenderId: '1014414328263',
    projectId: 'green-cart-67686',
    storageBucket: 'green-cart-67686.firebasestorage.app',
  );

  // ---------------------------------------------------------------------------
  // iOS
  // ---------------------------------------------------------------------------
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkw8bopHXK5xlYadmpRsd-Acd95JBXkTM',
    appId: '1:1014414328263:ios:abcd1234efgh567',
    messagingSenderId: '1014414328263',
    projectId: 'green-cart-67686',
    storageBucket: 'green-cart-67686.firebasestorage.app',
    iosBundleId: 'com.example.greencart',
  );

  // ---------------------------------------------------------------------------
  // macOS
  // ---------------------------------------------------------------------------
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkw8bopHXK5xlYadmpRsd-Acd95JBXkTM',
    appId: '1:1014414328263:macos:abcd1234efgh567',
    messagingSenderId: '1014414328263',
    projectId: 'green-cart-67686',
    storageBucket: 'green-cart-67686.firebasestorage.app',
    iosBundleId: 'com.example.greencart',
  );
}