import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentEntity>> initiatePayment({
    required String bookingId,
    required double amount,
    required String currency,
    required String method,
  });

  Future<Either<Failure, PaymentEntity>> verifyPayment(String paymentId);
  
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String paymentId);
}
