import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.hotelId,
    required super.roomId,
    required super.checkIn,
    required super.checkOut,
    required super.guestCount,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      hotelId: data['hotelId'] ?? '',
      roomId: data['roomId'] ?? '',
      checkIn: (data['checkIn'] as Timestamp).toDate(),
      checkOut: (data['checkOut'] as Timestamp).toDate(),
      guestCount: (data['guestCount'] ?? 0).toInt(),
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'hotelId': hotelId,
      'roomId': roomId,
      'checkIn': Timestamp.fromDate(checkIn),
      'checkOut': Timestamp.fromDate(checkOut),
      'guestCount': guestCount,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      hotelId: entity.hotelId,
      roomId: entity.roomId,
      checkIn: entity.checkIn,
      checkOut: entity.checkOut,
      guestCount: entity.guestCount,
      totalPrice: entity.totalPrice,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}
