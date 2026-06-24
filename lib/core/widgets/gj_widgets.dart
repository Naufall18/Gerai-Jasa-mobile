import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/design_tokens.dart';

/// Empty state ramah: ikon dalam lingkaran lembut + judul + subjudul + CTA opsional.
class GJEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const GJEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GJSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: GJColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: GJColors.primary),
            ),
            const SizedBox(height: GJSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GJColors.ink),
            ),
            const SizedBox(height: GJSpacing.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: GJColors.textSoft),
            ),
            if (action != null) ...[
              const SizedBox(height: GJSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Pembungkus shimmer + kotak skeleton meniru bentuk konten.
class GJShimmer extends StatelessWidget {
  final Widget child;
  const GJShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: GJColors.surfaceAlt,
      highlightColor: Colors.white,
      child: child,
    );
  }

  /// Kotak skeleton sederhana.
  static Widget box({double? width, double height = 16, double radius = GJRadius.sm}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  /// Skeleton kartu vendor (untuk list/grid saat loading).
  static Widget vendorCard() {
    return Container(
      padding: const EdgeInsets.all(GJSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GJRadius.card,
        border: Border.all(color: GJColors.border),
      ),
      child: Row(
        children: [
          box(width: 64, height: 64, radius: GJRadius.md),
          const SizedBox(width: GJSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                box(width: 160, height: 14),
                const SizedBox(height: GJSpacing.sm),
                box(width: 100, height: 12),
                const SizedBox(height: GJSpacing.sm),
                box(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
