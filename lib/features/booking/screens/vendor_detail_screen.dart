import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/vendor_provider.dart';
import '../../../core/widgets/gj_widgets.dart';

Widget _buildVendorPlaceholder(String name) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1E6F5C), Color(0xFF14463B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.storefront_rounded, size: 60, color: Colors.white38),
          const SizedBox(height: 8),
          Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white24),
          ),
        ],
      ),
    ),
  );
}

class VendorDetailScreen extends ConsumerWidget {
  final String slug;

  const VendorDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(vendorDetailProvider(slug));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF7),
      body: detailAsync.when(
        data: (vendor) {
          final hasPhoto = vendor.photos.isNotEmpty;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: const Color(0xFF1E6F5C),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    vendor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                    ),
                  ),
                  background: Hero(
                    tag: 'vendor-$slug',
                    child: hasPhoto
                        ? Image.network(
                            vendor.photos.first.url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => _buildVendorPlaceholder(vendor.name),
                          )
                        : _buildVendorPlaceholder(vendor.name),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating & Categories
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2A444).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF2A444)),
                                const SizedBox(width: 4),
                                Text(
                                  '${vendor.ratingAvg} (${vendor.ratingCount} Ulasan)',
                                  style: const TextStyle(
                                    color: Color(0xFFF2A444),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E6F5C).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vendor.city,
                              style: const TextStyle(
                                color: Color(0xFF1E6F5C),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'Tentang Vendor',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vendor.description ?? '',
                        style: const TextStyle(color: Colors.grey, height: 1.5),
                      ),
                      const SizedBox(height: 16),

                      // Address
                      const Text(
                        'Alamat',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_rounded, color: Color(0xFF1E6F5C), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              vendor.address,
                              style: const TextStyle(color: Colors.grey, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Services
                      const Text(
                        'Layanan Tersedia',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF14241F)),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final service = vendor.services[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF14241F),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      service.description ?? '',
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text('${service.durationMinutes} menit', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                        const SizedBox(width: 16),
                                        Text(
                                          'Rp ${service.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Color(0xFF1E6F5C),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.push(
                                    '/booking/${vendor.id}/${service.id}',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E6F5C),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Pilih'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: vendor.services.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          );
        },
        loading: () => SingleChildScrollView(
          child: GJShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GJShimmer.box(width: double.infinity, height: 240, radius: 0),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GJShimmer.box(width: 180, height: 18),
                      const SizedBox(height: 12),
                      GJShimmer.box(width: double.infinity, height: 12),
                      const SizedBox(height: 8),
                      GJShimmer.box(width: double.infinity, height: 12),
                      const SizedBox(height: 24),
                      GJShimmer.vendorCard(),
                      GJShimmer.vendorCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}