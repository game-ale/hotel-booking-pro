import 'package:equatable/equatable.dart';

class AdminUser extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String role; // 'user', 'admin'
  final bool isSuspended;

  const AdminUser({
    required this.id,
    required this.email,
    this.displayName,
    required this.role,
    this.isSuspended = false,
  });

  @override
  List<Object?> get props => [id, email, displayName, role, isSuspended];
}
