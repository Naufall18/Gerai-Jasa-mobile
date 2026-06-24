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
import '../services/push_notification_service.dart';
import '../widgets/gj_bottom_nav.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/phone-input' ||
          state.matchedLocation == '/otp-verify' ||
          state.matchedLocation == '/profile-setup' ||
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/';

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
    ],
  );
});