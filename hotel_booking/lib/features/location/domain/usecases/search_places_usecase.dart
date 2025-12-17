import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/place_suggestion.dart';
import '../repositories/location_repository.dart';

class SearchPlacesUseCase {
  final LocationRepository repository;

  SearchPlacesUseCase(this.repository);

  Future<Either<Failure, List<PlaceSuggestion>>> call(String query) async {
    return await repository.searchPlaces(query);
  }
}
