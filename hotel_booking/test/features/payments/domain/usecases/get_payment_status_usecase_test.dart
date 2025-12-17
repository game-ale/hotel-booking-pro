import 'package:fpdart/fpdart.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/payments/domain/entities/payment_entity.dart';
import 'package:hotel_booking/features/payments/domain/entities/payment_status.dart';
import 'package:hotel_booking/features/payments/domain/repositories/payment_repository.dart';
import 'package:hotel_booking/features/payments/domain/usecases/get_payment_status_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_payment_status_usecase_test.mocks.dart';

@GenerateMocks([PaymentRepository])
void main() {
  late GetPaymentStatusUseCase useCase;
  late MockPaymentRepository mockPaymentRepository;

  setUp(() {
    mockPaymentRepository = MockPaymentRepository();
    useCase = GetPaymentStatusUseCase(mockPaymentRepository);
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
  final tPayment = PaymentEntity(
    id: tPaymentId,
    bookingId: 'booking_123',
    amount: 100.0,
    currency: 'USD',
    status: PaymentStatus.pending,
    method: 'credit_card',
    timestamp: DateTime.now(),
  );

  test('should get payment status from the repository', () async {
    // arrange
    when(mockPaymentRepository.getPaymentStatus(tPaymentId))
        .thenAnswer((_) async => Right(tPayment));

    // act
    final result = await useCase(GetPaymentStatusParams(paymentId: tPaymentId));

    // assert
    expect(result, Right(tPayment));
    verify(mockPaymentRepository.getPaymentStatus(tPaymentId));
    verifyNoMoreInteractions(mockPaymentRepository);
  });
}
