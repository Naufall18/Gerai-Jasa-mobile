import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  // ──────────────────────────────────────────────────────────────
  // 👉 ALAMAT BACKEND — cukup ganti DI SINI (mirip .env)
  // ──────────────────────────────────────────────────────────────
  // Saat run di HP FISIK (HP & laptop di WiFi yang sama), isi IP LAN laptop.
  // Cari lewat `ipconfig` → cari "IPv4 Address" pada adapter "Wireless LAN Wi-Fi".
  // Contoh: '192.168.1.4'. Kosongkan ('') kalau pakai emulator / web / desktop.
  static const String lanIp = '192.168.1.4';

  // Override saat compile (opsional, paling diutamakan):
  //   flutter run --dart-define=API_BASE_URL=http://192.168.1.4:8000/api/v1
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Urutan resolusi base URL:
  ///   1. --dart-define=API_BASE_URL  (kalau diberikan)
  ///   2. lanIp                       (HP fisik di WiFi yang sama)
  ///   3. 10.0.2.2                    (emulator Android → host laptop)
  ///   4. localhost                   (iOS simulator / web / desktop)
  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (lanIp.isNotEmpty) return 'http://$lanIp:8000/api/v1';
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
