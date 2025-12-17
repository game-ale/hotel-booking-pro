import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.userId,
    required super.balance,
    required super.currency,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'balance': balance,
      'currency': currency,
    };
  }
}
