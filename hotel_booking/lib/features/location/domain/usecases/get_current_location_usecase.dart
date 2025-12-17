import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, LocationEntity>> call() async {
    return await repository.getCurrentLocation();
  }
}
