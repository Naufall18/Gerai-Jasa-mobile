import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../providers/auth_provider.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final success = await ref.read(authProvider.notifier).requestOtp(phone);
    if (success && mounted) {
      context.go('/otp-verify');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: GJColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: GJColors.ink, size: 20),
                onPressed: () => context.go('/onboarding'),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: GJSpacing.sm),
                      // Branded hero badge.
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: GJColors.primarySoft,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                          ),
                        ),
                        child: const Icon(Icons.chat_rounded,
                            color: GJColors.primary, size: 34),
                      ),
                      const SizedBox(height: GJSpacing.xl),
                      const Text(
                        'Masuk atau Daftar',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: GJColors.ink,
                        ),
                      ),
                      const SizedBox(height: GJSpacing.sm),
                      const Text(
                        'Masukkan nomor HP-mu. Kami akan mengirim kode OTP melalui WhatsApp untuk verifikasi.',
                        style: TextStyle(
                          fontSize: 15.5,
                          color: GJColors.textSoft,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: GJSpacing.xxl),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                        ],
                        style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w600,
                          color: GJColors.ink,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nomor Handphone',
                          hintText: '0812 3456 7890',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.phone_iphone_rounded,
                              color: GJColors.primary),
                          labelStyle: const TextStyle(color: GJColors.textSoft),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(GJRadius.lg),
                            borderSide: const BorderSide(color: GJColors.border),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(GJRadius.lg),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(GJRadius.lg),
                            borderSide: const BorderSide(
                                color: GJColors.primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) return 'Nomor HP tidak boleh kosong';
                          if (v.length < 9) return 'Nomor HP tidak valid';
                          return null;
                        },
                      ),
                      if (authState.error != null) ...[
                        const SizedBox(height: GJSpacing.lg),
                        _errorBox(authState.error!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  GJSpacing.xl, GJSpacing.sm, GJSpacing.xl, GJSpacing.lg),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GJColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        disabledBackgroundColor: GJColors.border,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(GJRadius.lg),
                        ),
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.4),
                            )
                          : const Text(
                              'Kirim Kode OTP',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: GJSpacing.md),
                  const Text(
                    'Dengan melanjutkan, kamu menyetujui Syarat & Kebijakan Privasi Gerai Jasa.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: GJColors.textSoft),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(GJSpacing.md),
      decoration: BoxDecoration(
        color: GJColors.dangerSoft,
        borderRadius: BorderRadius.circular(GJRadius.md),
        border: Border.all(color: GJColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: GJColors.danger, size: 20),
          const SizedBox(width: GJSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: GJColors.danger, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}
