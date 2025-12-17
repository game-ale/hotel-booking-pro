import 'package:equatable/equatable.dart';
import 'transaction_type.dart';

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;
  final String description;
  final String? referenceId; // e.g., bookingId or paymentId

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.timestamp,
    required this.description,
    this.referenceId,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        type,
        timestamp,
        description,
        referenceId,
      ];
}
