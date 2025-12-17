import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_status.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.bookingId,
    required super.amount,
    required super.currency,
    required super.status,
    required super.method,
    required super.timestamp,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      method: json['method'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'amount': amount,
      'currency': currency,
      'status': status.toString().split('.').last,
      'method': method,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
