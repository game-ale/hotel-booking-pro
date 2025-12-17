import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/error/exceptions.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:hotel_booking/features/payments/data/datasources/payment_remote_data_source.dart';
import 'package:hotel_booking/features/payments/data/models/payment_model.dart';
import 'package:hotel_booking/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:hotel_booking/features/payments/domain/entities/payment_entity.dart';
import 'package:hotel_booking/features/payments/domain/entities/payment_status.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'payment_repository_impl_test.mocks.dart';

@GenerateMocks([PaymentRemoteDataSource])
void main() {
  late PaymentRepositoryImpl repository;
  late MockPaymentRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockPaymentRemoteDataSource();
    repository = PaymentRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tPaymentModel = PaymentModel(
    id: 'payment_123',
    bookingId: 'booking_123',
    amount: 100.0,
    currency: 'USD',
    status: PaymentStatus.pending,
    method: 'credit_card',
    timestamp: DateTime.now(),
  );

  final PaymentEntity tPaymentEntity = tPaymentModel;

  group('initiatePayment', () {
    test('should return remote data when the call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.initiatePayment(any))
          .thenAnswer((_) async => tPaymentModel);

      // act
      final result = await repository.initiatePayment(
        bookingId: 'booking_123',
        amount: 100.0,
        currency: 'USD',
        method: 'credit_card',
      );

      // assert
      verify(mockRemoteDataSource.initiatePayment(any));
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.id, tPaymentEntity.id), // Check ID or other props
      );
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.initiatePayment(any))
          .thenThrow(ServerException('Server Error'));

      // act
      final result = await repository.initiatePayment(
        bookingId: 'booking_123',
        amount: 100.0,
        currency: 'USD',
        method: 'credit_card',
      );

      // assert
      verify(mockRemoteDataSource.initiatePayment(any));
      expect(result, Left(ServerFailure('Server Error')));
    });
  });
}
