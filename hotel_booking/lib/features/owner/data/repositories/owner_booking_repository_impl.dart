import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/owner_booking.dart';
import '../../domain/entities/revenue_summary.dart';
import '../../domain/repositories/owner_booking_repository.dart';
import '../datasources/owner_remote_data_source.dart';

class OwnerBookingRepositoryImpl implements OwnerBookingRepository {
  final OwnerRemoteDataSource remoteDataSource;

  OwnerBookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OwnerBooking>>> getOwnerBookings(String ownerId) async {
    try {
      final result = await remoteDataSource.getOwnerBookings(ownerId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RevenueSummary>> getRevenueSummary(String ownerId, DateTime start, DateTime end) async {
    try {
      final result = await remoteDataSource.getRevenueSummary(ownerId, start, end);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
