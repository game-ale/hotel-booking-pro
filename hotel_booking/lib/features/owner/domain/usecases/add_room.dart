import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/room.dart';
import '../repositories/owner_hotel_repository.dart';

class AddRoom {
  final OwnerHotelRepository repository;

  AddRoom(this.repository);

  Future<Either<Failure, Room>> call(Room room) async {
    return await repository.addRoom(room);
  }
}
