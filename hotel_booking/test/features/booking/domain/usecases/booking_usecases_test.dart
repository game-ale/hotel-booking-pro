import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:hotel_booking/features/booking/domain/entities/booking_entity.dart';
import 'package:hotel_booking/features/booking/domain/repositories/booking_repository.dart';
import 'package:hotel_booking/features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:hotel_booking/features/booking/domain/usecases/check_availability_usecase.dart';
import 'package:hotel_booking/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:hotel_booking/features/booking/domain/usecases/get_user_bookings_usecase.dart';

class FakeBookingRepository implements BookingRepository {
  @override
  Future<Either<Failure, bool>> checkAvailability({required String roomId, required DateTime checkIn, required DateTime checkOut}) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, BookingEntity>> createBooking(BookingEntity booking) async {
    return Right(booking);
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(String userId) async {
    return Right([
      BookingEntity(
        id: '1',
        userId: userId,
        hotelId: 'h1',
        roomId: 'r1',
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 1)),
        guestCount: 2,
        totalPrice: 100,
        status: 'confirmed',
        createdAt: DateTime.now(),
      )
    ]);
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getHotelBookings(String hotelId) async {
    return const Right([]);
  }
}

void main() {
  late CheckAvailabilityUseCase checkAvailabilityUseCase;
  late CreateBookingUseCase createBookingUseCase;
  late CancelBookingUseCase cancelBookingUseCase;
  late GetUserBookingsUseCase getUserBookingsUseCase;
  late FakeBookingRepository fakeBookingRepository;

  setUp(() {
    fakeBookingRepository = FakeBookingRepository();
    checkAvailabilityUseCase = CheckAvailabilityUseCase(fakeBookingRepository);
    createBookingUseCase = CreateBookingUseCase(fakeBookingRepository);
    cancelBookingUseCase = CancelBookingUseCase(fakeBookingRepository);
    getUserBookingsUseCase = GetUserBookingsUseCase(fakeBookingRepository);
  });

  final tBooking = BookingEntity(
    id: '1',
    userId: 'u1',
    hotelId: 'h1',
    roomId: 'r1',
    checkIn: DateTime.now(),
    checkOut: DateTime.now().add(const Duration(days: 1)),
    guestCount: 2,
    totalPrice: 100,
    status: 'confirmed',
    createdAt: DateTime.now(),
  );

  group('Booking UseCases', () {
    test('CheckAvailabilityUseCase should return true', () async {
      final result = await checkAvailabilityUseCase(CheckAvailabilityParams(
        roomId: 'r1',
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 1)),
      ));
      expect(result, const Right(true));
    });

    test('CreateBookingUseCase should return created booking', () async {
      final result = await createBookingUseCase(tBooking);
      expect(result, Right(tBooking));
    });

    test('CancelBookingUseCase should return void', () async {
      final result = await cancelBookingUseCase('1');
      expect(result, const Right(null));
    });

    test('GetUserBookingsUseCase should return list of bookings', () async {
      final result = await getUserBookingsUseCase('u1');
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return failure'),
        (r) => expect(r.length, 1),
      );
    });
  });
}
