import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/design_tokens.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      q: 'Bagaimana cara memesan layanan?',
      a: 'Pilih vendor, pilih layanan & jadwal yang tersedia, isi catatan bila perlu, lalu pilih metode pembayaran (COD atau online). Booking langsung tercatat di tab Booking.'
    ),
    (
      q: 'Apa itu pembayaran COD?',
      a: 'COD (Cash on Delivery) berarti kamu membayar langsung ke vendor setelah layanan selesai. Tidak perlu bayar di muka.'
    ),
    (
      q: 'Bagaimana cara membatalkan booking?',
      a: 'Buka tab Booking, pilih booking yang berstatus Menunggu atau Dikonfirmasi, lalu tekan Batalkan. Slot waktu akan otomatis dilepas.'
    ),
    (
      q: 'Saya tidak menerima kode OTP?',
      a: 'Pastikan nomor WhatsApp aktif dan benar. Tunggu hingga 60 detik lalu tekan Kirim Ulang. Cek juga koneksi internet kamu.'
    ),
    (
      q: 'Bagaimana cara memberi ulasan?',
      a: 'Setelah booking berstatus Selesai, buka detail booking dan tekan Beri Ulasan untuk memberi rating dan komentar ke vendor.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GJColors.surface,
      appBar: AppBar(
        title: const Text('Bantuan & FAQ',
            style: TextStyle(color: GJColors.ink, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: GJColors.ink),
      ),
      body: ListView(
        padding: const EdgeInsets.all(GJSpacing.lg),
        children: [
          // Hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(GJSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [GJColors.primary, GJColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(GJRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.support_agent_rounded, color: Colors.white, size: 34),
                const SizedBox(height: GJSpacing.sm),
                const Text('Ada yang bisa kami bantu?',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Temukan jawaban cepat di bawah, atau hubungi tim kami.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: GJSpacing.xl),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: GJSpacing.sm),
            child: Text('PERTANYAAN UMUM',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: GJColors.textSoft)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(GJRadius.lg),
              border: Border.all(color: GJColors.border),
            ),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  for (var i = 0; i < _faqs.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    ExpansionTile(
                      iconColor: GJColors.primary,
                      collapsedIconColor: GJColors.textSoft,
                      title: Text(_faqs[i].q,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: GJColors.ink,
                              fontSize: 14)),
                      childrenPadding: const EdgeInsets.fromLTRB(
                          GJSpacing.lg, 0, GJSpacing.lg, GJSpacing.lg),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_faqs[i].a,
                              style: const TextStyle(
                                  color: GJColors.textSoft, fontSize: 13.5, height: 1.5)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: GJSpacing.xl),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: GJSpacing.sm),
            child: Text('HUBUNGI KAMI',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: GJColors.textSoft)),
          ),
          _contactTile(Icons.chat_rounded, 'WhatsApp', '+62 822-4408-9648',
              () => launchUrl(Uri.parse('https://wa.me/6282244089648'))),
          const SizedBox(height: GJSpacing.sm),
          _contactTile(Icons.email_rounded, 'Email', 'naufan970@gmail.com',
              () => launchUrl(Uri.parse('mailto:naufan970@gmail.com'))),
        ],
      ),
    );
  }

  Widget _contactTile(IconData icon, String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(GJRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(GJSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(GJRadius.lg),
          border: Border.all(color: GJColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: GJColors.primarySoft, borderRadius: BorderRadius.circular(GJRadius.md)),
              child: Icon(icon, color: GJColors.primary, size: 20),
            ),
            const SizedBox(width: GJSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: GJColors.ink, fontSize: 14)),
                  Text(value, style: const TextStyle(color: GJColors.textSoft, fontSize: 12.5)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: GJColors.textSoft),
          ],
        ),
      ),
    );
  }
}
