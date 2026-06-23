import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  /// Compile-time override. Run with, e.g.:
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000/api/v1
  /// Use this for a physical device pointing at your machine's LAN IP.
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Resolves the API base URL per platform:
  /// - explicit `--dart-define=API_BASE_URL` always wins (physical devices)
  /// - Android emulator reaches the host machine via 10.0.2.2
  /// - everything else (iOS simulator, web, desktop) uses localhost
  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://localhost:8000/api/v1';
  }

  static const String midtransClientKey = 'SB-Mid-client-Dummy';
  static const String appName = 'Gerai Jasa';
  static const int otpLength = 6;
  static const int otpTimeout = 60; // seconds
  static const int slotCacheSeconds = 60;
}
