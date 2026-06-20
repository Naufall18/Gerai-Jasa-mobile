import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/providers/booking_provider.dart';
import '../../../shared/models/models.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsState = ref.watch(bookingsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xfff8f7ff),
        appBar: AppBar(
          title: const Text(
            'Booking Saya',
            style: TextStyle(color: Color(0xff1e1b4b), fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color(0xff6366f1),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xff6366f1),
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Mendatang'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: bookingsState.isLoading && bookingsState.bookings.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Color(0xff6366f1)))
            : bookingsState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Gagal memuat booking: ${bookingsState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.read(bookingsProvider.notifier).fetchBookings(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6366f1),
                          ),
                          child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                : TabBarView(
                    children: [
                      _BookingList(
                        bookings: bookingsState.bookings
                            .where((b) =>
                                b.status == 'pending' ||
                                b.status == 'confirmed' ||
                                b.status == 'in_progress')
                            .toList(),
                        onRefresh: () => ref.read(bookingsProvider.notifier).fetchBookings(),
                      ),
                      _BookingList(
                        bookings: bookingsState.bookings
                            .where((b) => b.status == 'completed' || b.status == 'cancelled')
                            .toList(),
                        onRefresh: () => ref.read(bookingsProvider.notifier).fetchBookings(),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final RefreshCallback onRefresh;

  const _BookingList({
    required this.bookings,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_rounded, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  'Tidak ada booking',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Semua riwayat booking Anda akan muncul di sini.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final slotDateStr = booking.timeSlot?.slotDate ?? '';
          final bookingDate = DateTime.tryParse(slotDateStr) ?? DateTime.now();
          final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(bookingDate);
          final slotTimeStr = booking.timeSlot?.slotTime ?? '00:00:00';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: InkWell(
              onTap: () => context.push('/booking/${booking.id}'),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking.bookingCode,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        _buildStatusBadge(booking.status),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xfff4f3ff),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: Color(0xff6366f1)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.vendor?.name ?? 'Nama Vendor',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1e1b4b),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking.service?.name ?? 'Nama Layanan',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jadwal',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$formattedDate | ${slotTimeStr.substring(0, 5)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1e1b4b),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total Bayar',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currencyFormatter.format(booking.totalPrice),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfff97316),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.amber;
        text = 'Menunggu';
      case 'confirmed':
        color = Colors.blue;
        text = 'Dikonfirmasi';
      case 'in_progress':
        color = const Color(0xff6366f1);
        text = 'Sedang Berjalan';
      case 'completed':
        color = Colors.green;
        text = 'Selesai';
      case 'cancelled':
        color = Colors.red;
        text = 'Dibatalkan';
      default:
        color = Colors.grey;
        text = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}