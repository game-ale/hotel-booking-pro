import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/hotel_entity.dart';
import '../entities/search_filter_entity.dart';

abstract class HotelRepository {
  Future<Either<Failure, List<HotelEntity>>> getHotels({
    required int limit,
    String? startAfterId,
  });

  Future<Either<Failure, List<HotelEntity>>> searchHotels(
    SearchFilterEntity filter,
  );

  Future<Either<Failure, HotelEntity>> getHotelDetails(String id);
}
