import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/owner_booking.dart';
import '../entities/revenue_summary.dart';

abstract class OwnerBookingRepository {
  Future<Either<Failure, List<OwnerBooking>>> getOwnerBookings(String ownerId);
  Future<Either<Failure, RevenueSummary>> getRevenueSummary(String ownerId, DateTime start, DateTime end);
}
