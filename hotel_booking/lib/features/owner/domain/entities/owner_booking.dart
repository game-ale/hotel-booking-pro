import 'package:equatable/equatable.dart';

enum BookingStatus { confirmed, cancelled, completed }

class OwnerBooking extends Equatable {
  final String id;
  final String hotelId;
  final String userId;
  final String roomId;
  final String userName; // Denormalized for easy display
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;

  const OwnerBooking({
    required this.id,
    required this.hotelId,
    required this.userId,
    required this.roomId,
    required this.userName,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        hotelId,
        userId,
        roomId,
        userName,
        checkIn,
        checkOut,
        totalPrice,
        status,
        createdAt,
      ];
}
