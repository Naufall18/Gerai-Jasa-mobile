import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Temukan Vendor Terbaik',
      'subtitle': 'Cari dan temukan layanan salon, klinik kesehatan, bengkel, dan lainnya di sekitar Anda.',
      'icon': 'search',
    },
    {
      'title': 'Pilih Jadwal Sesukamu',
      'subtitle': 'Pesan slot waktu yang tersedia secara real-time tanpa antre atau telepon manual.',
      'icon': 'calendar_today',
    },
    {
      'title': 'Bayar Aman & Mudah',
      'subtitle': 'Pilih metode pembayaran transfer bank, e-wallet, atau Bayar di Tempat (COD) saat layanan selesai.',
      'icon': 'payment',
    },
  ];

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'search':
        return Icons.search_rounded;
      case 'calendar_today':
        return Icons.calendar_today_rounded;
      case 'payment':
        return Icons.payment_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: const Color(0xff6366f1).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(slide['icon']!),
                            color: const Color(0xff6366f1),
                            size: 80,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          slide['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e1b4b),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['subtitle']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? const Color(0xff6366f1) : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _slides.length - 1) {
                        context.go('/phone-input');
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6366f1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1 ? 'Mulai' : 'Lanjut',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}