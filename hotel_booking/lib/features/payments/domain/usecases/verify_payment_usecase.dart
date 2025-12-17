import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class VerifyPaymentUseCase implements UseCase<PaymentEntity, VerifyPaymentParams> {
  final PaymentRepository repository;

  VerifyPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(VerifyPaymentParams params) async {
    return await repository.verifyPayment(params.paymentId);
  }
}

class VerifyPaymentParams extends Equatable {
  final String paymentId;

  const VerifyPaymentParams({required this.paymentId});

  @override
  List<Object?> get props => [paymentId];
}
