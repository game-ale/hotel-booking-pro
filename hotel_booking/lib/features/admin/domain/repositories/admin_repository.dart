import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin_user.dart';
import '../entities/admin_hotel.dart';
import '../entities/admin_booking.dart';
import '../entities/analytics_summary.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<AdminUser>>> getAllUsers();
  Future<Either<Failure, void>> suspendUser(String userId, bool isSuspended);
  
  Future<Either<Failure, List<AdminHotel>>> getAllHotels({bool? pendingOnly});
  Future<Either<Failure, void>> approveHotel(String hotelId, bool isApproved);
  
  Future<Either<Failure, List<AdminBooking>>> getAllBookings();
  
  Future<Either<Failure, AnalyticsSummary>> getAnalyticsSummary();
}
