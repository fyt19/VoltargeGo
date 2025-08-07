class ChargingStationModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? description;
  final List<String> images;
  final List<ChargingPoint> chargingPoints;
  final StationStatus status;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final PricingInfo pricing;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChargingStationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.images,
    required this.chargingPoints,
    required this.status,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.pricing,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAvailable => status == StationStatus.available;
  bool get isUnderMaintenance => status == StationStatus.maintenance;
  bool get isOffline => status == StationStatus.offline;

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) {
    return ChargingStationModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      chargingPoints: (json['chargingPoints'] as List)
          .map((point) => ChargingPoint.fromJson(point))
          .toList(),
      status: StationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => StationStatus.offline,
      ),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      amenities: List<String>.from(json['amenities'] ?? []),
      pricing: PricingInfo.fromJson(json['pricing']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'images': images,
      'chargingPoints': chargingPoints.map((point) => point.toJson()).toList(),
      'status': status.toString().split('.').last,
      'rating': rating,
      'reviewCount': reviewCount,
      'amenities': amenities,
      'pricing': pricing.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ChargingPoint {
  final String id;
  final String type; // AC, DC, Fast, Ultra-fast
  final double power; // kW
  final PointStatus status;
  final String? currentUser;
  final DateTime? estimatedCompletion;

  ChargingPoint({
    required this.id,
    required this.type,
    required this.power,
    required this.status,
    this.currentUser,
    this.estimatedCompletion,
  });

  bool get isAvailable => status == PointStatus.available;
  bool get isInUse => status == PointStatus.inUse;
  bool get isUnderMaintenance => status == PointStatus.maintenance;

  factory ChargingPoint.fromJson(Map<String, dynamic> json) {
    return ChargingPoint(
      id: json['id'],
      type: json['type'],
      power: json['power'].toDouble(),
      status: PointStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => PointStatus.offline,
      ),
      currentUser: json['currentUser'],
      estimatedCompletion: json['estimatedCompletion'] != null
          ? DateTime.parse(json['estimatedCompletion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'power': power,
      'status': status.toString().split('.').last,
      'currentUser': currentUser,
      'estimatedCompletion': estimatedCompletion?.toIso8601String(),
    };
  }
}

class PricingInfo {
  final double pricePerKwh;
  final double? connectionFee;
  final double? parkingFee;
  final String currency;
  final List<DiscountRule>? discounts;

  PricingInfo({
    required this.pricePerKwh,
    this.connectionFee,
    this.parkingFee,
    required this.currency,
    this.discounts,
  });

  factory PricingInfo.fromJson(Map<String, dynamic> json) {
    return PricingInfo(
      pricePerKwh: json['pricePerKwh'].toDouble(),
      connectionFee: json['connectionFee']?.toDouble(),
      parkingFee: json['parkingFee']?.toDouble(),
      currency: json['currency'] ?? 'TRY',
      discounts: json['discounts'] != null
          ? (json['discounts'] as List)
              .map((discount) => DiscountRule.fromJson(discount))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pricePerKwh': pricePerKwh,
      'connectionFee': connectionFee,
      'parkingFee': parkingFee,
      'currency': currency,
      'discounts': discounts?.map((discount) => discount.toJson()).toList(),
    };
  }
}

class DiscountRule {
  final String type; // percentage, fixed
  final double value;
  final String? condition; // time, amount, user_type

  DiscountRule({
    required this.type,
    required this.value,
    this.condition,
  });

  factory DiscountRule.fromJson(Map<String, dynamic> json) {
    return DiscountRule(
      type: json['type'],
      value: json['value'].toDouble(),
      condition: json['condition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'condition': condition,
    };
  }
}

enum StationStatus {
  available,
  maintenance,
  offline,
}

enum PointStatus {
  available,
  inUse,
  maintenance,
  offline,
}
