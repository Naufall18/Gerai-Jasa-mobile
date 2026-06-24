import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_client.dart';
import 'payment_webview_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
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
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isPaying = false;

  Future<void> _startPayment() async {
    setState(() => _isPaying = true);
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.post('/bookings/${widget.bookingId}/pay');
      final data = res.data['data'] as Map<String, dynamic>?;
      final redirectUrl = data?['redirect_url'] as String?;

      if (redirectUrl == null || redirectUrl.isEmpty) {
        throw Exception('URL pembayaran tidak tersedia.');
      }

      if (!mounted) return;
      final status = await Navigator.of(context).push<String?>(
        MaterialPageRoute(
          builder: (_) => PaymentWebViewScreen(redirectUrl: redirectUrl),
        ),
      );

      if (!mounted) return;
      _handlePaymentResult(status);
    } on DioException catch (e) {
      final msg = (e.response?.data is Map ? e.response?.data['message'] : null) ??
          'Gagal memulai pembayaran. Periksa konfigurasi Midtrans.';
      _showSnack(msg.toString(), isError: true);
    } catch (e) {
      _showSnack('Gagal memulai pembayaran: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  void _handlePaymentResult(String? status) {
    switch (status) {
      case 'settlement':
      case 'capture':
        context.go('/success', extra: {
          'bookingCode': 'BKL-${widget.bookingId.substring(0, 8).toUpperCase()}',
          'vendorName': widget.vendorName,
          'serviceName': 'Layanan Pilihan',
          'date': '-',
          'time': '-',
        });
        break;
      case 'pending':
        _showSnack('Pembayaran tertunda. Selesaikan sebelum kedaluwarsa.');
        context.go('/bookings');
        break;
      case null:
        _showSnack('Pembayaran dibatalkan.');
        break;
      default:
        _showSnack('Pembayaran gagal ($status).', isError: true);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF7),
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Color(0xFF14241F), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF14241F)),
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
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.payment_rounded, size: 64, color: Color(0xFF1E6F5C)),
                    const SizedBox(height: 16),
                    Text(
                      widget.vendorName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text('Total Pembayaran', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${widget.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF2A444)),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Pembayaran via Midtrans',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF14241F)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Anda akan diarahkan ke halaman pembayaran aman Midtrans.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isPaying ? null : _startPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E6F5C),
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
