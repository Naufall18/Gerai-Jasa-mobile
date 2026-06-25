import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';

class _OnbSlide {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color soft;
  const _OnbSlide(this.icon, this.title, this.subtitle, this.color, this.soft);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _float;
  double _page = 0;
  int _currentPage = 0;

  static const List<_OnbSlide> _slides = [
    _OnbSlide(
      Icons.search_rounded,
      'Temukan Vendor Terbaik',
      'Cari salon, klinik, bengkel, dan layanan lain di sekitarmu — semua dalam satu aplikasi.',
      GJColors.primary,
      GJColors.primarySoft,
    ),
    _OnbSlide(
      Icons.event_available_rounded,
      'Pilih Jadwal Sesukamu',
      'Pesan slot waktu yang tersedia secara real-time. Tanpa antre, tanpa telepon manual.',
      GJColors.accent,
      GJColors.accentSoft,
    ),
    _OnbSlide(
      Icons.verified_user_rounded,
      'Bayar Aman & Mudah',
      'Transfer bank, e-wallet, atau Bayar di Tempat (COD). Pilih yang paling nyaman untukmu.',
      GJColors.info,
      GJColors.infoSoft,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (!mounted) return;
      setState(() => _page = _pageController.page ?? 0);
    });
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _float.dispose();
    super.dispose();
  }

  bool get _isLast => _currentPage == _slides.length - 1;

  void _next() {
    if (_isLast) {
      context.go('/phone-input');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _slides[_currentPage].color;

    return Scaffold(
      backgroundColor: GJColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                opacity: _isLast ? 0 : 1,
                duration: const Duration(milliseconds: 250),
                child: TextButton(
                  onPressed: _isLast ? null : () => context.go('/phone-input'),
                  child: const Text(
                    'Lewati',
                    style: TextStyle(
                      color: GJColors.textSoft,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  final delta = index - _page;
                  final t = (1 - delta.abs()).clamp(0.0, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _float,
                          builder: (context, child) {
                            final dy = math.sin(_float.value * math.pi * 2) * 8;
                            return Transform.translate(
                              offset: Offset(delta * 48, dy),
                              child: child,
                            );
                          },
                          child: _illustration(slide),
                        ),
                        const SizedBox(height: GJSpacing.xxxl),
                        Opacity(
                          opacity: t,
                          child: Transform.translate(
                            offset: Offset(0, (1 - t) * 24),
                            child: Column(
                              children: [
                                Text(
                                  slide.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: GJColors.ink,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: GJSpacing.md),
                                Text(
                                  slide.subtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    color: GJColors.textSoft,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _bottomBar(activeColor),
          ],
        ),
      ),
    );
  }

  Widget _illustration(_OnbSlide slide) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [slide.soft, slide.soft.withValues(alpha: 0.35)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(72),
          bottomLeft: Radius.circular(72),
          bottomRight: Radius.circular(72),
        ),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: slide.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: slide.color.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(slide.icon, color: Colors.white, size: 56),
        ),
      ),
    );
  }

  Widget _bottomBar(Color activeColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GJSpacing.xxl,
        0,
        GJSpacing.xxl,
        GJSpacing.xl,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? activeColor : GJColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: GJSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(GJRadius.lg),
                ),
              ),
              child: Text(
                _isLast ? 'Mulai Sekarang' : 'Lanjut',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
