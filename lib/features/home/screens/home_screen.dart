import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/providers/vendor_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(vendorsListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final authState = ref.watch(authProvider);
    final activeFilter = ref.watch(vendorFilterProvider);

    final userName = authState.user?.name.split(' ').first ?? 'Pengguna';

    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(vendorsListProvider);
            ref.invalidate(categoriesProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                          Text(
                            'Halo, $userName 👋',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e1b4b),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 16, color: Color(0xfff97316)),
                              SizedBox(width: 4),
                              Text(
                                'Indonesia',
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

                // Search Box Trigger — navigates to search tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: InkWell(
                    onTap: () => context.push('/search'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
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

                // Category Section — from API
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
                categoriesAsync.when(
                  data: (categories) => SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = activeFilter.categoryId == cat.id;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(cat.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              ref.read(vendorFilterProvider.notifier).setCategory(
                                selected ? cat.id : null,
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
                  loading: () => const SizedBox(
                    height: 48,
                    child: Center(child: CircularProgressIndicator(color: Color(0xff6366f1), strokeWidth: 2)),
                  ),
                  error: (_, __) => const SizedBox(height: 48),
                ),
                const SizedBox(height: 24),

                // Featured Vendor Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Vendor Unggulan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
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
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () => context.push('/vendor/${vendor.slug}'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.network(
                                      vendor.photos.isNotEmpty
                                          ? vendor.photos.first.url
                                          : 'https://picsum.photos/seed/${vendor.id}/400/200',
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
                                                  '${vendor.ratingAvg.toStringAsFixed(1)} (${vendor.ratingCount})',
                                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              vendor.city,
                                              style: const TextStyle(
                                                  color: Color(0xff6366f1), fontSize: 13, fontWeight: FontWeight.bold),
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
                  loading: () => const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator(color: Color(0xff6366f1))),
                  ),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // All Vendors
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Semua Vendor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
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
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () => context.push('/vendor/${vendor.slug}'),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      vendor.photos.isNotEmpty
                                          ? vendor.photos.first.url
                                          : 'https://picsum.photos/seed/${vendor.id}/100/100',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey.shade200,
                                        width: 80,
                                        height: 80,
                                        child: const Icon(Icons.storefront_rounded, color: Color(0xff6366f1), size: 36),
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
                                              fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
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
                                              '${vendor.ratingAvg.toStringAsFixed(1)} (${vendor.ratingCount})',
                                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                                            ),
                                            const Spacer(),
                                            Text(
                                              vendor.city,
                                              style: const TextStyle(
                                                  color: Color(0xff6366f1), fontSize: 13, fontWeight: FontWeight.bold),
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
                  loading: () => const Center(child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: Color(0xff6366f1)),
                  )),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
