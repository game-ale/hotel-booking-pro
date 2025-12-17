import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<bool> checkAvailability({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
  });

  Future<BookingModel> createBooking(BookingModel booking);

  Future<void> cancelBooking(String bookingId);

  Future<List<BookingModel>> getUserBookings(String userId);

  Future<List<BookingModel>> getHotelBookings(String hotelId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;

  BookingRemoteDataSourceImpl({
    required this.firestore,
    required this.functions,
  });

  @override
  Future<bool> checkAvailability({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    // Client-side check for UI feedback (not strict)
    final query = await firestore
        .collection('bookings')
        .where('roomId', isEqualTo: roomId)
        .where('status', isEqualTo: 'confirmed')
        .get();

    for (var doc in query.docs) {
      final data = doc.data();
      final bookedCheckIn = (data['checkIn'] as Timestamp).toDate();
      final bookedCheckOut = (data['checkOut'] as Timestamp).toDate();

      if (checkIn.isBefore(bookedCheckOut) && checkOut.isAfter(bookedCheckIn)) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final callable = functions.httpsCallable('createBooking');
      final result = await callable.call({
        'hotelId': booking.hotelId,
        'roomId': booking.roomId,
        'checkIn': booking.checkIn.toIso8601String(),
        'checkOut': booking.checkOut.toIso8601String(),
        'guestCount': booking.guestCount,
        'totalPrice': booking.totalPrice,
      });

      final bookingId = result.data['bookingId'];
      final doc = await firestore.collection('bookings').doc(bookingId).get();
      return BookingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      final callable = functions.httpsCallable('cancelBooking');
      await callable.call({'bookingId': bookingId});
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final snapshot = await firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user bookings: $e');
    }
  }

  @override
  Future<List<BookingModel>> getHotelBookings(String hotelId) async {
    try {
      final snapshot = await firestore
          .collection('bookings')
          .where('hotelId', isEqualTo: hotelId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch hotel bookings: $e');
    }
  }
}
