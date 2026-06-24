// Smoke tests untuk Gerai Jasa.
//
// Catatan: belum ada widget/integration test yang berarti untuk aplikasi ini.
// Test penuh aplikasi memerlukan mock platform channel (FlutterSecureStorage,
// Firebase) dan override Riverpod provider. Untuk saat ini test berikut
// memvalidasi konfigurasi inti tanpa dependensi platform.

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('baseUrl adalah URL API http(s) yang valid', () {
      expect(AppConstants.baseUrl, startsWith('http'));
      expect(AppConstants.baseUrl, contains('/api/v1'));
    });

    test('metadata aplikasi masuk akal', () {
      expect(AppConstants.appName, isNotEmpty);
      expect(AppConstants.otpLength, greaterThan(0));
      expect(AppConstants.otpTimeout, greaterThan(0));
    });
  });
}
