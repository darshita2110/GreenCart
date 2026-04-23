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
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
      case TargetPlatform.fuchsia:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'YOUR_WEB_API_KEY',
  //   appId: 'YOUR_WEB_APP_ID',
  //   messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  //   projectId: 'green-cart-5c809',
  //   authDomain: 'green-cart-5c809.firebaseapp.com',
  //   storageBucket: 'green-cart-5c809.appspot.com',
  // );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'green-cart-5c809',
    storageBucket: 'green-cart-5c809.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'green-cart-5c809',
    storageBucket: 'green-cart-5c809.appspot.com',
    iosBundleId: 'com.example.greencart',  // ✅ Changed: no underscore
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'green-cart-5c809',
    storageBucket: 'green-cart-5c809.appspot.com',
    iosBundleId: 'com.example.greencart',  // ✅ Changed: no underscore
  );
}