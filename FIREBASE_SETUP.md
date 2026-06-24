# Firebase / FCM — Status: SUDAH DIKONFIGURASI ✅

Firebase sudah disetup untuk Android dan terverifikasi (build APK debug sukses).

## Yang sudah dikerjakan

- Project Firebase: **gerai-jasa-naufall18** (akun naufan970@gmail.com)
  - Console: https://console.firebase.google.com/project/gerai-jasa-naufall18/overview
- Android app terdaftar: package `com.example.mobile`
  - App Id: `1:448322015665:android:c4272f8b7947593dccad90`
- File yang di-generate `flutterfire configure`:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
  - Plugin gradle `com.google.gms.google-services` (settings.gradle.kts + app/build.gradle.kts)
- `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` di `push_notification_service.dart`
- Core library desugaring diaktifkan di `android/app/build.gradle.kts`
  (wajib untuk flutter_local_notifications)

## Cara uji

1. `flutter run` (device/emulator Android).
2. Login di aplikasi → token FCM otomatis dikirim ke backend
   (`POST /auth/fcm-token`, sudah terpasang di `auth_provider.dart`).
3. Firebase Console → Cloud Messaging → kirim test message:
   - App di foreground → muncul SnackBar.
   - Tap notifikasi (background/terminated) dengan data `booking_id`
     → app membuka `/booking-detail/<id>` (deep link).

## Format payload FCM dari backend (untuk deep link)

```json
{
  "notification": { "title": "...", "body": "..." },
  "data": { "booking_id": "<uuid booking>" }
}
```

## Catatan

- **iOS belum dikonfigurasi.** Untuk menambah iOS:
  `flutterfire configure --project=gerai-jasa-naufall18 --platforms=ios`
- **Package name** masih `com.example.mobile` (default). Jika ingin diganti
  (mis. `id.geraijasa.app`), lakukan rename package lalu jalankan ulang
  `flutterfire configure` agar google-services.json diperbarui.
- `google-services.json` & `firebase_options.dart` berisi **API key client**
  (bukan rahasia server) — aman di-commit sesuai panduan resmi Firebase, tapi
  tetap pertimbangkan visibilitas repo.
