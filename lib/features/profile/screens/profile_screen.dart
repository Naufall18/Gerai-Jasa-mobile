import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Color(0xff1e1b4b), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // User Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xff6366f1).withOpacity(0.1),
                      child: Text(
                        (user?.name.isNotEmpty == true) ? user!.name[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff6366f1)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Pengguna',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'email@example.com',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phone ?? '-',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Settings
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profil',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur edit profil segera hadir.')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Pengaturan Notifikasi',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur pengaturan notifikasi segera hadir.')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Bantuan & FAQ',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur Bantuan segera hadir.')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Kebijakan Privasi',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur Kebijakan Privasi segera hadir.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text('Keluar Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff6366f1)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xff1e1b4b))),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}