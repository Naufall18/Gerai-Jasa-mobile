<div align="center">
  <br/>
  <h1>📱 Gerai Jasa — Mobile App</h1>
  <p>
    <strong>Flutter 3.x Customer App</strong>
    <br/>
    Aplikasi booking multi-vendor untuk pelanggan
  </p>

  <p>
    <a href="#">
      <img src="https://img.shields.io/badge/status-selesai-brightgreen?style=flat-square&color=%231E6F5C" alt="Status"/>
    </a>
    <a href="https://flutter.dev">
      <img src="https://img.shields.io/badge/Flutter-3-%23025DF8?style=flat-square&logo=flutter" alt="Flutter"/>
    </a>
    <a href="https://dart.dev">
      <img src="https://img.shields.io/badge/Dart-3-%230175C2?style=flat-square&logo=dart" alt="Dart"/>
    </a>
    <a href="https://firebase.google.com">
      <img src="https://img.shields.io/badge/Firebase-FCM-%23FFCA28?style=flat-square&logo=firebase" alt="Firebase"/>
    </a>
  </p>

  <br/>
</div>

---

## 📋 Daftar Isi

- [Tentang](#-tentang)
- [Tech Stack](#-tech-stack)
- [Fitur Lengkap](#-fitur-lengkap)
- [Design System](#-design-system)
- [Struktur](#-struktur)
- [Setup](#-setup)
- [Alur Aplikasi](#-alur-aplikasi)
- [Troubleshooting](#-troubleshooting)
- [Build & Distribusi](#-build--distribusi)
- [Repositori Terkait](#-repositori-terkait)
- [Lisensi](#-lisensi)

---

## 🎯 Tentang

Aplikasi mobile **Gerai Jasa** untuk pelanggan — temukan vendor, booking layanan, bayar, dan beri ulasan, semuanya dari satu aplikasi.

**✅ Status: Production Ready** — Semua fitur inti telah diimplementasikan dan siap digunakan.

---

## 🛠️ Tech Stack

| Kategori | Teknologi |
|----------|-----------|
| **Framework** | Flutter 3.x (Dart 3) |
| **State Management** | Riverpod |
| **Navigation** | GoRouter + Auth Guard |
| **HTTP Client** | Dio |
| **Models** | Freezed + json_serializable |
| **Storage** | flutter_secure_storage |
| **Push Notifications** | Firebase Messaging |
| **Image Caching** | cached_network_image |
| **Loading Skeleton** | shimmer |
| **Animations** | Lottie |
| **SVG** | flutter_svg |
| **Deep Links** | url_launcher |
| **Payment** | webview_flutter (Midtrans) |
| **Fonts** | Google Fonts (Plus Jakarta Sans) |

---

## ✨ Fitur Lengkap

### 🔐 Auth & Onboarding

| Fitur | Detail | Status |
|-------|--------|--------|
| Splash Screen | Logo animasi, auto-token check, redirect | ✅ |
| Onboarding | 3 slide dengan ilustrasi unDraw (recolored) | ✅ |
| Login OTP | Input nomor → 6 digit OTP via WhatsApp | ✅ |
| Profile Setup | Nama & email setelah first login | ✅ |

### 🏠 Home

| Fitur | Detail | Status |
|-------|--------|--------|
| Greeting | "Halo, {nama}" personalized | ✅ |
| Search Bar | Tap → halaman search | ✅ |
| Category Chips | Filter vendor by kategori | ✅ |
| Featured Vendors | Horizontal scroll, hero image + "Unggulan" badge | ✅ |
| All Vendors | List vertikal dengan GJVendorCard | ✅ |
| Pull-to-refresh | Refresh vendor & categories | ✅ |
| Entry Animation | Fade + slide per section | ✅ |

### 🔍 Search

| Fitur | Detail | Status |
|-------|--------|--------|
| Debounced Search | Real-time search results | ✅ |
| Filter Bottom Sheet | Filter by kategori, lokasi, harga | ✅ |
| Infinite Scroll | Pagination on scroll | ✅ |

### 📅 Booking Flow

| Fitur | Detail | Status |
|-------|--------|--------|
| Vendor Detail | Hero image parallax, info, services list | ✅ |
| Pilih Layanan | Tap → langsung ke booking | ✅ |
| Pilih Tanggal | Date picker (H+1 s/d 30 hari) | ✅ |
| Pilih Slot | Available time slots, visual chip | ✅ |
| Catatan | Notes & special requests | ✅ |
| Pilih Pembayaran | COD atau Midtrans | ✅ |
| Midtrans Payment | WebView Snap | ✅ |
| Booking Success | Lottie animation + kode booking | ✅ |

### 📋 Booking Management

| Fitur | Detail | Status |
|-------|--------|--------|
| Tab Mendatang | Booking pending/confirmed/in_progress | ✅ |
| Tab Riwayat | Booking completed/cancelled | ✅ |
| Status Badge | Warna per status (amber, blue, green, red) | ✅ |
| Detail Booking | Info lengkap, status card, payment info | ✅ |
| Cancel Booking | Dengan konfirmasi dialog | ✅ |
| Give Review | Rating + komentar (muncul jika completed) | ✅ |
| Vendor Photo | Foto vendor di kartu booking | ✅ |

### ⭐ Reviews

| Fitur | Detail | Status |
|-------|--------|--------|
| Star Rating | 1–5 bintang interaktif | ✅ |
| Komentar | Text field multiline | ✅ |
| Submit | POST ke backend | ✅ |
| Sukses Notif | SnackBar + pop back | ✅ |

### 👤 Profile & Settings

| Fitur | Detail | Status |
|-------|--------|--------|
| Profile Info | Avatar, nama, email | ✅ |
| Edit Profile | Edit nama, email, upload avatar | ✅ |
| Notification Settings | FCM toggle | ✅ |
| Help & FAQ | Expansion tile FAQ + WA/Email contact | ✅ |
| Privacy Policy | Static page | ✅ |
| Logout | Clear token, redirect ke login | ✅ |

### 🔔 Notifications

| Fitur | Detail | Status |
|-------|--------|--------|
| FCM Push | Firebase Cloud Messaging | ✅ |
| Foreground Toast | GJToast slide from right | ✅ |
| Deep Link | Tap notif → booking detail | ✅ |
| Notification List | History screen | ✅ |

---

## 🎨 Design System

### Brand Identity — "Pine & Amber"
Warna khas: hijau pinus (`#1E6F5C`) dipadu ember hangat (`#F2A444`).

### Design Tokens

Semua token didefinisikan di `lib/core/theme/design_tokens.dart`:

#### Colors (`GJColors`)
```
primary      #1E6F5C  ← Hijau pinus (brand utama)
primaryDark  #14463B  ← Hijau gelap
primarySoft  #D8EEE7  ← Hijau lembut (background)
accent       #F2A444  ← Ember hangat (CTA, badge)
accentSoft   #FFF1DD  ← Ember lembut

ink          #14241F  ← Teks utama
textSoft     #55615D  ← Teks sekunder
surface      #FBFAF7  ← Background halaman
surfaceAlt   #F5F3EF  ← Background alternatif
card         #FFFFFF  ← Kartu
border       #E3E8E2  ← Garis tepi

success      #2E8B57
warning      #D68A1F
danger       #C94A4A
info         #2C8C84
```

#### Spacing (`GJSpacing`)
```dart
xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48
```

#### Radius (`GJRadius`)
```dart
sm=8, md=12, lg=16, xl=20, pill=999
card = BorderRadius asymmetric (6, 18, 18, 18)
```

#### Motion (`GJMotion`)
```dart
fast=150ms, base=250ms, slow=400ms
curve = easeOutCubic
```

#### Shadow (`GJShadow`)
```dart
sm = offset(0,4) blur(10) alpha(0.05)
md = offset(0,10) blur(24) alpha(0.08)
```

### Shared Widgets

| Widget | Lokasi | Fungsi |
|--------|--------|--------|
| `GJVendorCard` | `core/widgets/` | Kartu vendor horizontal (home & search) |
| `GJShimmer` | `core/widgets/` | Loading skeleton |
| `GJEmptyState` | `core/widgets/` | Empty state dengan icon + teks |
| `GJToast` | `core/widgets/` | Animated toast notifikasi |
| `GJBottomNav` | `core/widgets/` | Bottom navigation bar |

---

## 📁 Struktur

```
lib/
│
├── core/
│   ├── api/
│   │   ├── api_client.dart          # Dio instance + interceptors
│   │   └── api_exceptions.dart      # Error handling
│   │
│   ├── constants/
│   │   └── app_constants.dart       # Base URL, LAN IP, keys
│   │
│   ├── router/
│   │   └── app_router.dart          # GoRouter + auth redirect
│   │
│   ├── services/
│   │   └── push_notification_service.dart  # FCM setup
│   │
│   ├── theme/
│   │   └── design_tokens.dart       # GJColors, GJSpacing, dll
│   │
│   └── widgets/
│       ├── gj_vendor_card.dart      # Vendor card component
│       ├── gj_shimmer.dart          # Loading skeleton
│       ├── gj_empty_state.dart      # Empty state
│       ├── gj_toast.dart            # Toast notification
│       └── gj_bottom_nav.dart       # Bottom nav bar
│
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart   # Auth state management
│   │   └── screens/
│   │       ├── splash_screen.dart
│   │       ├── onboarding_screen.dart
│   │       ├── phone_input_screen.dart
│   │       ├── otp_verification_screen.dart
│   │       └── profile_setup_screen.dart
│   │
│   ├── home/
│   │   ├── providers/               # Home-specific providers
│   │   └── screens/
│   │       └── home_screen.dart     # Main home page
│   │
│   ├── search/
│   │   ├── providers/               # Search state
│   │   └── screens/
│   │       └── search_screen.dart   # Search + filter
│   │
│   ├── booking/
│   │   ├── providers/               # Booking state
│   │   └── screens/
│   │       ├── vendor_detail_screen.dart
│   │       ├── booking_screen.dart
│   │       ├── bookings_screen.dart
│   │       ├── booking_detail_screen.dart
│   │       └── review_screen.dart
│   │
│   ├── payment/
│   │   ├── screens/
│   │   │   ├── payment_screen.dart
│   │   │   ├── payment_webview_screen.dart
│   │   │   └── booking_success_screen.dart
│   │   └── providers/
│   │
│   ├── notifications/
│   │   ├── providers/
│   │   │   └── notification_provider.dart
│   │   └── screens/
│   │       └── notifications_screen.dart
│   │
│   └── profile/
│       ├── providers/
│       └── screens/
│           ├── profile_screen.dart
│           ├── edit_profile_screen.dart
│           ├── notification_settings_screen.dart
│           ├── help_screen.dart
│           └── privacy_policy_screen.dart
│
└── shared/
    ├── models/                      # Data models
    │   ├── models.dart              # + typedefs
    │   ├── user.dart
    │   ├── vendor.dart
    │   ├── booking.dart
    │   └── ...
    │
    └── providers/                   # Shared providers
        ├── booking_provider.dart
        └── vendor_provider.dart
```

---

## 🚀 Setup

### Prasyarat
- Flutter SDK 3.x
- Dart 3.x
- Emulator / HP fisik (debug mode)

### Clone & Install
```bash
git clone https://github.com/Naufall18/Gerai-Jasa-mobile.git
cd Gerai-Jasa-mobile

flutter pub get
```

### Konfigurasi

**1. Atur IP Backend**

Edit `lib/core/constants/app_constants.dart`:
```dart
class AppConstants {
  // Ganti dengan IP laptop di jaringan WiFi yang sama
  static const String lanIp = '192.168.1.4';
}
```

Atau via `--dart-define`:
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.4:8000/api/v1
```

**2. Firebase (opsional — untuk push notification)**
```bash
# Generate firebase_options.dart
flutterfire configure

# Download google-services.json → android/app/
```

### Jalankan
```bash
# Development
flutter run

# Dengan selected device
flutter run -d emulator-5554
flutter run -d "iPhone 15"
```

---

## 🧭 Alur Aplikasi

```
Splash Screen
    │
    ├── (token valid) ──▶ Home
    │
    └── (no token) ──▶ Onboarding
                            │
                            ▼
                       Phone Input
                            │
                            ▼
                       OTP Verify
                            │
                            ▼
                       Profile Setup
                            │
                            ▼
                          Home

Home → Search → Filter results
Home → Vendor Detail → Booking → Payment → Success
Home → Bookings (tab) → Booking Detail → Review
Home → Profile → Edit Profile / Settings / Help
```

---

## 🐛 Troubleshooting

### Foto avatar / vendor tidak muncul
```
Penyebab: IP backend tidak sesuai
Solusi:   Update lanIp di app_constants.dart
          Pastikan HP dan laptop di WiFi yang sama
```

### Firebase / FCM error
```
Penyebab: Belum generate firebase_options.dart
Solusi:   flutterfire configure
          Download google-services.json
```

### Error "No slots available"
```
Penyebab: Belum generate time slots
Solusi:   php artisan slots:generate (di backend)
```

### Error "Connection refused"
```
Penyebab: Backend tidak jalan atau IP salah
Solusi:   Pastikan php artisan serve berjalan
          Cek firewall (port 8000)
```

---

## 📦 Build & Distribusi

### Android
```bash
# APK (direct install)
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release

# Split APK per architecture
flutter build apk --release --split-per-abi
```

Hasil build: `build/app/outputs/flutter-apk/app-release.apk`

### iOS (macOS required)
```bash
flutter build ios --release
# Open in Xcode → Archive → Upload to App Store
```

### GitHub Releases
Upload APK ke GitHub Releases untuk distribusi langsung:
```
Repo: https://github.com/Naufall18/Gerai-Jasa-mobile
Path: Releases → Draft new → Upload APK
```

---

## 📦 Repositori Terkait

| Repositori | Link | Status |
|-----------|------|--------|
| Monorepo Utama | [Gerai-Jasa](https://github.com/Naufall18/Gerai-Jasa) | 🔒 Private |
| Backend API | [Gerai-Jasa-backend](https://github.com/Naufall18/Gerai-Jasa-backend) | ✅ Public |
| Web Dashboard | [Gerai-Jasa-web](https://github.com/Naufall18/Gerai-Jasa-web) | ✅ Public |

---

## 👨‍💻 Pengembang

**Naufall18** — [GitHub](https://github.com/Naufall18)

---

## 📄 Lisensi

**MIT License** — Copyright © 2026 Naufall18

<div align="center">
  <br/>
  <sub>Dibangun dengan ❤️ untuk ekosistem digital Indonesia</sub>
  <br/>
  <br/>
</div>
