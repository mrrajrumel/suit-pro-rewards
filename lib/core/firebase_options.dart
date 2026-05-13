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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCgCP_WHTNdZhrlG5vBWopVGFuacB5hfcI',
    appId: '1:1060378684053:web:dummy', // Placeholder for web
    messagingSenderId: '1060378684053',
    projectId: 'suitprolondonrewords',
    authDomain: 'suitprolondonrewords.firebaseapp.com',
    storageBucket: 'suitprolondonrewords.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgCP_WHTNdZhrlG5vBWopVGFuacB5hfcI',
    appId: '1:1060378684053:android:28c351a471d397c5d2899c',
    messagingSenderId: '1060378684053',
    projectId: 'suitprolondonrewords',
    storageBucket: 'suitprolondonrewords.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgCP_WHTNdZhrlG5vBWopVGFuacB5hfcI',
    appId: '1:1060378684053:ios:dummy', // Placeholder for ios
    messagingSenderId: '1060378684053',
    projectId: 'suitprolondonrewords',
    storageBucket: 'suitprolondonrewords.firebasestorage.app',
    iosBundleId: 'com.suitpro.app',
  );
}
