import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../models/models.dart';

class BookingsState {
  final List<Booking> bookings;
  final bool isLoading;
  final String? error;

  BookingsState({
    required this.bookings,
    this.isLoading = false,
    this.error,
  });

  BookingsState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return BookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BookingsNotifier extends StateNotifier<BookingsState> {
  final ApiClient _apiClient;

  BookingsNotifier(this._apiClient) : super(BookingsState(bookings: [])) {
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _apiClient.get('/bookings');
      final list = response.data['data'] as List;
      final bookingsList = list.map((json) => Booking.fromJson(json)).toList();
      state = BookingsState(bookings: bookingsList, isLoading: false);
    } catch (e) {
      state = BookingsState(
        bookings: [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Booking?> createBooking({
    required String vendorId,
    required String serviceId,
    required String timeSlotId,
    required String paymentMethod,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _apiClient.post('/bookings', data: {
        'vendor_id': vendorId,
        'service_id': serviceId,
        'time_slot_id': timeSlotId,
        'payment_method': paymentMethod,
        'notes': notes,
      });
      final booking = Booking.fromJson(response.data['data']);
      await fetchBookings();
      return booking;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId, String reason) async {
    state = state.copyWith(isLoading: true);
    try {
      await _apiClient.patch('/bookings/$bookingId/cancel', data: {
        'cancellation_reason': reason,
      });
      await fetchBookings();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final bookingsProvider = StateNotifierProvider<BookingsNotifier, BookingsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookingsNotifier(apiClient);
});

final bookingDetailProvider = FutureProvider.family<Booking, String>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/bookings/$id');
  return Booking.fromJson(response.data['data']);
});