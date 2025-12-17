import 'package:equatable/equatable.dart';

class SearchFilterEntity extends Equatable {
  final String query;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final List<String>? amenities;

  const SearchFilterEntity({
    this.query = '',
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.amenities,
  });

  @override
  List<Object?> get props => [query, minPrice, maxPrice, minRating, amenities];
}
