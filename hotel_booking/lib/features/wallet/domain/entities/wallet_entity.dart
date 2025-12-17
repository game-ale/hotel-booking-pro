import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final String userId;
  final double balance;
  final String currency;

  const WalletEntity({
    required this.userId,
    required this.balance,
    required this.currency,
  });

  @override
  List<Object?> get props => [userId, balance, currency];
}
