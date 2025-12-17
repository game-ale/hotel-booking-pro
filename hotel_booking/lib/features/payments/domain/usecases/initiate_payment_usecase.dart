import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class InitiatePaymentUseCase implements UseCase<PaymentEntity, InitiatePaymentParams> {
  final PaymentRepository repository;

  InitiatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(InitiatePaymentParams params) async {
    return await repository.initiatePayment(
      bookingId: params.bookingId,
      amount: params.amount,
      currency: params.currency,
      method: params.method,
    );
  }
}

class InitiatePaymentParams extends Equatable {
  final String bookingId;
  final double amount;
  final String currency;
  final String method;

  const InitiatePaymentParams({
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.method,
  });

  @override
  List<Object?> get props => [bookingId, amount, currency, method];
}
