class ReservationModel {
  final String id;
  final String userId;
  final String stationId;
  final String chargingPointId;
  final DateTime startTime;
  final DateTime endTime;
  final ReservationStatus status;
  final double totalCost;
  final String currency;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PaymentInfo? payment;
  final StationInfo? stationInfo;

  ReservationModel({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.chargingPointId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalCost,
    required this.currency,
    required this.createdAt,
    this.updatedAt,
    this.payment,
    this.stationInfo,
  });

  bool get isActive => status == ReservationStatus.active;
  bool get isCompleted => status == ReservationStatus.completed;
  bool get isCancelled => status == ReservationStatus.cancelled;
  bool get isUpcoming => startTime.isAfter(DateTime.now());

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      userId: json['userId'],
      stationId: json['stationId'],
      chargingPointId: json['chargingPointId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: ReservationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ReservationStatus.pending,
      ),
      totalCost: json['totalCost'].toDouble(),
      currency: json['currency'] ?? 'TRY',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      payment: json['payment'] != null
          ? PaymentInfo.fromJson(json['payment'])
          : null,
      stationInfo: json['stationInfo'] != null
          ? StationInfo.fromJson(json['stationInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'stationId': stationId,
      'chargingPointId': chargingPointId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status.toString().split('.').last,
      'totalCost': totalCost,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'payment': payment?.toJson(),
      'stationInfo': stationInfo?.toJson(),
    };
  }
}

class PaymentInfo {
  final String id;
  final PaymentStatus status;
  final String method; // card, wallet, points
  final double amount;
  final String currency;
  final DateTime? paidAt;
  final String? transactionId;

  PaymentInfo({
    required this.id,
    required this.status,
    required this.method,
    required this.amount,
    required this.currency,
    this.paidAt,
    this.transactionId,
  });

  bool get isPaid => status == PaymentStatus.paid;
  bool get isPending => status == PaymentStatus.pending;
  bool get isFailed => status == PaymentStatus.failed;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      id: json['id'],
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      method: json['method'],
      amount: json['amount'].toDouble(),
      currency: json['currency'] ?? 'TRY',
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.toString().split('.').last,
      'method': method,
      'amount': amount,
      'currency': currency,
      'paidAt': paidAt?.toIso8601String(),
      'transactionId': transactionId,
    };
  }
}

class StationInfo {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String chargingPointType;
  final double power;

  StationInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.chargingPointType,
    required this.power,
  });

  factory StationInfo.fromJson(Map<String, dynamic> json) {
    return StationInfo(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      chargingPointType: json['chargingPointType'],
      power: json['power'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'chargingPointType': chargingPointType,
      'power': power,
    };
  }
}

enum ReservationStatus {
  pending,
  confirmed,
  active,
  completed,
  cancelled,
  expired,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}
