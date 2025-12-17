import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/owner_hotel.dart';
import '../entities/room.dart';

abstract class OwnerHotelRepository {
  Future<Either<Failure, List<OwnerHotel>>> getOwnerHotels(String ownerId);
  Future<Either<Failure, OwnerHotel>> createHotel(OwnerHotel hotel);
  Future<Either<Failure, OwnerHotel>> updateHotel(OwnerHotel hotel);
  Future<Either<Failure, List<Room>>> getRooms(String hotelId);
  Future<Either<Failure, Room>> addRoom(Room room);
  Future<Either<Failure, Room>> updateRoom(Room room);
  Future<Either<Failure, Room>> toggleRoomAvailability(String roomId, bool isAvailable);
}
