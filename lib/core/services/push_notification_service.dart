import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import '../../firebase_options.dart';
import '../api/api_client.dart';
import '../widgets/gj_toast.dart';

/// Global key so push handlers can surface a SnackBar from anywhere.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Global navigator key shared with GoRouter so push handlers can navigate
/// (deep link) without a BuildContext.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>();

/// Background/terminated message handler. Must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Keep minimal — heavy work here can be killed by the OS.
  debugPrint('FCM background message: ${message.messageId}');
}

/// Thin wrapper around Firebase Messaging.
///
/// NOTE: Until `flutterfire configure` has generated `firebase_options.dart`
/// and `google-services.json` is in place, [init] will fail to initialize
/// Firebase — this is caught and logged so the app keeps running. Once those
/// files exist, FCM starts working without further code changes.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  bool _ready = false;
  bool get isReady => _ready;

  /// Initialize Firebase + messaging. Safe to call before login.
  Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

      // Foreground messages → animated top toast
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          GJToast.show(
            notification.body ?? '',
            title: notification.title ?? 'Notifikasi',
            type: GJToastType.info,
            duration: const Duration(seconds: 4),
          );
        }
      });

      // Tapped notification while app is in background → deep link.
      FirebaseMessaging.onMessageOpenedApp.listen(_handleDeepLink);

      // App launched from terminated state by tapping a notification.
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        // Defer until the first frame so the navigator is mounted.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _handleDeepLink(initialMessage),
        );
      }

      _ready = true;
    } catch (e) {
      // Firebase not configured yet (no firebase_options.dart / google-services.json).
      debugPrint('PushNotificationService.init skipped: $e');
      _ready = false;
    }
  }

  /// Fetch the current device token, or null if FCM isn't ready.
  Future<String?> getToken() async {
    if (!_ready) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('getToken failed: $e');
      return null;
    }
  }

  /// Send the device's FCM token to the backend. Call after a successful login.
  Future<void> registerToken(ApiClient apiClient) async {
    final token = await getToken();
    if (token == null) return;
    try {
      await apiClient.post('/auth/fcm-token', data: {'fcm_token': token});
    } catch (e) {
      debugPrint('registerToken failed: $e');
    }
  }

  /// Navigate based on a notification payload. Backend sends a `data` map;
  /// when it carries a `booking_id`, open the matching booking detail.
  void _handleDeepLink(RemoteMessage message) {
    final data = message.data;
    final bookingId = data['booking_id'] ?? data['bookingId'];
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    if (bookingId != null && bookingId.toString().isNotEmpty) {
      context.push('/booking-detail/$bookingId');
    }
  }
}
