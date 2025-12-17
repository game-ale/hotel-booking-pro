import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/hotel_entity.dart';
import '../../domain/entities/search_filter_entity.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../datasources/hotel_remote_data_source.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HotelRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<HotelEntity>>> getHotels({
    required int limit,
    String? startAfterId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final hotels = await remoteDataSource.getHotels(
          limit: limit,
          startAfterId: startAfterId,
        );
        return Right(hotels);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<HotelEntity>>> searchHotels(
    SearchFilterEntity filter,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final hotels = await remoteDataSource.searchHotels(filter);
        return Right(hotels);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, HotelEntity>> getHotelDetails(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final hotel = await remoteDataSource.getHotelDetails(id);
        return Right(hotel);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }
}
