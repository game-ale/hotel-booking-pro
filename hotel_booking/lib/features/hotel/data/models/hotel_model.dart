import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/hotel_entity.dart';

class HotelModel extends HotelEntity {
  const HotelModel({
    required super.id,
    required super.name,
    required super.location,
    required super.rating,
    required super.pricePerNight,
    required super.amenities,
    required super.images,
    required super.description,
  });

  /// Convert Firestore DocumentSnapshot to HotelModel
  factory HotelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HotelModel(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      pricePerNight: (data['pricePerNight'] ?? 0.0).toDouble(),
      amenities: List<String>.from(data['amenities'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      description: data['description'] ?? '',
    );
  }

  /// Convert HotelModel to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'rating': rating,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'images': images,
      'description': description,
    };
  }

  /// Convert from Entity to Model
  factory HotelModel.fromEntity(HotelEntity entity) {
    return HotelModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      rating: entity.rating,
      pricePerNight: entity.pricePerNight,
      amenities: entity.amenities,
      images: entity.images,
      description: entity.description,
    );
  }
}
