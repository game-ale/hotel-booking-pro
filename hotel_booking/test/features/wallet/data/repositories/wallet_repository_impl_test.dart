import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/error/exceptions.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:hotel_booking/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:hotel_booking/features/wallet/data/models/wallet_model.dart';
import 'package:hotel_booking/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:hotel_booking/features/wallet/domain/entities/wallet_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wallet_repository_impl_test.mocks.dart';

@GenerateMocks([WalletRemoteDataSource])
void main() {
  late WalletRepositoryImpl repository;
  late MockWalletRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockWalletRemoteDataSource();
    repository = WalletRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tWalletModel = WalletModel(
    userId: 'user_123',
    balance: 100.0,
    currency: 'USD',
  );

  final WalletEntity tWalletEntity = tWalletModel;

  group('getWallet', () {
    test('should return remote data when the call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getWallet(any))
          .thenAnswer((_) async => tWalletModel);

      // act
      final result = await repository.getWallet('user_123');

      // assert
      verify(mockRemoteDataSource.getWallet('user_123'));
      expect(result, Right(tWalletEntity));
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getWallet(any))
          .thenThrow(ServerException('Server Error'));

      // act
      final result = await repository.getWallet('user_123');

      // assert
      verify(mockRemoteDataSource.getWallet('user_123'));
      expect(result, Left(ServerFailure('Server Error')));
    });
  });
}
