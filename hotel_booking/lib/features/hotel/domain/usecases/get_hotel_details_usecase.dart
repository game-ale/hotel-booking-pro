import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hotel_entity.dart';
import '../repositories/hotel_repository.dart';

class GetHotelDetailsUseCase implements UseCase<HotelEntity, String> {
  final HotelRepository repository;

  GetHotelDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, HotelEntity>> call(String params) async {
    return await repository.getHotelDetails(params);
  }
}
