import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? address;
  final String? bio;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;

  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.address,
    this.bio,
    this.profileImageUrl,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        phoneNumber,
        address,
        bio,
        profileImageUrl,
        dateOfBirth,
      ];
}
