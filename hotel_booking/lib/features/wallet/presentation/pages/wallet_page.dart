import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

class WalletPage extends StatefulWidget {
  final String userId;

  const WalletPage({super.key, required this.userId});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetWalletEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wallet')),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WalletLoaded || state is WalletFundsAdded) {
            final wallet = (state is WalletLoaded)
                ? state.wallet
                : (state as WalletFundsAdded).wallet;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text('Current Balance', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            '${wallet.balance} ${wallet.currency}',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/wallet/add-funds', extra: widget.userId);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Funds'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.push('/wallet/history', extra: widget.userId);
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Transaction History'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
