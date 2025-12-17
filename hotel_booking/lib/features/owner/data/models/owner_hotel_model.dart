import '../../domain/entities/owner_hotel.dart';

class OwnerHotelModel extends OwnerHotel {
  const OwnerHotelModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.location,
    required super.description,
    required super.images,
    required super.amenities,
    required super.status,
    required super.createdAt,
  });

  factory OwnerHotelModel.fromJson(Map<String, dynamic> json) {
    return OwnerHotelModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      status: HotelStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => HotelStatus.draft,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'location': location,
      'description': description,
      'images': images,
      'amenities': amenities,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OwnerHotelModel.fromEntity(OwnerHotel entity) {
    return OwnerHotelModel(
      id: entity.id,
      ownerId: entity.ownerId,
      name: entity.name,
      location: entity.location,
      description: entity.description,
      images: entity.images,
      amenities: entity.amenities,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}
