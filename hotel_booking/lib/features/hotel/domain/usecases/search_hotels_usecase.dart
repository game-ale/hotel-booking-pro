import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hotel_entity.dart';
import '../entities/search_filter_entity.dart';
import '../repositories/hotel_repository.dart';

class SearchHotelsUseCase implements UseCase<List<HotelEntity>, SearchFilterEntity> {
  final HotelRepository repository;

  SearchHotelsUseCase(this.repository);

  @override
  Future<Either<Failure, List<HotelEntity>>> call(SearchFilterEntity params) async {
    return await repository.searchHotels(params);
  }
}
