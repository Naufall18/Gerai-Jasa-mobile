import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../models/models.dart';

class VendorFilter {
  final String? categoryId;
  final String? city;
  final double? minRating;
  final String? search;

  const VendorFilter({
    this.categoryId,
    this.city,
    this.minRating,
    this.search,
  });

  VendorFilter copyWith({
    String? categoryId,
    String? city,
    double? minRating,
    String? search,
    bool clearCategory = false,
  }) {
    return VendorFilter(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      city: city ?? this.city,
      minRating: minRating ?? this.minRating,
      search: search ?? this.search,
    );
  }
}

class VendorFilterNotifier extends StateNotifier<VendorFilter> {
  VendorFilterNotifier() : super(const VendorFilter());

  // NOTE: build a fresh VendorFilter explicitly (not copyWith) so a field can be
  // cleared back to null — copyWith's `value ?? this.value` kept stale values,
  // which made clearing the search box leave the list stuck on old results.
  void setCategory(String? categoryId) {
    state = VendorFilter(
      categoryId: (categoryId == null || categoryId.isEmpty) ? null : categoryId,
      city: state.city,
      minRating: state.minRating,
      search: state.search,
    );
  }

  void setCity(String? city) {
    state = VendorFilter(
      categoryId: state.categoryId,
      city: (city == null || city.isEmpty) ? null : city,
      minRating: state.minRating,
      search: state.search,
    );
  }

  void setSearch(String? search) {
    state = VendorFilter(
      categoryId: state.categoryId,
      city: state.city,
      minRating: state.minRating,
      search: (search == null || search.isEmpty) ? null : search,
    );
  }

  void setMinRating(double? rating) {
    state = VendorFilter(
      categoryId: state.categoryId,
      city: state.city,
      minRating: rating,
      search: state.search,
    );
  }

  void reset() {
    state = const VendorFilter();
  }
}

final vendorFilterProvider = StateNotifierProvider<VendorFilterNotifier, VendorFilter>((ref) {
  return VendorFilterNotifier();
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/categories');
  final list = response.data['data'] as List;
  return list.map((json) => CategoryModel.fromJson(json)).toList();
});

final vendorsListProvider = FutureProvider<List<VendorModel>>((ref) async {
  final filter = ref.watch(vendorFilterProvider);
  final apiClient = ref.watch(apiClientProvider);

  final Map<String, dynamic> queryParameters = {};
  if (filter.categoryId != null) queryParameters['category_id'] = filter.categoryId;
  if (filter.city != null) queryParameters['city'] = filter.city;
  if (filter.minRating != null) queryParameters['min_rating'] = filter.minRating;
  if (filter.search != null && filter.search!.isNotEmpty) {
    queryParameters['search'] = filter.search;
  }

  final response = await apiClient.get('/vendors', queryParameters: queryParameters);
  final list = response.data['data'] as List;
  return list.map((json) => VendorModel.fromJson(json)).toList();
});

final vendorDetailProvider = FutureProvider.family<VendorModel, String>((ref, slug) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/vendors/$slug');
  return VendorModel.fromJson(response.data['data']);
});

final availableSlotsProvider = FutureProvider.family<List<TimeSlotModel>, ({String vendorId, String serviceId, String date})>((ref, arg) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    '/vendors/${arg.vendorId}/slots',
    queryParameters: {
      'service_id': arg.serviceId,
      'date': arg.date,
    },
  );
  final list = response.data['data'] as List;
  return list.map((json) => TimeSlotModel.fromJson(json)).toList();
});
