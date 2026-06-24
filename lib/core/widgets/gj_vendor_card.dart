import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/models.dart';
import '../theme/design_tokens.dart';

/// Kartu vendor horizontal yang dipakai bersama (home & pencarian).
/// Satu sumber gaya — hindari duplikasi markup di tiap layar.
class GJVendorCard extends StatelessWidget {
  final VendorModel vendor;

  /// Aktifkan Hero pada gambar (animasi list -> detail). Matikan di list
  /// yang bisa menampilkan vendor sama dua kali dalam satu layar.
  final bool hero;

  const GJVendorCard({super.key, required this.vendor, this.hero = true});

  @override
  Widget build(BuildContext context) {
    final imageUrl = vendor.photos.isNotEmpty
        ? vendor.photos.first.url
        : 'https://picsum.photos/seed/${vendor.id}/100/100';

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(GJRadius.md),
      child: Image.network(
        imageUrl,
        width: 76,
        height: 76,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 76,
          height: 76,
          color: GJColors.surfaceAlt,
          child: const Icon(Icons.storefront_rounded, size: 34, color: GJColors.primary),
        ),
      ),
    );
    if (hero) {
      image = Hero(tag: 'vendor-${vendor.slug}', child: image);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: GJSpacing.md),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: GJColors.card,
        borderRadius: GJRadius.card,
        border: Border.all(color: GJColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/vendor/${vendor.slug}'),
          child: Padding(
            padding: const EdgeInsets.all(GJSpacing.md),
            child: Row(
              children: [
                image,
                const SizedBox(width: GJSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: GJColors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vendor.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: GJColors.textSoft),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 15, color: GJColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            vendor.ratingAvg.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: GJColors.ink),
                          ),
                          Text(
                            ' (${vendor.ratingCount})',
                            style: const TextStyle(fontSize: 12, color: GJColors.textSoft),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              vendor.city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GJColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
