import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/vendor_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(vendorsListProvider);
    final activeFilter = ref.watch(vendorFilterProvider);

    // Seeded Categories
    final categories = [
      {'id': '1', 'name': 'Salon', 'icon': Icons.face_rounded},
      {'id': '2', 'name': 'Klinik', 'icon': Icons.local_hospital_rounded},
      {'id': '3', 'name': 'Bengkel', 'icon': Icons.build_rounded},
      {'id': '4', 'name': 'Spa', 'icon': Icons.spa_rounded},
      {'id': '5', 'name': 'Gym', 'icon': Icons.fitness_center_rounded},
      {'id': '6', 'name': 'Laundry', 'icon': Icons.local_laundry_service_rounded},
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Halo, Budi 👋',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e1b4b),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.location_on_rounded, size: 16, color: Color(0xfff97316)),
                            SizedBox(width: 4),
                            Text(
                              'Jakarta, Indonesia',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Color(0xff1e1b4b)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Search Box Trigger
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: InkWell(
                  onTap: () {
                    // Navigate or switch to search tab
                    // In our case we can change search text or notify
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded, color: Colors.grey),
                        SizedBox(width: 12),
                        Text(
                          'Cari salon, bengkel, klinik...',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Kategori Layanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e1b4b),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = activeFilter.categoryId == cat['name'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Row(
                          children: [
                            Icon(
                              cat['icon'] as IconData,
                              size: 16,
                              color: isSelected ? Colors.white : const Color(0xff6366f1),
                            ),
                            const SizedBox(width: 6),
                            Text(cat['name'] as String),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref.read(vendorFilterProvider.notifier).setCategory(
                            selected ? (cat['name'] as String) : null,
                          );
                        },
                        selectedColor: const Color(0xff6366f1),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xff1e1b4b),
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : Colors.grey.shade200,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Featured Vendor Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Vendor Unggulan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e1b4b),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              vendorsAsync.when(
                data: (vendors) {
                  final featured = vendors.where((v) => v.isFeatured).toList();
                  if (featured.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text('Tidak ada vendor unggulan saat ini.', style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: featured.length,
                      itemBuilder: (context, index) {
                        final vendor = featured[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () => context.push('/vendors/${vendor.slug}'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.network(
                                    vendor.photos.isNotEmpty ? vendor.photos.first.url : 'https://picsum.photos/400/200',
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade200,
                                      height: 120,
                                      child: const Icon(Icons.image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vendor.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1e1b4b),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded, size: 16, color: Color(0xfff97316)),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${vendor.ratingAvg} (${vendor.ratingCount})',
                                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            vendor.city,
                                            style: const TextStyle(color: Color(0xff6366f1), fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xff6366f1))),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              const SizedBox(height: 24),

              // All / Nearby Vendors
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Terdekat Dari Kamu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e1b4b),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              vendorsAsync.when(
                data: (vendors) {
                  if (vendors.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Tidak ada vendor ditemukan.', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: vendors.length,
                    itemBuilder: (context, index) {
                      final vendor = vendors[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => context.push('/vendors/${vendor.slug}'),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    vendor.photos.isNotEmpty ? vendor.photos.first.url : 'https://picsum.photos/100/100',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade200,
                                      width: 80,
                                      height: 80,
                                      child: const Icon(Icons.image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vendor.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1e1b4b),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        vendor.address,
                                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 16, color: Color(0xfff97316)),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${vendor.ratingAvg} (${vendor.ratingCount})',
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                          const Spacer(),
                                          Text(
                                            vendor.city,
                                            style: const TextStyle(
                                              color: Color(0xff6366f1),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
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
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xff6366f1))),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}