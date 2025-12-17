import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hotel_entity.dart';
import '../repositories/hotel_repository.dart';

class GetHotelsUseCase implements UseCase<List<HotelEntity>, GetHotelsParams> {
  final HotelRepository repository;

  GetHotelsUseCase(this.repository);

  @override
  Future<Either<Failure, List<HotelEntity>>> call(GetHotelsParams params) async {
    return await repository.getHotels(
      limit: params.limit,
      startAfterId: params.startAfterId,
    );
  }
}

class GetHotelsParams extends Equatable {
  final int limit;
  final String? startAfterId;

  const GetHotelsParams({
    required this.limit,
    this.startAfterId,
  });

  @override
  List<Object?> get props => [limit, startAfterId];
}
