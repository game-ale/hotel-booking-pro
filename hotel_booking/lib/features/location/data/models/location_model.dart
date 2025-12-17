import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.address,
    super.city,
    super.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // Basic Google Geocoding API response parsing adaptation
    // This assumes simplified structure or internal use.
    // Real implementation depends on the specific API response structure (Google vs native).
    return LocationModel(
      latitude: json['lat'] as double,
      longitude: json['lng'] as double,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      'address': address,
      'city': city,
      'country': country,
    };
  }

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      city: entity.city,
      country: entity.country,
    );
  }
}
