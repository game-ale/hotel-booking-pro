import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallet_entity.dart';
import '../entities/transaction_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWallet(String userId);
  
  Future<Either<Failure, WalletEntity>> addFunds({
    required String userId,
    required double amount,
    required String currency,
    required String paymentMethodId, // For the funding source
  });

  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistory(String userId);
}
