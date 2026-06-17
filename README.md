# Bookly Mobile App

Flutter 3.x customer app for **Bookly** — a multi-vendor booking platform (salons, clinics, workshops, etc.) for the Indonesian market.

## Tech Stack

- **Flutter 3.x** (Dart)
- **Riverpod** (state management)
- **GoRouter** (navigation with auth guard)
- **Dio** (HTTP client with interceptors)
- **Freezed** + **json_serializable** (immutable models)
- **Flutter Secure Storage** (token storage)
- **Firebase Messaging** (push notifications)
- **Cached Network Image** (image caching)
- **Shimmer** (loading skeletons)
- **Lottie** (animations)
- **Google Fonts** (Plus Jakarta Sans)

## Features

### Auth Flow
- 🚀 **Splash Screen** — Animated logo, token check, auto-redirect
- 📱 **Onboarding** — 3 slides with Lottie animations
- 📲 **Phone OTP Login** — Phone input → 6-digit OTP verification
- 👤 **Profile Setup** — Name & email after first login

### Main Flow (Bottom Navigation)
- 🏠 **Home** — Search bar, category chips, featured vendors, nearby vendors
- 🔍 **Search** — Debounced search, filter bottom sheet, infinite scroll results
- 📋 **My Bookings** — Tabs (upcoming/history), booking cards with status badges
- 👤 **Profile** — User info, settings, logout

### Booking Flow
- 🏪 **Vendor Detail** — Hero image parallax, services, reviews, "Book Now" button
- 📅 **Booking Steps** — Select service → date → time slot → confirmation
- 💳 **Payment** — Midtrans Snap WebView, Xendit, or COD
- ✅ **Booking Success** — Lottie animation, booking code display

### Other Screens
- 📖 **Booking Detail** — Full info, status timeline, cancel/review actions
- ⭐ **Review** — Star rating + comment input

## Design System

- **Primary**: Indigo `#6366F1`
- **Accent**: Coral `#F97316`
- **Background**: `#F8F7FF` (light lavender-white)
- **Text**: `#1E1B4B` (dark indigo)
- **Font**: Plus Jakarta Sans
- **Corner radius**: 16px cards, 12px buttons, 24px bottom sheets

## Folder Structure

```
lib/
├── core/
│   ├── api/           # Dio client, interceptors
│   ├── constants/     # App constants (base URL, keys)
│   ├── router/        # GoRouter config with auth guard
│   ├── theme/         # App theme, colors, text styles
│   └── utils/         # Helpers, formatters
├── features/
│   ├── auth/          # Splash, onboarding, OTP login, profile setup
│   ├── home/          # Home screen, categories, featured vendors
│   ├── search/        # Search, filters, results
│   ├── booking/       # Booking flow, vendor detail, calendar
│   ├── payment/       # Payment selection, Midtrans WebView
│   └── profile/       # Profile, settings
└── shared/
    ├── widgets/       # Reusable widgets (shimmer, empty state, etc.)
    └── models/        # Shared data models
```

## Setup

```bash
# Clone
git clone https://github.com/Naufall18/bookly-mobile.git
cd bookly-mobile

# Install dependencies
flutter pub get

# Generate freezed/json_serializable models
dart run build_runner build --delete-conflicting-outputs

# Update API base URL
# Edit lib/core/constants/app_constants.dart

# Run on device/emulator
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## Configuration

```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String midtransClientKey = '';
  static const String appName = 'Bookly';
  static const int otpLength = 6;
  static const int otpTimeout = 60; // seconds
  static const int slotCacheSeconds = 60;
}
```

## Related Repositories

- **Backend API**: [bookly-backend](https://github.com/Naufall18/bookly-backend) — Laravel 11 REST API
- **Web Dashboard**: [bookly-web](https://github.com/Naufall18/bookly-web) — React 18 + TypeScript (Admin & Vendor Dashboard)

## License

MIT