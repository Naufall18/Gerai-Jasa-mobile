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
  String _selectedCategorySlug = '';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(vendorsListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    // Filter local list based on query and category slug
    final filteredVendors = vendorsAsync.value?.where((vendor) {
      final matchesSearch = vendor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (vendor.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesCategory = _selectedCategorySlug.isEmpty ||
          vendor.slug == _selectedCategorySlug; // fall back match
      return matchesSearch && matchesCategory;
    }).toList() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      appBar: AppBar(
        title: const Text('Cari Layanan', style: TextStyle(color: Color(0xff1e1b4b), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari salon, klinik, bengkel...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xff6366f1)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
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

          // Categories Horizontal List
          categoriesAsync.when(
            data: (categories) {
              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final category = isAll ? null : categories[index - 1];
                    final isSelected = isAll
                        ? _selectedCategorySlug.isEmpty
                        : _selectedCategorySlug == category?.slug;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          isAll ? 'Semua' : category!.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xff1e1b4b),
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategorySlug = isAll ? '' : category!.slug;
                          });
                        },
                        selectedColor: const Color(0xff6366f1),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox(height: 40),
            error: (err, stack) => const SizedBox(height: 40),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: vendorsAsync.when(
              data: (vendors) {
                if (filteredVendors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'Vendor tidak ditemukan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                        ),
                        const SizedBox(height: 4),
                        const Text('Coba gunakan kata kunci atau kategori lain.', style: TextStyle(color: Colors.grey)),
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
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.storefront_rounded, size: 40, color: Color(0xff6366f1)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vendor.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Vendor Service',
                                    style: TextStyle(color: Color(0xfff97316), fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        vendor.ratingAvg.toStringAsFixed(1),
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${vendor.ratingCount})',
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.location_on_rounded, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          vendor.city,
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
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
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xff6366f1))),
              error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
    );
  }
}