import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/room.dart';
import '../repositories/owner_hotel_repository.dart';

class ToggleRoomAvailability {
  final OwnerHotelRepository repository;

  ToggleRoomAvailability(this.repository);

  Future<Either<Failure, Room>> call(String roomId, bool isAvailable) async {
    return await repository.toggleRoomAvailability(roomId, isAvailable);
  }
}
