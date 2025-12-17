import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/room.dart';
import '../repositories/owner_hotel_repository.dart';

class UpdateRoom {
  final OwnerHotelRepository repository;

  UpdateRoom(this.repository);

  Future<Either<Failure, Room>> call(Room room) async {
    return await repository.updateRoom(room);
  }
}
