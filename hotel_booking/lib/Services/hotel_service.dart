import 'package:cloud_firestore/cloud_firestore.dart';

class HotelService {
  final CollectionReference hotelsCollection =
      FirebaseFirestore.instance.collection('hotels');

  Future<bool> addHotel({
    required String hotelName,
    required double roomCharge,
    required String address,
    required String description,
    required Map<String, bool> services,
    required String imageUrl,
    required String ownerId,
  }) async {
    try {
      await hotelsCollection.add({
        'hotelName': hotelName,
        'roomCharge': roomCharge,
        'address': address,
        'description': description,
        'services': services,
        'imageUrl': imageUrl,
        'ownerId': ownerId,
        'rating': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error adding hotel: $e');
      return false;
    }
  }
}
