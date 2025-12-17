import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin_hotel.dart';
import '../repositories/admin_repository.dart';

class GetAllHotelsUseCase {
  final AdminRepository repository;
  GetAllHotelsUseCase(this.repository);
  Future<Either<Failure, List<AdminHotel>>> call({bool? pendingOnly}) => 
      repository.getAllHotels(pendingOnly: pendingOnly);
}

class ApproveHotelUseCase {
  final AdminRepository repository;
  ApproveHotelUseCase(this.repository);
  Future<Either<Failure, void>> call(String hotelId, bool isApproved) => 
      repository.approveHotel(hotelId, isApproved);
}
