import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

class AppTheme {
  // ── Alias warna (kompatibel dengan kode lama; semua mengarah ke token) ──
  static const Color primaryColor = GJColors.primary;
  static const Color accentColor = GJColors.accent;
  static const Color backgroundColor = GJColors.surface;
  static const Color cardColor = GJColors.card;
  static const Color textPrimaryColor = GJColors.ink;
  static const Color textSecondaryColor = GJColors.textSoft;

  static ThemeData get lightTheme {
    final base = ThemeData(useMaterial3: true);

    // Body: Plus Jakarta Sans. Heading: Sora.
    final bodyFont = GoogleFonts.plusJakartaSans;
    final headingFont = GoogleFonts.sora;

    final textTheme = base.textTheme.apply(
      bodyColor: GJColors.ink,
      displayColor: GJColors.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: GJColors.surface,
      cardColor: GJColors.card,
      colorScheme: ColorScheme.fromSeed(
        seedColor: GJColors.primary,
        primary: GJColors.primary,
        secondary: GJColors.accent,
        surface: GJColors.surface,
        error: GJColors.danger,
        brightness: Brightness.light,
      ),
      textTheme: textTheme.copyWith(
        displaySmall: headingFont(fontSize: 28, fontWeight: FontWeight.w700, color: GJColors.ink),
        headlineSmall: headingFont(fontSize: 22, fontWeight: FontWeight.w700, color: GJColors.ink),
        titleLarge: headingFont(fontSize: 20, fontWeight: FontWeight.w700, color: GJColors.ink),
        titleMedium: headingFont(fontSize: 16, fontWeight: FontWeight.w600, color: GJColors.ink),
        bodyLarge: bodyFont(fontSize: 16, color: GJColors.ink),
        bodyMedium: bodyFont(fontSize: 14, color: GJColors.textSoft),
        bodySmall: bodyFont(fontSize: 12, color: GJColors.textSoft),
        labelLarge: bodyFont(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: GJColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: GJColors.ink),
        titleTextStyle: headingFont(fontSize: 18, fontWeight: FontWeight.w700, color: GJColors.ink),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GJColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: bodyFont(fontWeight: FontWeight.w600, fontSize: 15),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GJRadius.lg)),
          minimumSize: const Size(0, 52), // touch target nyaman
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GJColors.primary,
          side: const BorderSide(color: GJColors.border),
          textStyle: bodyFont(fontWeight: FontWeight.w600, fontSize: 15),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GJRadius.lg)),
          minimumSize: const Size(0, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: bodyFont(color: GJColors.textSoft, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GJRadius.md),
          borderSide: const BorderSide(color: GJColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GJRadius.md),
          borderSide: const BorderSide(color: GJColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GJRadius.md),
          borderSide: const BorderSide(color: GJColors.danger),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: GJColors.surfaceAlt,
        selectedColor: GJColors.primary,
        labelStyle: bodyFont(fontSize: 13, color: GJColors.ink),
        secondaryLabelStyle: bodyFont(fontSize: 13, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GJRadius.pill)),
        side: BorderSide.none,
      ),
      dividerTheme: const DividerThemeData(color: GJColors.border, thickness: 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: GJColors.primary,
        unselectedItemColor: GJColors.textSoft,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),
    );
  }
}
