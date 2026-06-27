<div align="center">

# 📱 Gerai Jasa — Mobile App

**Customer app for the Gerai Jasa booking platform**
<br/>
Find and book services — salons, clinics, workshops & more — in a few taps.

<p>
  <img src="https://img.shields.io/badge/status-Selesai-brightgreen?style=for-the-badge" alt="Status" />
  <img src="https://img.shields.io/badge/Flutter-3-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Riverpod-1E88E5?style=for-the-badge" alt="Riverpod" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/license-MIT-1E6F5C?style=for-the-badge" alt="License" />
</p>

</div>

---

## 📖 Overview

The **Gerai Jasa Mobile App** is the customer-facing Flutter app for the platform. It covers the full journey: onboarding, OTP login, discovering vendors, booking a slot, paying, and leaving a review — all in a polished, native-feeling experience.

---

## 🧱 Tech Stack

| Area | Technology |
|------|------------|
| **Core** | Flutter 3.x · Dart |
| **State** | Riverpod |
| **Navigation** | GoRouter (with auth guard) |
| **Network** | Dio (interceptors) |
| **Models** | Freezed + json_serializable |
| **Storage** | Flutter Secure Storage |
| **Push** | Firebase Cloud Messaging |
| **UI** | Cached Network Image · Shimmer · Lottie · Google Fonts (Plus Jakarta Sans) |

---

## ✨ Features

### 🔐 Auth Flow
- 🚀 **Splash** — animated logo, token check, auto-redirect
- 📖 **Onboarding** — 3 slides with Lottie animations
- 📲 **Phone OTP Login** — phone input → 6-digit OTP verification
- 👤 **Profile Setup** — name & email after first login

### 🧭 Main Flow (Bottom Navigation)
- 🏠 **Home** — search bar, category chips, featured & nearby vendors
- 🔍 **Search** — debounced search, filter bottom sheet, infinite scroll
- 📋 **My Bookings** — tabs (upcoming / history) with status badges
- 👤 **Profile** — user info, settings, logout

### 🛒 Booking Flow
- 🏪 **Vendor Detail** — parallax hero image, services, reviews, "Book Now"
- 📅 **Booking Steps** — select service → date → time slot → confirmation
- 💳 **Payment** — Midtrans Snap WebView, Xendit, or COD
- ✅ **Booking Success** — Lottie animation + booking code
- 📖 **Booking Detail** — full info, status timeline, cancel/review actions
- ⭐ **Review** — star rating + comment

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | Indigo `#6366F1` |
| Accent | Coral `#F97316` |
| Background | `#F8F7FF` (lavender-white) |
| Text | `#1E1B4B` (dark indigo) |
| Font | Plus Jakarta Sans |
| Radius | 16px cards · 12px buttons · 24px sheets |

---

## 🗂️ Project Structure

```
lib/
├── core/
│   ├── api/         # Dio client, interceptors
│   ├── constants/   # App constants (base URL, keys)
│   ├── router/      # GoRouter config with auth guard
│   ├── theme/       # Theme, colors, text styles
│   └── utils/       # Helpers, formatters
├── features/
│   ├── auth/        # Splash, onboarding, OTP login, profile setup
│   ├── home/        # Home, categories, featured vendors
│   ├── search/      # Search, filters, results
│   ├── booking/     # Booking flow, vendor detail, calendar
│   ├── payment/     # Payment selection, Midtrans WebView
│   └── profile/     # Profile, settings
└── shared/
    ├── widgets/     # Reusable widgets (shimmer, empty state, etc.)
    └── models/      # Shared data models
```

---

## 🚀 Getting Started

```bash
# Clone
git clone https://github.com/Naufall18/Gerai-Jasa-mobile.git
cd Gerai-Jasa-mobile

# Install dependencies
flutter pub get

# Generate freezed / json_serializable models
dart run build_runner build --delete-conflicting-outputs

# Update API base URL in lib/core/constants/app_constants.dart

# Run on a device/emulator
flutter run

# Release builds
flutter build apk --release
flutter build ios --release
```

> Firebase setup (FCM) is documented in [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md).

### Configuration

```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String midtransClientKey = '';
  static const String appName = 'Gerai Jasa';
  static const int otpLength = 6;
  static const int otpTimeout = 60; // seconds
  static const int slotCacheSeconds = 60;
}
```

---

## 🧩 Part of the Gerai Jasa Platform

| Repository | Stack | Role |
|------------|-------|------|
| [Gerai-Jasa-backend](https://github.com/Naufall18/Gerai-Jasa-backend) | Laravel 11 | REST API & booking engine |
| [Gerai-Jasa-web](https://github.com/Naufall18/Gerai-Jasa-web) | React + TypeScript | Admin & vendor dashboard |
| **Gerai-Jasa-mobile** *(this repo)* | Flutter | Customer app |

---

## 📄 License

Released under the **MIT License**.

<div align="center">
<br/>
Built by <a href="https://github.com/Naufall18">Naufal Dwi Arifianto</a> · <a href="https://naufall18.github.io/portofolio/">Portfolio</a>
</div>
