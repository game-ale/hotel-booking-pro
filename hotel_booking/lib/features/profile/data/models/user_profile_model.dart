import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.phoneNumber,
    super.address,
    super.bio,
    super.profileImageUrl,
    super.dateOfBirth,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'address': address,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      bio: entity.bio,
      profileImageUrl: entity.profileImageUrl,
      dateOfBirth: entity.dateOfBirth,
    );
  }
}
