import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/vendor_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return const _FilterBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(vendorsListProvider);
    final filter = ref.watch(vendorFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff8f7ff),
      appBar: AppBar(
        title: const Text('Cari Layanan', style: TextStyle(color: Color(0xff1e1b4b), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Color(0xff6366f1)),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari salon, bengkel, klinik...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xff6366f1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff6366f1), width: 1.5),
                ),
                filled: true,
                fillColor: const Color(0xfff8f7ff),
              ),
              onChanged: (val) {
                ref.read(vendorFilterProvider.notifier).setSearch(val);
              },
            ),
          ),
          if (filter.categoryId != null || filter.city != null || filter.minRating != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Text('Filter Aktif: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (filter.categoryId != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Chip(
                                label: Text(filter.categoryId!),
                                onDeleted: () => ref.read(vendorFilterProvider.notifier).setCategory(null),
                              ),
                            ),
                          if (filter.city != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Chip(
                                label: Text(filter.city!),
                                onDeleted: () => ref.read(vendorFilterProvider.notifier).setCity(null),
                              ),
                            ),
                          if (filter.minRating != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Chip(
                                label: Text('⭐ ${filter.minRating}'),
                                onDeleted: () => ref.read(vendorFilterProvider.notifier).setMinRating(null),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: vendorsAsync.when(
              data: (vendors) {
                if (vendors.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada hasil yang sesuai.', style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendors[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        onTap: () => context.push('/vendors/${vendor.slug}'),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
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
                                        Text('${vendor.ratingAvg} (${vendor.ratingCount})'),
                                        const Spacer(),
                                        Text(
                                          vendor.city,
                                          style: const TextStyle(color: Color(0xff6366f1), fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  String? _selectedCity;
  double? _minRating;

  final List<String> _cities = ['Jakarta', 'Bandung', 'Surabaya', 'Medan', 'Makassar'];

  @override
  void initState() {
    super.initState();
    final filter = ref.read(vendorFilterProvider);
    _selectedCity = filter.city;
    _minRating = filter.minRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Pencarian',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff1e1b4b)),
          ),
          const SizedBox(height: 20),
          const Text('Kota', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            hint: const Text('Pilih Kota'),
            items: _cities.map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedCity = val;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Rating Minimal', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [3.0, 4.0, 4.5].map((rating) {
              final isSelected = _minRating == rating;
              return ChoiceChip(
                label: Text('⭐ $rating+'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _minRating = selected ? rating : null;
                  });
                },
                selectedColor: const Color(0xff6366f1),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(vendorFilterProvider.notifier).reset();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(vendorFilterProvider.notifier).setCity(_selectedCity);
                    ref.read(vendorFilterProvider.notifier).setMinRating(_minRating);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6366f1),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Terapkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}