import 'package:equatable/equatable.dart';

class AdminHotel extends Equatable {
  final String id;
  final String name;
  final String ownerId;
  final String address;
  final bool isApproved;

  const AdminHotel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.address,
    this.isApproved = false,
  });

  @override
  List<Object?> get props => [id, name, ownerId, address, isApproved];
}
