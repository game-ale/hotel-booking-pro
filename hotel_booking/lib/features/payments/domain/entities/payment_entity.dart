import 'package:equatable/equatable.dart';
import 'payment_status.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String bookingId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String method;
  final DateTime timestamp;

  const PaymentEntity({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        bookingId,
        amount,
        currency,
        status,
        method,
        timestamp,
      ];
}
