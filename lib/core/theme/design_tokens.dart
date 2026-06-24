import 'package:flutter/material.dart';

/// Gerai Jasa — design tokens (palet "Pine & Amber").
/// Sumber kebenaran tunggal untuk warna, spacing, radius, motion.
/// JANGAN hardcode nilai gaya di file lain — pakai token ini.
class GJColors {
  GJColors._();

  // Brand
  static const Color primary = Color(0xFF1E6F5C);
  static const Color primarySoft = Color(0xFFD8EEE7);
  static const Color primaryDark = Color(0xFF14463B);
  static const Color accent = Color(0xFFF2A444);
  static const Color accentSoft = Color(0xFFFFF1DD);

  // Netral
  static const Color ink = Color(0xFF14241F); // teks utama
  static const Color textSoft = Color(0xFF55615D); // teks sekunder
  static const Color surface = Color(0xFFFBFAF7);
  static const Color surfaceAlt = Color(0xFFF5F3EF);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE3E8E2);

  // Status
  static const Color success = Color(0xFF2E8B57);
  static const Color warning = Color(0xFFD68A1F);
  static const Color danger = Color(0xFFC94A4A);
  static const Color info = Color(0xFF2C8C84);

  // Soft backgrounds untuk badge status
  static const Color successSoft = Color(0xFFE6F3EC);
  static const Color warningSoft = Color(0xFFFFF1DD);
  static const Color dangerSoft = Color(0xFFF9ECEC);
  static const Color infoSoft = Color(0xFFE4F0EF);
}

/// Skala spacing — kelipatan konsisten.
class GJSpacing {
  GJSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Skala radius (16–20 untuk kartu).
class GJRadius {
  GJRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  /// Signature "kartu sudut-asimetris": 3 sudut 18, 1 sudut kecil (kiri-atas).
  static const BorderRadius card = BorderRadius.only(
    topLeft: Radius.circular(6),
    topRight: Radius.circular(18),
    bottomRight: Radius.circular(18),
    bottomLeft: Radius.circular(18),
  );

  static BorderRadius all(double r) => BorderRadius.circular(r);
}

/// Durasi & kurva animasi (halus, konsisten).
class GJMotion {
  GJMotion._();
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Curve curve = Curves.easeOutCubic;
}

/// Shadow lembut bertingkat.
class GJShadow {
  GJShadow._();
  static List<BoxShadow> get sm => [
        BoxShadow(
          color: GJColors.ink.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
  static List<BoxShadow> get md => [
        BoxShadow(
          color: GJColors.ink.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
}
