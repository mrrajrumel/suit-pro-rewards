// File: lib/core/firebase_options.dart
//
// This file is a placeholder for your Firebase project's credentials.
// You will need to replace the placeholder values with your actual
// Firebase project credentials.
//
// To get your Firebase project credentials, go to the Firebase console,
// open your project, and click on the "Project settings" icon.
// Then, in the "Your apps" card, select the app for which you want to
// get the credentials.
//
// For more information, see the following documentation:
//
// * Add Firebase to your Flutter app:
//   https://firebase.google.com/docs/flutter/setup

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    measurementId: 'YOUR_MEASUREMENT_ID',
    firestoreDatabaseId: '(default)',
  );
}

class FirebaseOptions {
  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.authDomain,
    required this.databaseURL,
    required this.storageBucket,
    required this.measurementId,
    required this.firestoreDatabaseId,
  });

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String authDomain;
  final String databaseURL;
  final String storageBucket;
  final String measurementId;
  final String firestoreDatabaseId;
}
