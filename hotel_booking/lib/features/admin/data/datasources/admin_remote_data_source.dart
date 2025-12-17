import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_models.dart';
import '../../domain/entities/analytics_summary.dart';

abstract class AdminRemoteDataSource {
  Future<List<AdminUserModel>> getAllUsers();
  Future<void> suspendUser(String userId, bool isSuspended);
  
  Future<List<AdminHotelModel>> getAllHotels({bool? pendingOnly});
  Future<void> approveHotel(String hotelId, bool isApproved);
  
  Future<List<AdminBookingModel>> getAllBookings();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final FirebaseFirestore firestore;

  AdminRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AdminUserModel>> getAllUsers() async {
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs.map((doc) => AdminUserModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> suspendUser(String userId, bool isSuspended) async {
    await firestore.collection('users').doc(userId).update({'isSuspended': isSuspended});
  }

  @override
  Future<List<AdminHotelModel>> getAllHotels({bool? pendingOnly}) async {
    Query query = firestore.collection('hotels');
    if (pendingOnly == true) {
      query = query.where('isApproved', isEqualTo: false);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => AdminHotelModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> approveHotel(String hotelId, bool isApproved) async {
    await firestore.collection('hotels').doc(hotelId).update({'isApproved': isApproved});
  }

  @override
  Future<List<AdminBookingModel>> getAllBookings() async {
    // Caution: Full collection scan. In prod, use pagination or aggregation function.
    final snapshot = await firestore.collection('bookings').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => AdminBookingModel.fromFirestore(doc)).toList();
  }
}
