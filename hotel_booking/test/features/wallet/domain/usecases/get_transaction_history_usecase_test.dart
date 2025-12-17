import 'package:fpdart/fpdart.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/wallet/domain/entities/transaction_entity.dart';
import 'package:hotel_booking/features/wallet/domain/entities/transaction_type.dart';
import 'package:hotel_booking/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hotel_booking/features/wallet/domain/usecases/get_transaction_history_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_transaction_history_usecase_test.mocks.dart';

@GenerateMocks([WalletRepository])
void main() {
  late GetTransactionHistoryUseCase useCase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    useCase = GetTransactionHistoryUseCase(mockWalletRepository);
    provideDummy<Either<Failure, List<TransactionEntity>>>(Right([]));
  });

  final tUserId = 'user_123';
  final tTransactions = [
    TransactionEntity(
      id: 'tx_1',
      amount: 50.0,
      type: TransactionType.credit,
      timestamp: DateTime.now(),
      description: 'Add funds',
    ),
  ];

  test('should get transaction history from the repository', () async {
    // arrange
    when(mockWalletRepository.getTransactionHistory(tUserId))
        .thenAnswer((_) async => Right(tTransactions));

    // act
    final result = await useCase(GetTransactionHistoryParams(userId: tUserId));

    // assert
    expect(result, Right(tTransactions));
    verify(mockWalletRepository.getTransactionHistory(tUserId));
    verifyNoMoreInteractions(mockWalletRepository);
  });
}
