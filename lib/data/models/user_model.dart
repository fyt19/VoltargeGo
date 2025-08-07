class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? profileImage;
  final int points;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isActive;
  final UserStats? stats;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.profileImage,
    required this.points,
    required this.createdAt,
    required this.lastLoginAt,
    required this.isActive,
    this.stats,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      points: json['points'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      isActive: json['isActive'] ?? true,
      stats: json['stats'] != null ? UserStats.fromJson(json['stats']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'points': points,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'isActive': isActive,
      'stats': stats?.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    int? points,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
    UserStats? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      stats: stats ?? this.stats,
    );
  }
}

class UserStats {
  final int totalRentals;
  final int totalSpent;
  final double averageRating;
  final int totalReviews;
  final int totalPointsEarned;

  UserStats({
    required this.totalRentals,
    required this.totalSpent,
    required this.averageRating,
    required this.totalReviews,
    required this.totalPointsEarned,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalRentals: json['totalRentals'] ?? 0,
      totalSpent: json['totalSpent'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      totalPointsEarned: json['totalPointsEarned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRentals': totalRentals,
      'totalSpent': totalSpent,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'totalPointsEarned': totalPointsEarned,
    };
  }
}
