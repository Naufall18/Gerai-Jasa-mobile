import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String bookingCode;
  final String vendorName;
  final String serviceName;
  final String date;
  final String time;

  const BookingSuccessScreen({
    super.key,
    required this.bookingCode,
    required this.vendorName,
    required this.serviceName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E8B57),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Berhasil!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14241F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Booking Anda telah dikonfirmasi dan sedang diproses.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Kode Booking', bookingCode, isCode: true),
                    const Divider(height: 24),
                    _buildDetailRow('Vendor', vendorName),
                    const Divider(height: 24),
                    _buildDetailRow('Layanan', serviceName),
                    const Divider(height: 24),
                    _buildDetailRow('Tanggal', date),
                    const Divider(height: 24),
                    _buildDetailRow('Waktu', time),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => context.go('/bookings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F5C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lihat Daftar Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E6F5C),
                    side: const BorderSide(color: Color(0xFF1E6F5C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isCode = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: isCode ? const Color(0xFF1E6F5C) : const Color(0xFF14241F),
            fontWeight: FontWeight.bold,
            fontSize: isCode ? 16 : 14,
            fontFamily: isCode ? 'monospace' : null,
          ),
        ),
      ],
    );
  }
}