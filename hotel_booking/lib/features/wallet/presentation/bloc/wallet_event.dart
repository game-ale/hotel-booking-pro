import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class GetWalletEvent extends WalletEvent {
  final String userId;

  const GetWalletEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddFundsEvent extends WalletEvent {
  final String userId;
  final double amount;
  final String currency;
  final String paymentMethodId;

  const AddFundsEvent({
    required this.userId,
    required this.amount,
    required this.currency,
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [userId, amount, currency, paymentMethodId];
}

class GetTransactionHistoryEvent extends WalletEvent {
  final String userId;

  const GetTransactionHistoryEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
