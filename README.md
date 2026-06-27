# Gerai Jasa Mobile App

Flutter 3.x customer app untuk **Gerai Jasa** — platform booking multi-vendor (salon, klinik, bengkel, dll) untuk pasar Indonesia.

**Desain:** Pine & Amber (#1E6F5C primary, #F2A444 accent)
**Font:** Plus Jakarta Sans

---

## Tech Stack

- **Flutter 3.x** (Dart 3)
- **Riverpod** (state management)
- **GoRouter** (navigation + auth guard)
- **Dio** (HTTP client)
- **Freezed** + **json_serializable** (immutable models)
- **flutter_secure_storage** (token storage)
- **Firebase Messaging** (push notifications)
- **cached_network_image** (image caching)
- **shimmer** (loading skeletons)
- **Lottie** (animations)
- **flutter_svg** (SVG support)
- **url_launcher** (WA & email links)
- **webview_flutter** (Midtrans payment)

---

## Fitur

### Auth
- Splash screen dengan logo animasi + auto-token check
- Onboarding 3 slide (SVG ilustrasi unDraw, recolored ke brand)
- Login via OTP WhatsApp (input nomor → 6 digit OTP)
- Profile setup setelah first login (nama & email)

### Home
- Greeting personalized dengan nama user
- Search bar (tap → `/search`)
- Category chips (filter vendor by kategori)
- Vendor unggulan (horizontal scroll, hero image + rating)
- Semua vendor (list vertikal dengan GJVendorCard)
- Pull-to-refresh

### Search
- Debounced search
- Filter bottom sheet (kategori, lokasi, harga)
- Infinite scroll pagination

### Booking Flow
- **Vendor Detail** — Hero image parallax, info vendor, daftar layanan, tombol booking
- **Booking Steps** — Pilih tanggal → pilih slot waktu → catatan → metode bayar
- **Payment** — Midtrans WebView atau COD
- **Success** — Animasi Lottie + kode booking

### My Bookings
- Tab: Mendatang / Riwayat
- Tiap kartu: kode booking, nama vendor, layanan, jadwal, total harga, status badge
- Tap → detail booking
- Vendor photo di kartu booking

### Booking Detail
- Status & kode booking
- Informasi layanan (vendor, tanggal, jam)
- Informasi pembayaran
- Catatan pelanggan
- Tombol: **Batalkan Booking** (pending/confirmed), **Berikan Ulasan** (completed)

### Review
- Rating 1–5 bintang
- Komentar
- Submit ke endpoint `/bookings/{id}/review`

### Profile
- Foto avatar, nama, email
- Menu: Edit Profile, Notifikasi, Bantuan, Kebijakan Privasi, Logout

### Notifications
- Firebase Cloud Messaging (push notification)
- Deep link ke booking detail saat notifikasi di-tap
- Foreground toast (GJToast slide from right)

---

## Design System

### Tokens (lihat `lib/core/theme/design_tokens.dart`)
| Token | Value |
|-------|-------|
| `GJColors.primary` | #1E6F5C |
| `GJColors.accent` | #F2A444 |
| `GJColors.ink` | #14241F |
| `GJColors.surface` | #FBFAF7 |
| `GJSpacing.lg` | 16px |
| `GJRadius.card` | BorderRadius asimetris (6, 18, 18, 18) |
| `GJMotion.base` | 250ms easeOutCubic |
| `GJShadow.sm` | Subtle shadow |

### Widgets Bersama
| Widget | Lokasi | Fungsi |
|--------|--------|--------|
| `GJVendorCard` | `core/widgets/` | Kartu vendor horizontal (home & search) |
| `GJShimmer` | `core/widgets/` | Loading skeleton |
| `GJEmptyState` | `core/widgets/` | Empty state dengan icon + teks |
| `GJToast` | `core/widgets/` | Animated toast (slide from right) |
| `GJBottomNav` | `core/widgets/` | Bottom navigation bar |

---

## Struktur Folder

```
lib/
├── core/
│   ├── api/               # Dio client, interceptors
│   ├── constants/          # AppConstants (base URL, LAN IP)
│   ├── router/             # GoRouter + auth redirect
│   ├── services/           # PushNotificationService
│   ├── theme/              # Design tokens (GJColors, GJSpacing, dll)
│   └── widgets/            # Widget bersama (GJVendorCard, GJShimmer, dll)
├── features/
│   ├── auth/               # Splash, Onboarding, PhoneInput, OTP, ProfileSetup
│   ├── home/               # Home screen, categories, vendors
│   ├── search/             # Search, filters, results
│   ├── booking/            # VendorDetail, Booking, Bookings, BookingDetail, Review
│   ├── payment/            # Payment, PaymentWebView, BookingSuccess
│   ├── notifications/      # Notifications list screen
│   └── profile/            # Profile, EditProfile, Help, Privacy, NotificationSettings
└── shared/
    ├── models/             # Data models (BookingModel, VendorModel, dll)
    └── providers/          # Shared providers (booking, vendor)
```

---

## Setup

```bash
git clone https://github.com/Naufall18/Gerai-Jasa-mobile.git
cd Gerai-Jasa-mobile

flutter pub get

# Update API base URL di lib/core/constants/app_constants.dart
# Atur LAN IP sesuai IP laptop di jaringan WiFi

flutter run
```

### Konfigurasi

```dart
// lib/core/constants/app_constants.dart
static const String lanIp = '192.168.1.4';  // IP laptop di WiFi
```

Gunakan `--dart-define` untuk override:
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.4:8000/api/v1
```

### Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (macOS required)
flutter build ios --release
```

---

## Troubleshooting

### Foto avatar tidak muncul
- Pastikan `lanIp` di `app_constants.dart` sesuai IP laptop
- Cek koneksi HP ke WiFi yang sama dengan laptop

### Firebase notifikasi tidak work
- Generate `firebase_options.dart`: `flutterfire configure`
- Download `google-services.json` ke `android/app/`

---

## Repositori Terkait

- **Backend API**: [Gerai-Jasa-backend](https://github.com/Naufall18/Gerai-Jasa-backend)
- **Web Dashboard**: [Gerai-Jasa-web](https://github.com/Naufall18/Gerai-Jasa-web)
- **Fullstack**: [Gerai-Jasa](https://github.com/Naufall18/Gerai-Jasa)

---

## Lisensi

MIT
