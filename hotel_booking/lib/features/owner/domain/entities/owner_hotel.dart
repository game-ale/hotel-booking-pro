import 'package:equatable/equatable.dart';

enum HotelStatus { active, draft, maintenance }

class OwnerHotel extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String location;
  final String description;
  final List<String> images;
  final List<String> amenities;
  final HotelStatus status;
  final DateTime createdAt;

  const OwnerHotel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.location,
    required this.description,
    required this.images,
    required this.amenities,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        location,
        description,
        images,
        amenities,
        status,
        createdAt,
      ];
}
