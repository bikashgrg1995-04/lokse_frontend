class ProfileModel {
  final int id;
  final String email;
  final String fullName;
  final String profileImage;     // relative path
  final String profileImageUrl;  // full URL
  final String phoneNumber;
  final DateTime createdAt;
  final bool isVerified;

  ProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.profileImage,
    required this.profileImageUrl,
    required this.phoneNumber,
    required this.createdAt,
    required this.isVerified,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'profile_image': profileImage,
      'profile_image_url': profileImageUrl,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'is_verified': isVerified,
    };
  }

  ProfileModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? profileImage,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
