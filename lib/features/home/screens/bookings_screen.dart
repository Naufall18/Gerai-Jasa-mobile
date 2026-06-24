import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/booking_provider.dart';
import '../../../shared/models/models.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFAF7),
        appBar: AppBar(
          title: const Text('Booking Saya', style: TextStyle(color: Color(0xFF14241F), fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color(0xFF1E6F5C),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1E6F5C),
            tabs: [
              Tab(text: 'Mendatang'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.read(bookingsProvider.notifier).fetchBookings(),
          child: state.isLoading && state.bookings.isEmpty
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E6F5C)))
              : TabBarView(
                  children: [
                    _BookingsList(
                      bookings: state.bookings.where((b) =>
                          b.status == 'pending' ||
                          b.status == 'confirmed' ||
                          b.status == 'in_progress' ||
                          b.status == 'awaiting_payment').toList(),
                      emptyMessage: 'Tidak ada booking mendatang.',
                    ),
                    _BookingsList(
                      bookings: state.bookings.where((b) =>
                          b.status == 'completed' ||
                          b.status == 'cancelled').toList(),
                      emptyMessage: 'Tidak ada riwayat booking.',
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<Booking> bookings;
  final String emptyMessage;

  const _BookingsList({required this.bookings, required this.emptyMessage});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber.shade700;
      case 'confirmed':
        return Colors.blue.shade700;
      case 'in_progress':
        return Colors.indigo.shade700;
      case 'completed':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'in_progress':
        return 'Sedang Berjalan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(emptyMessage, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          child: InkWell(
            onTap: () => context.push('/bookings/${booking.id}'),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      booking.vendor?.photos.isNotEmpty == true
                          ? booking.vendor!.photos.first.url
                          : 'https://picsum.photos/100/100',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        width: 70,
                        height: 70,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.vendor?.name ?? 'Vendor',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14241F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.service?.name ?? 'Layanan',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${booking.timeSlot?.slotDate ?? ""} | ${booking.timeSlot?.slotTime ?? ""}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14241F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusLabel(booking.status),
                          style: TextStyle(
                            color: _getStatusColor(booking.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${booking.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E6F5C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}