import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String userId;
  final String hotelId;
  final String roomId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guestCount;
  final double totalPrice;
  final String status; // 'confirmed', 'cancelled', 'pending'
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.guestCount,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        hotelId,
        roomId,
        checkIn,
        checkOut,
        guestCount,
        totalPrice,
        status,
        createdAt,
      ];
}
