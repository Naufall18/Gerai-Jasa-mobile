import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/gj_toast.dart';
import '../../auth/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );
    if (!mounted) return;
    if (ok) {
      GJToast.success('Profil berhasil diperbarui');
      context.pop();
    }
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: GJColors.primary),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: GJColors.textSoft),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GJRadius.lg),
          borderSide: const BorderSide(color: GJColors.border),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(GJRadius.lg)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GJRadius.lg),
          borderSide: const BorderSide(color: GJColors.primary, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final initial =
        (user?.name.isNotEmpty == true) ? user!.name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: GJColors.surface,
      appBar: AppBar(
        title: const Text('Edit Profil',
            style: TextStyle(color: GJColors.ink, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: GJColors.ink),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(GJSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar with initial (image upload coming later).
              Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: GJColors.primarySoft,
                    child: Text(initial,
                        style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: GJColors.primary)),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: GJColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GJSpacing.xxl),
              TextFormField(
                controller: _nameController,
                decoration: _dec('Nama Lengkap', Icons.person_rounded),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: GJSpacing.lg),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _dec('Alamat Email', Icons.email_rounded),
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isEmpty) return 'Email tidak boleh kosong';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(s)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              if (authState.error != null) ...[
                const SizedBox(height: GJSpacing.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(GJSpacing.md),
                  decoration: BoxDecoration(
                    color: GJColors.dangerSoft,
                    borderRadius: BorderRadius.circular(GJRadius.md),
                  ),
                  child: Text(authState.error!,
                      style:
                          const TextStyle(color: GJColors.danger, fontSize: 13.5)),
                ),
              ],
              const SizedBox(height: GJSpacing.xxl),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GJColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    disabledBackgroundColor: GJColors.border,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(GJRadius.lg)),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.4))
                      : const Text('Simpan Perubahan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
