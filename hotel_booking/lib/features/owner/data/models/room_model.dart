import '../../domain/entities/room.dart';

class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.hotelId,
    required super.name,
    required super.description,
    required super.price,
    required super.capacity,
    required super.amenities,
    required super.images,
    required super.isAvailable,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      hotelId: json['hotelId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      capacity: json['capacity'] as int,
      amenities: List<String>.from(json['amenities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['isAvailable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'name': name,
      'description': description,
      'price': price,
      'capacity': capacity,
      'amenities': amenities,
      'images': images,
      'isAvailable': isAvailable,
    };
  }

  factory RoomModel.fromEntity(Room entity) {
    return RoomModel(
      id: entity.id,
      hotelId: entity.hotelId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      capacity: entity.capacity,
      amenities: entity.amenities,
      images: entity.images,
      isAvailable: entity.isAvailable,
    );
  }
}
