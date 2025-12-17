import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> initiatePayment(PaymentModel payment);
  Future<PaymentModel> verifyPayment(String paymentId);
  Future<PaymentModel> getPaymentStatus(String paymentId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFirestore firestore;

  PaymentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<PaymentModel> initiatePayment(PaymentModel payment) async {
    await firestore.collection('payments').doc(payment.id).set(payment.toJson());
    return payment;
  }

  @override
  Future<PaymentModel> verifyPayment(String paymentId) async {
    // In a real app, this would call a cloud function or payment gateway API
    // Here we simulate verification by updating status to completed
    final docRef = firestore.collection('payments').doc(paymentId);
    await docRef.update({'status': 'completed'});
    
    final doc = await docRef.get();
    if (doc.exists) {
      return PaymentModel.fromJson(doc.data()!);
    } else {
      throw Exception('Payment not found');
    }
  }

  @override
  Future<PaymentModel> getPaymentStatus(String paymentId) async {
    final doc = await firestore.collection('payments').doc(paymentId).get();
    if (doc.exists) {
      return PaymentModel.fromJson(doc.data()!);
    } else {
      throw Exception('Payment not found');
    }
  }
}
