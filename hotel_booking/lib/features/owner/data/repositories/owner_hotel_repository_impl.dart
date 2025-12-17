import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/owner_hotel.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/owner_hotel_repository.dart';
import '../datasources/owner_remote_data_source.dart';
import '../models/owner_hotel_model.dart';
import '../models/room_model.dart';

class OwnerHotelRepositoryImpl implements OwnerHotelRepository {
  final OwnerRemoteDataSource remoteDataSource;

  OwnerHotelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OwnerHotel>>> getOwnerHotels(String ownerId) async {
    try {
      final result = await remoteDataSource.getOwnerHotels(ownerId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OwnerHotel>> createHotel(OwnerHotel hotel) async {
    try {
      final model = OwnerHotelModel.fromEntity(hotel);
      final result = await remoteDataSource.createHotel(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OwnerHotel>> updateHotel(OwnerHotel hotel) async {
    try {
      final model = OwnerHotelModel.fromEntity(hotel);
      final result = await remoteDataSource.updateHotel(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Room>>> getRooms(String hotelId) async {
    try {
      final result = await remoteDataSource.getRooms(hotelId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> addRoom(Room room) async {
    try {
      final model = RoomModel.fromEntity(room);
      final result = await remoteDataSource.addRoom(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> updateRoom(Room room) async {
    try {
      final model = RoomModel.fromEntity(room);
      final result = await remoteDataSource.updateRoom(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> toggleRoomAvailability(String roomId, bool isAvailable) async {
    try {
      final result = await remoteDataSource.toggleRoomAvailability(roomId, isAvailable);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
