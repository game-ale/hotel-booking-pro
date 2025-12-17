import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.timestamp,
    required super.description,
    super.referenceId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.credit,
      ),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      description: json['description'] as String,
      referenceId: json['referenceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
      'description': description,
      'referenceId': referenceId,
    };
  }
}
