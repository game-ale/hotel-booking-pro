import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String hotelId;
  final String name;
  final String description;
  final double price;
  final int capacity;
  final List<String> amenities;
  final List<String> images;
  final bool isAvailable;

  const Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.price,
    required this.capacity,
    required this.amenities,
    required this.images,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
        id,
        hotelId,
        name,
        description,
        price,
        capacity,
        amenities,
        images,
        isAvailable,
      ];
}
