import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetPlaceDetailsUseCase {
  final LocationRepository repository;

  GetPlaceDetailsUseCase(this.repository);

  Future<Either<Failure, LocationEntity>> call(String placeId) async {
    return await repository.getPlaceDetails(placeId);
  }
}
