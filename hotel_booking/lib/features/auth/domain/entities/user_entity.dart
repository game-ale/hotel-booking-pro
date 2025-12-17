import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, email, name, profileImage];
}
