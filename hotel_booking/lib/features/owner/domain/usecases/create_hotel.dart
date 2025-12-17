import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/owner_hotel.dart';
import '../repositories/owner_hotel_repository.dart';

class CreateHotel {
  final OwnerHotelRepository repository;

  CreateHotel(this.repository);

  Future<Either<Failure, OwnerHotel>> call(OwnerHotel hotel) async {
    return await repository.createHotel(hotel);
  }
}
