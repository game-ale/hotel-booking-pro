import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/location_entity.dart';
import '../entities/place_suggestion.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
  Future<Either<Failure, List<PlaceSuggestion>>> searchPlaces(String query);
  Future<Either<Failure, LocationEntity>> getPlaceDetails(String placeId);
  Future<Either<Failure, LocationEntity>> getAddressFromCoordinates(double lat, double lng);
}
