import 'package:fpdart/fpdart.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/wallet/domain/entities/wallet_entity.dart';
import 'package:hotel_booking/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hotel_booking/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_wallet_usecase_test.mocks.dart';

@GenerateMocks([WalletRepository])
void main() {
  late GetWalletUseCase useCase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    useCase = GetWalletUseCase(mockWalletRepository);
    provideDummy<Either<Failure, WalletEntity>>(Right(WalletEntity(
      userId: 'dummy',
      balance: 0,
      currency: 'dummy',
    )));
  });

  final tUserId = 'user_123';
  final tWallet = WalletEntity(
    userId: tUserId,
    balance: 100.0,
    currency: 'USD',
  );

  test('should get wallet from the repository', () async {
    // arrange
    when(mockWalletRepository.getWallet(tUserId))
        .thenAnswer((_) async => Right(tWallet));

    // act
    final result = await useCase(GetWalletParams(userId: tUserId));

    // assert
    expect(result, Right(tWallet));
    verify(mockWalletRepository.getWallet(tUserId));
    verifyNoMoreInteractions(mockWalletRepository);
  });
}
