import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/admin_booking.dart';
import '../../domain/entities/admin_hotel.dart';
import '../../domain/entities/admin_user.dart';

class AdminUserModel extends AdminUser {
  const AdminUserModel({
    required super.id,
    required super.email,
    super.displayName,
    required super.role,
    super.isSuspended,
  });

  factory AdminUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminUserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      role: data['role'] ?? 'user',
      isSuspended: data['isSuspended'] ?? false,
    );
  }
}

class AdminHotelModel extends AdminHotel {
  const AdminHotelModel({
    required super.id,
    required super.name,
    required super.ownerId,
    required super.address,
    super.isApproved,
  });

  factory AdminHotelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminHotelModel(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      address: data['address'] ?? '',
      isApproved: data['isApproved'] ?? false,
    );
  }
}

class AdminBookingModel extends AdminBooking {
  const AdminBookingModel({
    required super.id,
    required super.hotelId,
    required super.userId,
    required super.totalPrice,
    required super.checkIn,
    required super.checkOut,
    required super.status,
    required super.createdAt,
  });

  factory AdminBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminBookingModel(
      id: doc.id,
      hotelId: data['hotelId'] ?? '',
      userId: data['userId'] ?? '',
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      checkIn: (data['checkIn'] as Timestamp).toDate(),
      checkOut: (data['checkOut'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
