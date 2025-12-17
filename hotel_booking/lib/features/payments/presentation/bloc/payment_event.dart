import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final String bookingId;
  final double amount;
  final String currency;
  final String method;

  const InitiatePaymentEvent({
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.method,
  });

  @override
  List<Object> get props => [bookingId, amount, currency, method];
}

class VerifyPaymentEvent extends PaymentEvent {
  final String paymentId;

  const VerifyPaymentEvent({required this.paymentId});

  @override
  List<Object> get props => [paymentId];
}

class GetPaymentStatusEvent extends PaymentEvent {
  final String paymentId;

  const GetPaymentStatusEvent({required this.paymentId});

  @override
  List<Object> get props => [paymentId];
}
