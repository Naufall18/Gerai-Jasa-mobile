import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize push notifications. No-ops gracefully until Firebase is configured.
  await PushNotificationService.instance.init();

  runApp(
    const ProviderScope(
      child: GeraiJasaApp(),
    ),
  );
}

class GeraiJasaApp extends ConsumerWidget {
  const GeraiJasaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Gerai Jasa',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
