import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/providers/booking_provider.dart';
import '../../../shared/providers/vendor_provider.dart';
import '../../../core/widgets/gj_toast.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String vendorId;
  final String serviceId;

  const BookingScreen({
    super.key,
    required this.vendorId,
    required this.serviceId,
  });

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedSlotId;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();
  String _paymentMethod = 'cod';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _paymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1E6F5C) : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xFF1E6F5C),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Color(0xFF14241F))),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitBooking() async {
    if (_selectedSlotId == null) {
      GJToast.warning('Silakan pilih slot waktu terlebih dahulu.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await ref.read(bookingsProvider.notifier).createBooking(
            vendorId: widget.vendorId,
            serviceId: widget.serviceId,
            timeSlotId: _selectedSlotId!,
            paymentMethod: _paymentMethod,
            notes: _notesController.text,
            specialRequests: _specialRequestsController.text,
          );

      if (success != null && mounted) {
        if (_paymentMethod == 'midtrans') {
          context.go('/payment', extra: {
            'bookingId': success.id,
            'totalPrice': success.totalPrice,
            'vendorName': success.vendor?.name ?? 'Vendor',
          });
        } else {
          context.go('/success', extra: {
            'bookingCode': success.bookingCode,
            'vendorName': success.vendor?.name ?? 'Vendor',
            'serviceName': success.service?.name ?? 'Layanan',
            'date': success.timeSlot?.slotDate ?? '',
            'time': success.timeSlot?.slotTime ?? '',
          });
        }
      } else {
        if (mounted) {
          GJToast.error('Gagal membuat booking. Silakan coba lagi.');
        }
      }
    } catch (e) {
      if (mounted) {
        GJToast.error('Terjadi kesalahan. Silakan coba lagi.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final slotsAsync = ref.watch(availableSlotsProvider((
      vendorId: widget.vendorId,
      serviceId: widget.serviceId,
      date: dateStr,
    )));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF7),
      appBar: AppBar(
        title: const Text('Buat Booking', style: TextStyle(color: Color(0xFF14241F), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF14241F)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Select Date
              const Text(
                'Pilih Tanggal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _selectedSlotId = null;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
                      ),
                      const Icon(Icons.calendar_today_rounded, color: Color(0xFF1E6F5C)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Select Time Slots
              const Text(
                'Pilih Jam Layanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
              ),
              const SizedBox(height: 10),
              slotsAsync.when(
                data: (slots) {
                  if (slots.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text('Tidak ada slot waktu yang tersedia untuk tanggal ini.', style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: slots.map((slot) {
                      final isSelected = _selectedSlotId == slot.id;
                      return ChoiceChip(
                        label: Text(slot.slotTime),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSlotId = slot.id;
                            } else {
                              _selectedSlotId = null;
                            }
                          });
                        },
                        selectedColor: const Color(0xFF1E6F5C),
                        labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF14241F)),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1E6F5C))),
                error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 24),

              // 3. Notes / Special Request
              const Text(
                'Catatan Tambahan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Tulis catatan untuk vendor di sini...',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Permintaan Khusus',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _specialRequestsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Tulis permintaan khusus jika ada...',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Payment Method
              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildPaymentOption(
                      value: 'cod',
                      title: 'COD (Bayar di Tempat)',
                      subtitle: 'Bayar langsung ke vendor setelah layanan selesai',
                    ),
                    const Divider(height: 1),
                    _buildPaymentOption(
                      value: 'midtrans',
                      title: 'Midtrans',
                      subtitle: 'Bayar via Transfer Bank, GoPay, atau E-Wallet lainnya',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F5C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Konfirmasi Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}