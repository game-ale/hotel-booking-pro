import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/admin_booking.dart';
import '../../domain/entities/admin_hotel.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AdminUser>>> getAllUsers() async {
    try {
      final users = await remoteDataSource.getAllUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> suspendUser(String userId, bool isSuspended) async {
    try {
      await remoteDataSource.suspendUser(userId, isSuspended);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminHotel>>> getAllHotels({bool? pendingOnly}) async {
    try {
      final hotels = await remoteDataSource.getAllHotels(pendingOnly: pendingOnly);
      return Right(hotels);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveHotel(String hotelId, bool isApproved) async {
    try {
      await remoteDataSource.approveHotel(hotelId, isApproved);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminBooking>>> getAllBookings() async {
    try {
      final bookings = await remoteDataSource.getAllBookings();
      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AnalyticsSummary>> getAnalyticsSummary() async {
    try {
      // Client-side aggregation for MVP
      final bookings = await remoteDataSource.getAllBookings();
      final users = await remoteDataSource.getAllUsers();
      final hotels = await remoteDataSource.getAllHotels();

      double totalRevenue = 0;
      for (var b in bookings) {
        totalRevenue += b.totalPrice;
      }

      final summary = AnalyticsSummary(
        totalRevenue: totalRevenue,
        totalBookings: bookings.length,
        activeUsers: users.length, // Simplified
        totalHotels: hotels.length,
      );
      
      return Right(summary);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
