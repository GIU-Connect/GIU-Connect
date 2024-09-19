// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    dotenv.load(); // Load the environment variables

    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: dotenv.env['WEB_API_KEY']!,
        appId: dotenv.env['WEB_APP_ID']!,
        messagingSenderId: dotenv.env['WEB_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['WEB_PROJECT_ID']!,
        authDomain: dotenv.env['WEB_AUTH_DOMAIN']!,
        storageBucket: dotenv.env['WEB_STORAGE_BUCKET']!,
        measurementId: dotenv.env['WEB_MEASUREMENT_ID']!,
      );
    }
    // Check for Android
    if (defaultTargetPlatform == TargetPlatform.android) {
      return FirebaseOptions(
        apiKey: dotenv.env['ANDROID_API_KEY']!,
        appId: dotenv.env['ANDROID_APP_ID']!,
        messagingSenderId: dotenv.env['ANDROID_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['ANDROID_PROJECT_ID']!,
        storageBucket: dotenv.env['ANDROID_STORAGE_BUCKET']!,
      );
    }
    // Check for iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return FirebaseOptions(
        apiKey: dotenv.env['IOS_API_KEY']!,
        appId: dotenv.env['IOS_APP_ID']!,
        messagingSenderId: dotenv.env['IOS_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['IOS_PROJECT_ID']!,
        storageBucket: dotenv.env['IOS_STORAGE_BUCKET']!,
        iosBundleId: dotenv.env['IOS_BUNDLE_ID']!,
      );
    }
    // Check for macOS
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return FirebaseOptions(
        apiKey: dotenv.env['MACOS_API_KEY']!,
        appId: dotenv.env['MACOS_APP_ID']!,
        messagingSenderId: dotenv.env['MACOS_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['MACOS_PROJECT_ID']!,
        storageBucket: dotenv.env['MACOS_STORAGE_BUCKET']!,
        iosBundleId: dotenv.env['MACOS_BUNDLE_ID']!,
      );
    }
    // Check for Windows
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return FirebaseOptions(
        apiKey: dotenv.env['WINDOWS_API_KEY']!,
        appId: dotenv.env['WINDOWS_APP_ID']!,
        messagingSenderId: dotenv.env['WINDOWS_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['WINDOWS_PROJECT_ID']!,
        authDomain: dotenv.env['WINDOWS_AUTH_DOMAIN']!,
        storageBucket: dotenv.env['WINDOWS_STORAGE_BUCKET']!,
        measurementId: dotenv.env['WINDOWS_MEASUREMENT_ID']!,
      );
    }

    throw UnsupportedError('Current platform is not supported');
  }
}
