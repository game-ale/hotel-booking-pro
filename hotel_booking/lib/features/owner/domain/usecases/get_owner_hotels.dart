import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/owner_hotel.dart';
import '../repositories/owner_hotel_repository.dart';

class GetOwnerHotels {
  final OwnerHotelRepository repository;

  GetOwnerHotels(this.repository);

  Future<Either<Failure, List<OwnerHotel>>> call(String ownerId) async {
    return await repository.getOwnerHotels(ownerId);
  }
}
