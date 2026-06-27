import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _push = true;
  bool _whatsapp = true;
  bool _bookingUpdates = true;
  bool _reminders = true;
  bool _promos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GJColors.surface,
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi',
            style: TextStyle(color: GJColors.ink, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: GJColors.ink),
      ),
      body: ListView(
        padding: const EdgeInsets.all(GJSpacing.lg),
        children: [
          _section('Saluran', [
            _tile(
              icon: Icons.notifications_active_rounded,
              title: 'Notifikasi Push',
              subtitle: 'Terima notifikasi langsung di perangkat ini.',
              value: _push,
              onChanged: (v) => setState(() => _push = v),
            ),
            _tile(
              icon: Icons.chat_rounded,
              title: 'WhatsApp',
              subtitle: 'Update penting juga dikirim via WhatsApp.',
              value: _whatsapp,
              onChanged: (v) => setState(() => _whatsapp = v),
            ),
          ]),
          const SizedBox(height: GJSpacing.lg),
          _section('Jenis', [
            _tile(
              icon: Icons.event_available_rounded,
              title: 'Update Booking',
              subtitle: 'Konfirmasi, selesai, atau pembatalan booking.',
              value: _bookingUpdates,
              onChanged: (v) => setState(() => _bookingUpdates = v),
            ),
            _tile(
              icon: Icons.alarm_rounded,
              title: 'Pengingat Jadwal',
              subtitle: 'Pengingat H-1 dan 1 jam sebelum jadwal.',
              value: _reminders,
              onChanged: (v) => setState(() => _reminders = v),
            ),
            _tile(
              icon: Icons.local_offer_rounded,
              title: 'Promo & Penawaran',
              subtitle: 'Diskon dan info menarik dari vendor.',
              value: _promos,
              onChanged: (v) => setState(() => _promos = v),
            ),
          ]),
          const SizedBox(height: GJSpacing.lg),
          Container(
            padding: const EdgeInsets.all(GJSpacing.md),
            decoration: BoxDecoration(
              color: GJColors.primarySoft,
              borderRadius: BorderRadius.circular(GJRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: GJColors.primary, size: 20),
                const SizedBox(width: GJSpacing.sm),
                Expanded(
                  child: Text(
                    'Pengaturan disimpan di perangkat ini. Notifikasi penting terkait keamanan akun tetap dikirim.',
                    style: TextStyle(
                        color: GJColors.primary.withValues(alpha: 0.9),
                        fontSize: 12.5,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: GJSpacing.sm),
          child: Text(title.toUpperCase(),
              style: const TextStyle(
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
          child: Column(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 60),
                tiles[i],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GJSpacing.md, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: GJColors.primarySoft,
              borderRadius: BorderRadius.circular(GJRadius.md),
            ),
            child: Icon(icon, color: GJColors.primary, size: 20),
          ),
          const SizedBox(width: GJSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: GJColors.ink, fontSize: 14.5)),
                const SizedBox(height: 1),
                Text(subtitle,
                    style: const TextStyle(color: GJColors.textSoft, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: GJColors.primary,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
