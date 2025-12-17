import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

class AddFundsUseCase implements UseCase<WalletEntity, AddFundsParams> {
  final WalletRepository repository;

  AddFundsUseCase(this.repository);

  @override
  Future<Either<Failure, WalletEntity>> call(AddFundsParams params) async {
    return await repository.addFunds(
      userId: params.userId,
      amount: params.amount,
      currency: params.currency,
      paymentMethodId: params.paymentMethodId,
    );
  }
}

class AddFundsParams extends Equatable {
  final String userId;
  final double amount;
  final String currency;
  final String paymentMethodId;

  const AddFundsParams({
    required this.userId,
    required this.amount,
    required this.currency,
    required this.paymentMethodId,
  });

  @override
  List<Object?> get props => [userId, amount, currency, paymentMethodId];
}
