import '../../domain/entities/owner_booking.dart';

class OwnerBookingModel extends OwnerBooking {
  const OwnerBookingModel({
    required super.id,
    required super.hotelId,
    required super.userId,
    required super.roomId,
    required super.userName,
    required super.checkIn,
    required super.checkOut,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
  });

  factory OwnerBookingModel.fromJson(Map<String, dynamic> json) {
    return OwnerBookingModel(
      id: json['id'] as String,
      hotelId: json['hotelId'] as String,
      userId: json['userId'] as String,
      roomId: json['roomId'] as String,
      userName: json['userName'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'userId': userId,
      'roomId': roomId,
      'userName': userName,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
