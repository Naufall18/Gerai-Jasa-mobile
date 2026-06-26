import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String body;
  final String? bookingId;
  final bool isRead;
  final DateTime? createdAt;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.bookingId,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'].toString(),
      type: (json['type'] ?? '').toString(),
      title: (json['title'] ?? 'Notifikasi').toString(),
      body: (json['body'] ?? '').toString(),
      bookingId: json['booking_id']?.toString(),
      isRead: json['is_read'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

class NotificationsState {
  final List<NotificationItem> items;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.items = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationItem>? items,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final ApiClient _api;

  NotificationsNotifier(this._api) : super(const NotificationsState()) {
    fetch();
  }

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _api.get('/notifications');
      final list = (res.data['data'] as List)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList();
      final unread = (res.data['meta']?['unread_count'] ?? 0) as int;
      state = NotificationsState(items: list, unreadCount: unread, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _api.patch('/notifications/$id/read');
      await fetch();
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _api.patch('/notifications/read-all');
      await fetch();
    } catch (_) {}
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(ref.watch(apiClientProvider));
});
