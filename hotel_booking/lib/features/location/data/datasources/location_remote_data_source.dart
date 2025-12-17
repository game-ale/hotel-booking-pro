import '../models/location_model.dart';
import '../models/place_suggestion_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<PlaceSuggestionModel>> searchPlaces(String query);
  Future<LocationModel> getPlaceDetails(String placeId);
  Future<LocationModel> getAddressFromCoordinates(double lat, double lng);
}
