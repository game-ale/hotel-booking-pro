import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  
  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentInitiated extends PaymentState {
  final PaymentEntity payment;

  const PaymentInitiated(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentVerified extends PaymentState {
  final PaymentEntity payment;

  const PaymentVerified(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentStatusLoaded extends PaymentState {
  final PaymentEntity payment;

  const PaymentStatusLoaded(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}
