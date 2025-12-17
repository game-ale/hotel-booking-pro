import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/owner_booking.dart';
import '../repositories/owner_booking_repository.dart';

class GetOwnerBookings {
  final OwnerBookingRepository repository;

  GetOwnerBookings(this.repository);

  Future<Either<Failure, List<OwnerBooking>>> call(String ownerId) async {
    return await repository.getOwnerBookings(ownerId);
  }
}
