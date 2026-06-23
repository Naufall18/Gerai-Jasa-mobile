import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/vendor_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedCategoryId = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Update the provider filter to trigger API re-fetch with debounce
      ref.read(vendorFilterProvider.notifier).setSearch(val.trim().isEmpty ? null : val.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(vendorsListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    // Client-side filter by selected category (matching vendor's category_id field)
    final filteredVendors = vendorsAsync.value?.where((vendor) {
      final matchesCategory = _selectedCategoryId.isEmpty ||
          vendor.categoryId == _selectedCategoryId;
      return matchesCategory;
    }).toList() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      appBar: AppBar(
        title: const Text(
          'Cari Layanan',
          style: TextStyle(color: Color(0xff1e1b4b), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Input with debounce
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari salon, klinik, bengkel...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xff6366f1)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(vendorFilterProvider.notifier).setSearch(null);
                        },
                      )
                    : null,
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Categories Horizontal List
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final category = isAll ? null : categories[index - 1];
                  final isSelected = isAll
                      ? _selectedCategoryId.isEmpty
                      : _selectedCategoryId == category?.id;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        isAll ? 'Semua' : category!.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xff1e1b4b),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryId = isAll ? '' : category!.id;
                        });
                      },
                      selectedColor: const Color(0xff6366f1),
                      backgroundColor: Colors.white,
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
            loading: () => const SizedBox(height: 40),
            error: (_, __) => const SizedBox(height: 40),
          ),

          const SizedBox(height: 12),

          // Results
          Expanded(
            child: vendorsAsync.when(
              data: (_) {
                if (filteredVendors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'Vendor tidak ditemukan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Coba gunakan kata kunci atau kategori lain.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredVendors.length,
                  itemBuilder: (context, index) {
                    final vendor = filteredVendors[index];
                    return GestureDetector(
                      onTap: () => context.push('/vendor/${vendor.slug}'),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                vendor.photos.isNotEmpty
                                    ? vendor.photos.first.url
                                    : 'https://picsum.photos/seed/${vendor.id}/80/80',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.storefront_rounded,
                                      size: 40, color: Color(0xff6366f1)),
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
                                        color: Color(0xff1e1b4b)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    vendor.address,
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        vendor.ratingAvg.toStringAsFixed(1),
                                        style: const TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${vendor.ratingCount})',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.location_on_rounded,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          vendor.city,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xff6366f1)),
              ),
              error: (err, stack) => Center(
                child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
