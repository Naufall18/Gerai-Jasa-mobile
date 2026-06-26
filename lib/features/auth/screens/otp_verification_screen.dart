import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../providers/auth_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _counter = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _counter = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() => _counter--);
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    final phone = ref.read(authProvider).phoneForOtp;
    if (phone == null) return;

    final success = await ref.read(authProvider.notifier).requestOtp(phone);
    if (success) {
      _startTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kode OTP berhasil dikirim ulang')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final code = _otpController.text.trim();
    final isRegistered = await ref.read(authProvider.notifier).verifyOtp(code);
    if (mounted) {
      if (isRegistered) {
        context.go('/home');
      } else {
        context.go('/profile-setup');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
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
                onPressed: () => context.go('/phone-input'),
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
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: GJColors.accentSoft,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                          ),
                        ),
                        child: const Icon(Icons.mark_chat_read_rounded,
                            color: GJColors.accent, size: 34),
                      ),
                      const SizedBox(height: GJSpacing.xl),
                      const Text(
                        'Verifikasi Kode OTP',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: GJColors.ink,
                        ),
                      ),
                      const SizedBox(height: GJSpacing.sm),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                              fontSize: 15.5,
                              color: GJColors.textSoft,
                              height: 1.5),
                          children: [
                            const TextSpan(
                                text: 'Masukkan 6 digit kode yang kami kirim ke WhatsApp '),
                            TextSpan(
                              text: authState.phoneForOtp ?? '-',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: GJColors.ink),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: GJSpacing.xxl),
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 10,
                          color: GJColors.ink,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '••••••',
                          hintStyle: TextStyle(
                              letterSpacing: 10,
                              color: GJColors.border,
                              fontSize: 26),
                          filled: true,
                          fillColor: Colors.white,
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
                          if (value == null || value.trim().length != 6) {
                            return 'Masukkan 6 digit OTP';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: GJSpacing.lg),
                      Center(
                        child: _counter > 0
                            ? Text(
                                'Kirim ulang kode dalam ${_counter}s',
                                style: const TextStyle(color: GJColors.textSoft),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Tidak menerima kode? ',
                                      style:
                                          TextStyle(color: GJColors.textSoft)),
                                  GestureDetector(
                                    onTap: _resendOtp,
                                    child: const Text(
                                      'Kirim Ulang',
                                      style: TextStyle(
                                          color: GJColors.primary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
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
              child: SizedBox(
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
                          'Verifikasi',
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
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
