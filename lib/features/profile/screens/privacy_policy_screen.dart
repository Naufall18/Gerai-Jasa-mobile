import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    (
      icon: Icons.info_outline_rounded,
      title: 'Informasi yang Kami Kumpulkan',
      body: 'Kami mengumpulkan data yang kamu berikan saat mendaftar dan menggunakan layanan, seperti nama, nomor telepon, email, foto profil, serta riwayat booking dan transaksimu.'
    ),
    (
      icon: Icons.tune_rounded,
      title: 'Bagaimana Data Digunakan',
      body: 'Data digunakan untuk memproses booking, mengirim notifikasi (push & WhatsApp), menampilkan riwayat, serta meningkatkan kualitas layanan Gerai Jasa.'
    ),
    (
      icon: Icons.share_rounded,
      title: 'Berbagi Data',
      body: 'Data booking yang relevan (nama, jadwal, layanan) dibagikan kepada vendor terkait agar mereka dapat melayani pesananmu. Kami tidak menjual data pribadimu ke pihak ketiga.'
    ),
    (
      icon: Icons.lock_outline_rounded,
      title: 'Keamanan',
      body: 'Kata sandi/token disimpan terenkripsi, dan komunikasi dengan server menggunakan koneksi aman. Pembayaran online diproses oleh gateway tepercaya (Midtrans/Xendit).'
    ),
    (
      icon: Icons.verified_user_rounded,
      title: 'Hak Kamu',
      body: 'Kamu dapat memperbarui profil kapan saja, mengatur preferensi notifikasi, dan meminta penghapusan akun dengan menghubungi tim dukungan kami.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GJColors.surface,
      appBar: AppBar(
        title: const Text('Kebijakan Privasi',
            style: TextStyle(color: GJColors.ink, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: GJColors.ink),
      ),
      body: ListView(
        padding: const EdgeInsets.all(GJSpacing.lg),
        children: [
          Text('Terakhir diperbarui: Juni 2026',
              style: TextStyle(color: GJColors.textSoft, fontSize: 12.5)),
          const SizedBox(height: GJSpacing.md),
          const Text(
            'Privasimu penting bagi kami. Kebijakan ini menjelaskan bagaimana Gerai Jasa mengelola dan melindungi data kamu.',
            style: TextStyle(color: GJColors.ink, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: GJSpacing.xl),
          for (final s in _sections) ...[
            Container(
              margin: const EdgeInsets.only(bottom: GJSpacing.md),
              padding: const EdgeInsets.all(GJSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(GJRadius.lg),
                border: Border.all(color: GJColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        color: GJColors.primarySoft,
                        borderRadius: BorderRadius.circular(GJRadius.md)),
                    child: Icon(s.icon, color: GJColors.primary, size: 20),
                  ),
                  const SizedBox(width: GJSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: GJColors.ink,
                                fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(s.body,
                            style: const TextStyle(
                                color: GJColors.textSoft, fontSize: 13.5, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: GJSpacing.sm),
          Center(
            child: Text('© 2026 Gerai Jasa',
                style: TextStyle(color: GJColors.textSoft, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
