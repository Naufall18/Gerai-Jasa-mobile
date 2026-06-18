class UserModel {
  final String id;
  final String name;
  final String? email;
  final String phone;
  final String role;
  final String? avatarUrl;
  final String? fcmToken;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.fcmToken,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'customer',
      avatarUrl: json['avatar_url'],
      fcmToken: json['fcm_token'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar_url': avatarUrl,
      'fcm_token': fcmToken,
      'is_active': isActive,
    };
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? iconUrl;
  final String? description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.iconUrl,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      iconUrl: json['icon_url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon_url': iconUrl,
      'description': description,
    };
  }
}

class VendorPhotoModel {
  final String id;
  final String url;
  final String? caption;

  VendorPhotoModel({
    required this.id,
    required this.url,
    this.caption,
  });

  factory VendorPhotoModel.fromJson(Map<String, dynamic> json) {
    return VendorPhotoModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'caption': caption,
    };
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int durationMinutes;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.durationMinutes,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      durationMinutes: json['duration_minutes'] ?? 30,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_minutes': durationMinutes,
      'is_active': isActive,
    };
  }
}

class VendorModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String address;
  final String city;
  final double? lat;
  final double? lng;
  final double ratingAvg;
  final int ratingCount;
  final bool isFeatured;
  final List<VendorPhotoModel> photos;
  final List<ServiceModel> services;

  VendorModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.address,
    required this.city,
    this.lat,
    this.lng,
    required this.ratingAvg,
    required this.ratingCount,
    required this.isFeatured,
    required this.photos,
    required this.services,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    var photosList = json['photos'] as List? ?? [];
    var servicesList = json['services'] as List? ?? [];
    return VendorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      lat: double.tryParse(json['lat'].toString()),
      lng: double.tryParse(json['lng'].toString()),
      ratingAvg: double.tryParse(json['rating_avg'].toString()) ?? 0.0,
      ratingCount: json['rating_count'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      photos: photosList.map((p) => VendorPhotoModel.fromJson(p)).toList(),
      services: servicesList.map((s) => ServiceModel.fromJson(s)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'address': address,
      'city': city,
      'lat': lat,
      'lng': lng,
      'rating_avg': ratingAvg,
      'rating_count': ratingCount,
      'is_featured': isFeatured,
      'photos': photos.map((p) => p.toJson()).toList(),
      'services': services.map((s) => s.toJson()).toList(),
    };
  }
}

class TimeSlotModel {
  final String id;
  final String slotDate;
  final String slotTime;
  final bool isAvailable;

  TimeSlotModel({
    required this.id,
    required this.slotDate,
    required this.slotTime,
    required this.isAvailable,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] ?? '',
      slotDate: json['slot_date'] ?? '',
      slotTime: json['slot_time'] ?? '',
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slot_date': slotDate,
      'slot_time': slotTime,
      'is_available': isAvailable,
    };
  }
}

class BookingModel {
  final String id;
  final String bookingCode;
  final String status;
  final String? notes;
  final double totalPrice;
  final String paymentMethod;
  final ServiceModel? service;
  final VendorModel? vendor;
  final TimeSlotModel? timeSlot;
  final String? confirmedAt;
  final String? completedAt;
  final String? cancelledAt;
  final String? cancellationReason;

  BookingModel({
    required this.id,
    required this.bookingCode,
    required this.status,
    this.notes,
    required this.totalPrice,
    required this.paymentMethod,
    this.service,
    this.vendor,
    this.timeSlot,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      bookingCode: json['booking_code'] ?? '',
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      paymentMethod: json['payment_method'] ?? 'cod',
      service: json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
      timeSlot: json['time_slot'] != null ? TimeSlotModel.fromJson(json['time_slot']) : null,
      confirmedAt: json['confirmed_at'],
      completedAt: json['completed_at'],
      cancelledAt: json['cancelled_at'],
      cancellationReason: json['cancellation_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_code': bookingCode,
      'status': status,
      'notes': notes,
      'total_price': totalPrice,
      'payment_method': paymentMethod,
      'service': service?.toJson(),
      'vendor': vendor?.toJson(),
      'time_slot': timeSlot?.toJson(),
      'confirmed_at': confirmedAt,
      'completed_at': completedAt,
      'cancelled_at': cancelledAt,
      'cancellation_reason': cancellationReason,
    };
  }
}

class ReviewModel {
  final String id;
  final String bookingId;
  final String customerName;
  final int rating;
  final String? comment;
  final String? vendorReply;
  final String? repliedAt;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.customerName,
    required this.rating,
    this.comment,
    this.vendorReply,
    this.repliedAt,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      customerName: json['customer']?['name'] ?? 'Pelanggan',
      rating: json['rating'] ?? 5,
      comment: json['comment'],
      vendorReply: json['vendor_reply'],
      repliedAt: json['replied_at'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'customer': {'name': customerName},
      'rating': rating,
      'comment': comment,
      'vendor_reply': vendorReply,
      'replied_at': repliedAt,
      'created_at': createdAt,
    };
  }
}