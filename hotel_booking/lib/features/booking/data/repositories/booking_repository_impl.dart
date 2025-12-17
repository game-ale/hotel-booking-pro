import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> checkAvailability({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.checkAvailability(
          roomId: roomId,
          checkIn: checkIn,
          checkOut: checkOut,
        );
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> createBooking(BookingEntity booking) async {
    if (await networkInfo.isConnected) {
      try {
        final bookingModel = BookingModel.fromEntity(booking);
        final result = await remoteDataSource.createBooking(bookingModel);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.cancelBooking(bookingId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUserBookings(userId);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getHotelBookings(String hotelId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getHotelBookings(hotelId);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }
}
