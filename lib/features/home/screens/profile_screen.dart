import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF7),
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Color(0xFF14241F), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Card
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF1E6F5C).withOpacity(0.1),
                    child: const Icon(Icons.person_rounded, size: 40, color: Color(0xFF1E6F5C)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Customer',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14241F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.phone ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  if (user?.email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      user!.email!,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Menu Options
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.notifications_rounded,
                    title: 'Notifikasi',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _ProfileMenuItem(
                    icon: Icons.payment_rounded,
                    title: 'Riwayat Pembayaran',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Bantuan & FAQ',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Kebijakan Privasi',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Keluar',
                    titleColor: Colors.red,
                    iconColor: Colors.red,
                    showTrailing: false,
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Keluar dari Akun?'),
                          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi Gerai Jasa?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Keluar'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          context.go('/phone');
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Gerai Jasa v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;
  final Color titleColor;
  final bool showTrailing;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = const Color(0xFF1E6F5C),
    this.titleColor = const Color(0xFF14241F),
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
      ),
      trailing: showTrailing ? const Icon(Icons.chevron_right_rounded, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}