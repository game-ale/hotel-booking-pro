import 'package:equatable/equatable.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/transaction_entity.dart';

abstract class WalletState extends Equatable {
  const WalletState();
  
  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;

  const WalletLoaded(this.wallet);

  @override
  List<Object> get props => [wallet];
}

class WalletFundsAdded extends WalletState {
  final WalletEntity wallet;

  const WalletFundsAdded(this.wallet);

  @override
  List<Object> get props => [wallet];
}

class TransactionHistoryLoaded extends WalletState {
  final List<TransactionEntity> transactions;

  const TransactionHistoryLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}
