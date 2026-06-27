import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/phone_input_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/profile_setup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/booking/screens/vendor_detail_screen.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/payment/screens/payment_screen.dart';
import '../../features/payment/screens/booking_success_screen.dart';
import '../../features/booking/screens/bookings_screen.dart';
import '../../features/booking/screens/booking_detail_screen.dart';
import '../../features/booking/screens/review_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/notification_settings_screen.dart';
import '../../features/profile/screens/help_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../services/push_notification_service.dart';
import '../widgets/gj_bottom_nav.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Bridges Riverpod auth state into a [Listenable] so GoRouter can re-run its
/// redirect logic WITHOUT being rebuilt.
///
/// Previously the router did `ref.watch(authProvider)`, so every auth state
/// change (including the brief `isLoading` toggle while requesting an OTP) built
/// a brand-new GoRouter. A fresh router resets navigation to `initialLocation`
/// ('/'), which bounced the user back to the splash screen mid-flow. Building
/// the router once and refreshing via this listenable fixes that.
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated ||
          previous?.isLoading != next.isLoading) {
        notifyListeners();
      }
    });
  }
}

final _authRouterNotifierProvider = Provider<_AuthRouterNotifier>((ref) {
  final notifier = _AuthRouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  // Watch the (stable, created-once) notifier — NOT authProvider directly —
  // so the GoRouter instance is built a single time for the app's lifetime.
  final refreshListenable = ref.watch(_authRouterNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuth = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/phone-input' ||
          state.matchedLocation == '/otp-verify' ||
          state.matchedLocation == '/profile-setup' ||
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/';

      // While auth status is resolving, don't redirect (splash stays).
      if (authState.isLoading) return null;

      if (!isAuth) {
        if (!isLoggingIn) return '/phone-input';
        return null;
      }

      if (isAuth && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/phone-input',
        builder: (context, state) => const PhoneInputScreen(),
      ),
      GoRoute(
        path: '/otp-verify',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      // ── Tab utama dengan bottom-nav persisten ──
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            GJScaffoldWithNav(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
          GoRoute(path: '/bookings', builder: (context, state) => const BookingsScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/vendor/:id',
        builder: (context, state) => VendorDetailScreen(
          slug: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/booking/:vendorId/:serviceId',
        builder: (context, state) => BookingScreen(
          vendorId: state.pathParameters['vendorId']!,
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            bookingId: extra['bookingId'],
            totalPrice: extra['totalPrice'],
            vendorName: extra['vendorName'],
          );
        },
      ),
      GoRoute(
        path: '/success',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BookingSuccessScreen(
            bookingCode: extra['bookingCode'],
            vendorName: extra['vendorName'],
            serviceName: extra['serviceName'],
            date: extra['date'],
            time: extra['time'],
          );
        },
      ),
      GoRoute(
        path: '/booking-detail/:id',
        builder: (context, state) => BookingDetailScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/review/:id',
        builder: (context, state) => ReviewScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );
});
