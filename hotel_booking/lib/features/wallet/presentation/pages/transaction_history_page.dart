import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../../domain/entities/transaction_type.dart';

class TransactionHistoryPage extends StatefulWidget {
  final String userId;

  const TransactionHistoryPage({super.key, required this.userId});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetTransactionHistoryEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionHistoryLoaded) {
            final transactions = state.transactions;
            if (transactions.isEmpty) {
              return const Center(child: Text('No transactions yet.'));
            }
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isCredit = tx.type == TransactionType.credit;
                return ListTile(
                  leading: Icon(
                    isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                  title: Text(tx.description),
                  subtitle: Text(tx.timestamp.toString()),
                  trailing: Text(
                    '${isCredit ? '+' : '-'}${tx.amount}',
                    style: TextStyle(
                      color: isCredit ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          } else if (state is WalletError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
