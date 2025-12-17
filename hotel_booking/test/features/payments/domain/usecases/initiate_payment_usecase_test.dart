import 'package:fpdart/fpdart.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/payments/domain/entities/payment_entity.dart';
import 'package:hotel_booking/features/payments/domain/entities/payment_status.dart';
import 'package:hotel_booking/features/payments/domain/repositories/payment_repository.dart';
import 'package:hotel_booking/features/payments/domain/usecases/initiate_payment_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'initiate_payment_usecase_test.mocks.dart';

@GenerateMocks([PaymentRepository])
void main() {
  late InitiatePaymentUseCase useCase;
  late MockPaymentRepository mockPaymentRepository;

  setUp(() {
    mockPaymentRepository = MockPaymentRepository();
    useCase = InitiatePaymentUseCase(mockPaymentRepository);
    provideDummy<Either<Failure, PaymentEntity>>(Right(PaymentEntity(
      id: 'dummy',
      bookingId: 'dummy',
      amount: 0,
      currency: 'dummy',
      status: PaymentStatus.pending,
      method: 'dummy',
      timestamp: DateTime.now(),
    )));
  });

  final tPaymentId = 'payment_123';
  final tBookingId = 'booking_123';
  final tAmount = 100.0;
  final tCurrency = 'USD';
  final tMethod = 'credit_card';
  final tPayment = PaymentEntity(
    id: tPaymentId,
    bookingId: tBookingId,
    amount: tAmount,
    currency: tCurrency,
    status: PaymentStatus.pending,
    method: tMethod,
    timestamp: DateTime.now(),
  );

  test('should get payment entity from the repository', () async {
    // arrange
    when(mockPaymentRepository.initiatePayment(
      bookingId: tBookingId,
      amount: tAmount,
      currency: tCurrency,
      method: tMethod,
    )).thenAnswer((_) async => Right(tPayment));

    // act
    final result = await useCase(InitiatePaymentParams(
      bookingId: tBookingId,
      amount: tAmount,
      currency: tCurrency,
      method: tMethod,
    ));
    
    // assert
    expect(result.isRight(), true);
    result.fold(
      (l) => fail('Expected Right, got Left $l'),
      (r) => expect(r, tPayment),
    );
    verify(mockPaymentRepository.initiatePayment(
      bookingId: tBookingId,
      amount: tAmount,
      currency: tCurrency,
      method: tMethod,
    ));
    verifyNoMoreInteractions(mockPaymentRepository);
  });
}
