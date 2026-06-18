import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/vendor_provider.dart';

class VendorDetailScreen extends ConsumerWidget {
  final String slug;

  const VendorDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(vendorDetailProvider(slug));

    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      body: detailAsync.when(
        data: (vendor) {
          final imageUrl = vendor.photos.isNotEmpty ? vendor.photos.first.url : 'https://picsum.photos/600/400';
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: const Color(0xff6366f1),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    vendor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                    ),
                  ),
                  background: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
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
                              color: const Color(0xfff97316).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: Color(0xfff97316)),
                                const SizedBox(width: 4),
                                Text(
                                  '${vendor.ratingAvg} (${vendor.ratingCount} Ulasan)',
                                  style: const TextStyle(
                                    color: Color(0xfff97316),
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
                              color: const Color(0xff6366f1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vendor.city,
                              style: const TextStyle(
                                color: Color(0xff6366f1),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vendor.description,
                        style: const TextStyle(color: Colors.grey, height: 1.5),
                      ),
                      const SizedBox(height: 16),

                      // Address
                      const Text(
                        'Alamat',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_rounded, color: Color(0xff6366f1), size: 20),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
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
                                        color: Color(0xff1e1b4b),
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
                                            color: Color(0xff6366f1),
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
                                  // Navigate to booking wizard screen
                                  context.push('/vendors/${vendor.id}/book?service_id=${service.id}');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff6366f1),
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
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xff6366f1))),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}