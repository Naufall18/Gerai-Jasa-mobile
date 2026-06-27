import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/models.dart';
import '../theme/design_tokens.dart';

Widget _buildPlaceholder(String name) {
  return Container(
    width: 76,
    height: 76,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [GJColors.primary, GJColors.primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(GJRadius.md),
    ),
    child: Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white38),
      ),
    ),
  );
}

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
    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(GJRadius.md),
      child: SizedBox(
        width: 76,
        height: 76,
        child: vendor.photos.isNotEmpty
            ? Image.network(
                vendor.photos.first.url,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(vendor.name),
              )
            : _buildPlaceholder(vendor.name),
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
