import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetUserBookingsUseCase implements UseCase<List<BookingEntity>, String> {
  final BookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(String params) async {
    return await repository.getUserBookings(params);
  }
}
