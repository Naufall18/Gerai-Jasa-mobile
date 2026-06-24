import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/vendor_provider.dart';
import '../../../core/widgets/gj_widgets.dart';
import '../../../core/widgets/gj_vendor_card.dart';

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
      backgroundColor: const Color(0xFFFBFAF7),
      appBar: AppBar(
        title: const Text(
          'Cari Layanan',
          style: TextStyle(color: Color(0xFF14241F), fontWeight: FontWeight.bold),
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
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1E6F5C)),
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
                          color: isSelected ? Colors.white : const Color(0xFF14241F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryId = isAll ? '' : category!.id;
                        });
                      },
                      selectedColor: const Color(0xFF1E6F5C),
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
                  return const GJEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Vendor tidak ditemukan',
                    subtitle: 'Coba gunakan kata kunci atau kategori lain.',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredVendors.length,
                  itemBuilder: (context, index) {
                    final vendor = filteredVendors[index];
                    return GJVendorCard(vendor: vendor);
                  },
                );
              },
              loading: () => GJShimmer(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: List.generate(
                    5,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GJShimmer.vendorCard(),
                    ),
                  ),
                ),
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
