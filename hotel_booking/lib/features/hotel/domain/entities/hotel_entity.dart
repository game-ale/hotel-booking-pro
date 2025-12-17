import 'package:equatable/equatable.dart';

class HotelEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final double rating;
  final double pricePerNight;
  final List<String> amenities;
  final List<String> images;
  final String description;

  const HotelEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.pricePerNight,
    required this.amenities,
    required this.images,
    required this.description,
  });

  @override
  List<Object> get props => [
        id,
        name,
        location,
        rating,
        pricePerNight,
        amenities,
        images,
        description,
      ];
}
