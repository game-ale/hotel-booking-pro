import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/wallet_repository.dart';

class GetTransactionHistoryUseCase implements UseCase<List<TransactionEntity>, GetTransactionHistoryParams> {
  final WalletRepository repository;

  GetTransactionHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(GetTransactionHistoryParams params) async {
    return await repository.getTransactionHistory(params.userId);
  }
}

class GetTransactionHistoryParams extends Equatable {
  final String userId;

  const GetTransactionHistoryParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
