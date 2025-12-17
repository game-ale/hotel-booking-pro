import 'package:fpdart/fpdart.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/wallet/domain/entities/wallet_entity.dart';
import 'package:hotel_booking/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hotel_booking/features/wallet/domain/usecases/add_funds_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_funds_usecase_test.mocks.dart';

@GenerateMocks([WalletRepository])
void main() {
  late AddFundsUseCase useCase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    useCase = AddFundsUseCase(mockWalletRepository);
    provideDummy<Either<Failure, WalletEntity>>(Right(WalletEntity(
      userId: 'dummy',
      balance: 0,
      currency: 'dummy',
    )));
  });

  final tUserId = 'user_123';
  final tAmount = 50.0;
  final tCurrency = 'USD';
  final tPaymentMethodId = 'pm_123';
  final tWallet = WalletEntity(
    userId: tUserId,
    balance: 150.0, // 100 + 50
    currency: 'USD',
  );

  test('should add funds using the repository', () async {
    // arrange
    when(mockWalletRepository.addFunds(
      userId: tUserId,
      amount: tAmount,
      currency: tCurrency,
      paymentMethodId: tPaymentMethodId,
    )).thenAnswer((_) async => Right(tWallet));

    // act
    final result = await useCase(AddFundsParams(
      userId: tUserId,
      amount: tAmount,
      currency: tCurrency,
      paymentMethodId: tPaymentMethodId,
    ));

    // assert
    expect(result, Right(tWallet));
    verify(mockWalletRepository.addFunds(
      userId: tUserId,
      amount: tAmount,
      currency: tCurrency,
      paymentMethodId: tPaymentMethodId,
    ));
    verifyNoMoreInteractions(mockWalletRepository);
  });
}
