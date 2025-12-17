import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/search_filter_entity.dart';
import '../models/hotel_model.dart';

abstract class HotelRemoteDataSource {
  /// Get paginated list of hotels
  /// [limit] - Number of hotels to fetch
  /// [startAfterId] - Document ID to start after (for pagination)
  Future<List<HotelModel>> getHotels({
    required int limit,
    String? startAfterId,
  });

  /// Search hotels with filters
  Future<List<HotelModel>> searchHotels(SearchFilterEntity filter);

  /// Get hotel details by ID
  Future<HotelModel> getHotelDetails(String id);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final FirebaseFirestore firestore;

  HotelRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<HotelModel>> getHotels({
    required int limit,
    String? startAfterId,
  }) async {
    try {
      Query query = firestore.collection('hotels').orderBy('name').limit(limit);

      // If we have a startAfterId, fetch that document and use it as cursor
      if (startAfterId != null) {
        final startAfterDoc =
            await firestore.collection('hotels').doc(startAfterId).get();
        if (startAfterDoc.exists) {
          query = query.startAfterDocument(startAfterDoc);
        }
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => HotelModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch hotels: $e');
    }
  }

  @override
  Future<List<HotelModel>> searchHotels(SearchFilterEntity filter) async {
    try {
      Query query = firestore.collection('hotels');

      // Apply filters
      if (filter.minPrice != null) {
        query = query.where('pricePerNight', isGreaterThanOrEqualTo: filter.minPrice);
      }
      if (filter.maxPrice != null) {
        query = query.where('pricePerNight', isLessThanOrEqualTo: filter.maxPrice);
      }
      if (filter.minRating != null) {
        query = query.where('rating', isGreaterThanOrEqualTo: filter.minRating);
      }
      if (filter.amenities != null && filter.amenities!.isNotEmpty) {
        query = query.where('amenities', arrayContainsAny: filter.amenities);
      }

      final snapshot = await query.get();
      var results = snapshot.docs.map((doc) => HotelModel.fromFirestore(doc)).toList();

      // Apply text search filter (client-side since Firestore doesn't support full-text search)
      if (filter.query.isNotEmpty) {
        results = results.where((hotel) {
          final lowerQuery = filter.query.toLowerCase();
          return hotel.name.toLowerCase().contains(lowerQuery) ||
              hotel.location.toLowerCase().contains(lowerQuery) ||
              hotel.description.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search hotels: $e');
    }
  }

  @override
  Future<HotelModel> getHotelDetails(String id) async {
    try {
      final doc = await firestore.collection('hotels').doc(id).get();
      if (!doc.exists) {
        throw Exception('Hotel not found');
      }
      return HotelModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch hotel details: $e');
    }
  }
}
