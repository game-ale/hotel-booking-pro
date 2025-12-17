import 'package:equatable/equatable.dart';

class AdminBooking extends Equatable {
  final String id;
  final String hotelId;
  final String userId;
  final double totalPrice;
  final DateTime checkIn;
  final DateTime checkOut;
  final String status;
  final DateTime createdAt;

  const AdminBooking({
    required this.id,
    required this.hotelId,
    required this.userId,
    required this.totalPrice,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, hotelId, userId, totalPrice, checkIn, checkOut, status, createdAt];
}
