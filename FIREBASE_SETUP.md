# Setup Firebase / FCM (wajib dijalankan manual)

Kode FCM di aplikasi sudah siap (`lib/core/services/push_notification_service.dart`),
tapi belum aktif karena **kredensial Firebase harus dibuat dengan akun Anda**.
`PushNotificationService.init()` saat ini gagal-aman (try/catch) sampai langkah di
bawah selesai — begitu file kredensial ada, FCM langsung hidup tanpa ubah kode.

## Prasyarat (sekali saja)

```bash
# Firebase CLI
npm install -g firebase-tools
firebase login

# FlutterFire CLI
dart pub global activate flutterfire_cli
```

Pastikan `~/.pub-cache/bin` (atau `%LOCALAPPDATA%\Pub\Cache\bin` di Windows) ada di PATH.

## Generate konfigurasi

Dari folder `mobile/`:

```bash
flutterfire configure
```

Pilih (atau buat) project Firebase, lalu pilih platform Android (dan iOS bila perlu).
Perintah ini menghasilkan:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- (iOS) `ios/Runner/GoogleService-Info.plist`

## Aktifkan di kode

Setelah `firebase_options.dart` ada, ubah `init()` agar memakai opsi platform.
Di `lib/core/services/push_notification_service.dart`:

```dart
import '../../firebase_options.dart';
// ...
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Setup Gradle Android (jika belum ditangani flutterfire)

`android/build.gradle` (project-level), bagian `plugins`/`dependencies`:

```gradle
classpath 'com.google.gms:google-services:4.4.2'
```

`android/app/build.gradle`, paling bawah:

```gradle
apply plugin: 'com.google.gms.google-services'
```

## Uji

1. `flutter run`
2. Login di aplikasi → token FCM otomatis dikirim ke backend
   (`POST /auth/fcm-token`, sudah terpasang di `auth_provider.dart`).
3. Kirim test message dari Firebase Console → Cloud Messaging.
   - App di foreground → muncul SnackBar.
   - Tap notifikasi (background/terminated) dengan `data: { booking_id: "<id>" }`
     → app membuka `/booking-detail/<id>` (deep link sudah terpasang).

## Backend → payload data untuk deep link

Saat backend mengirim FCM, sertakan `data` agar deep link bekerja:

```json
{
  "notification": { "title": "...", "body": "..." },
  "data": { "booking_id": "<uuid booking>" }
}
```
