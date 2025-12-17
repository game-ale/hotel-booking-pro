import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [latitude, longitude, address, city, country];
}
