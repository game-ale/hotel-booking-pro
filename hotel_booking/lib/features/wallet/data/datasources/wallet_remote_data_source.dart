import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction_type.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet(String userId);
  Future<WalletModel> addFunds(String userId, double amount, String currency, String paymentMethodId);
  Future<List<TransactionModel>> getTransactionHistory(String userId);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore firestore;

  WalletRemoteDataSourceImpl({required this.firestore});

  @override
  Future<WalletModel> getWallet(String userId) async {
    final doc = await firestore.collection('wallets').doc(userId).get();
    if (doc.exists) {
      return WalletModel.fromJson(doc.data()!);
    } else {
      // Create empty wallet if not exists
      final newWallet = WalletModel(userId: userId, balance: 0.0, currency: 'USD');
      await firestore.collection('wallets').doc(userId).set(newWallet.toJson());
      return newWallet;
    }
  }

  @override
  Future<WalletModel> addFunds(String userId, double amount, String currency, String paymentMethodId) async {
    final walletRef = firestore.collection('wallets').doc(userId);
    final transactionRef = walletRef.collection('transactions').doc();

    return await firestore.runTransaction((transaction) async {
      final walletDoc = await transaction.get(walletRef);
      
      double currentBalance = 0.0;
      if (walletDoc.exists) {
        currentBalance = (walletDoc.data()!['balance'] as num).toDouble();
      }

      final newBalance = currentBalance + amount;
      
      final walletUpdate = WalletModel(
        userId: userId,
        balance: newBalance,
        currency: currency,
      );

      final newTransaction = TransactionModel(
        id: transactionRef.id,
        amount: amount,
        type: TransactionType.credit,
        timestamp: DateTime.now(),
        description: 'Added funds via $paymentMethodId',
        referenceId: paymentMethodId,
      );

      transaction.set(walletRef, walletUpdate.toJson());
      transaction.set(transactionRef, newTransaction.toJson());

      return walletUpdate;
    });
  }

  @override
  Future<List<TransactionModel>> getTransactionHistory(String userId) async {
    final querySnapshot = await firestore
        .collection('wallets')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => TransactionModel.fromJson(doc.data()))
        .toList();
  }
}
