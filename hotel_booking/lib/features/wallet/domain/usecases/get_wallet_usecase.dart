import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWalletUseCase implements UseCase<WalletEntity, GetWalletParams> {
  final WalletRepository repository;

  GetWalletUseCase(this.repository);

  @override
  Future<Either<Failure, WalletEntity>> call(GetWalletParams params) async {
    return await repository.getWallet(params.userId);
  }
}

class GetWalletParams extends Equatable {
  final String userId;

  const GetWalletParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
