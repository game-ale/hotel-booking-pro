import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class CheckAvailabilityUseCase implements UseCase<bool, CheckAvailabilityParams> {
  final BookingRepository repository;

  CheckAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckAvailabilityParams params) async {
    return await repository.checkAvailability(
      roomId: params.roomId,
      checkIn: params.checkIn,
      checkOut: params.checkOut,
    );
  }
}

class CheckAvailabilityParams extends Equatable {
  final String roomId;
  final DateTime checkIn;
  final DateTime checkOut;

  const CheckAvailabilityParams({
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  List<Object> get props => [roomId, checkIn, checkOut];
}
