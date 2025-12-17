import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase implements UseCase<BookingEntity, BookingEntity> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(BookingEntity params) async {
    return await repository.createBooking(params);
  }
}
