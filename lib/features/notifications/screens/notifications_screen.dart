import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/gj_widgets.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  ({Color color, Color soft, IconData icon}) _style(String type) {
    switch (type) {
      case 'booking_confirmed':
        return (color: GJColors.success, soft: GJColors.successSoft, icon: Icons.check_circle_rounded);
      case 'booking_cancelled':
        return (color: GJColors.danger, soft: GJColors.dangerSoft, icon: Icons.cancel_rounded);
      case 'booking_reminder':
        return (color: GJColors.warning, soft: GJColors.warningSoft, icon: Icons.alarm_rounded);
      default:
        return (color: GJColors.primary, soft: GJColors.primarySoft, icon: Icons.notifications_rounded);
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'Baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} mnt lalu';
    if (d.inHours < 24) return '${d.inHours} jam lalu';
    if (d.inDays < 7) return '${d.inDays} hari lalu';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    return Scaffold(
      backgroundColor: GJColors.surface,
      appBar: AppBar(
        title: const Text('Notifikasi',
            style: TextStyle(color: GJColors.ink, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: GJColors.ink),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: notifier.markAllRead,
              child: const Text('Tandai semua',
                  style: TextStyle(color: GJColors.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: GJColors.primary,
        onRefresh: notifier.fetch,
        child: _body(context, state, notifier),
      ),
    );
  }

  Widget _body(BuildContext context, NotificationsState state,
      NotificationsNotifier notifier) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: GJColors.primary));
    }
    if (state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          GJEmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'Belum ada notifikasi',
            subtitle: 'Update booking & pengingat akan muncul di sini.',
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(GJSpacing.lg),
      itemCount: state.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: GJSpacing.md),
      itemBuilder: (context, index) {
        final n = state.items[index];
        final s = _style(n.type);
        return InkWell(
          borderRadius: BorderRadius.circular(GJRadius.lg),
          onTap: () {
            if (!n.isRead) notifier.markRead(n.id);
            if (n.bookingId != null) {
              context.push('/booking-detail/${n.bookingId}');
            }
          },
          child: Container(
            padding: const EdgeInsets.all(GJSpacing.md),
            decoration: BoxDecoration(
              color: n.isRead ? Colors.white : s.soft,
              borderRadius: BorderRadius.circular(GJRadius.lg),
              border: Border.all(
                color: n.isRead ? GJColors.border : s.color.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: s.soft, shape: BoxShape.circle),
                  child: Icon(s.icon, color: s.color, size: 22),
                ),
                const SizedBox(width: GJSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: TextStyle(
                                fontWeight: n.isRead ? FontWeight.w600 : FontWeight.bold,
                                color: GJColors.ink,
                                fontSize: 14.5,
                              ),
                            ),
                          ),
                          if (!n.isRead)
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                  color: s.color, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(n.body,
                          style: const TextStyle(
                              color: GJColors.textSoft, fontSize: 13, height: 1.35)),
                      const SizedBox(height: 6),
                      Text(_timeAgo(n.createdAt),
                          style: const TextStyle(
                              color: GJColors.textSoft, fontSize: 11.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
