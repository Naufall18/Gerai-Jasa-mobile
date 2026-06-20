import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  final double totalPrice;
  final String vendorName;

  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.totalPrice,
    required this.vendorName,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isPaying = false;

  void _simulatePaymentSuccess() {
    setState(() {
      _isPaying = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/success', extra: {
          'bookingCode': 'BKL-${widget.bookingId.substring(0, 8).toUpperCase()}',
          'vendorName': widget.vendorName,
          'serviceName': 'Layanan Pilihan',
          'date': 'Besok',
          'time': '10:00',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Color(0xff1e1b4b), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff1e1b4b)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.payment_rounded, size: 64, color: Color(0xff6366f1)),
                    const SizedBox(height: 16),
                    Text(
                      widget.vendorName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text('Total Pembayaran', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${widget.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xfff97316)),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Simulasi Pembayaran Midtrans Snap',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1e1b4b)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tekan tombol di bawah untuk menyimulasikan transaksi sukses menggunakan Midtrans.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isPaying ? null : _simulatePaymentSuccess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6366f1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isPaying
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Bayar Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}