import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, bool>> checkAvailability({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
  });

  Future<Either<Failure, BookingEntity>> createBooking(BookingEntity booking);

  Future<Either<Failure, void>> cancelBooking(String bookingId);

  Future<Either<Failure, List<BookingEntity>>> getUserBookings(String userId);

  Future<Either<Failure, List<BookingEntity>>> getHotelBookings(String hotelId);
}
