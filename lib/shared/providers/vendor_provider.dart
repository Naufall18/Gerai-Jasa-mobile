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

  void setCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId, clearCategory: categoryId == null);
  }

  void setCity(String? city) {
    state = state.copyWith(city: city);
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search);
  }

  void setMinRating(double? rating) {
    state = state.copyWith(minRating: rating);
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
