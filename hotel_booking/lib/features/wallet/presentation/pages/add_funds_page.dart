import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

class AddFundsPage extends StatefulWidget {
  final String userId;

  const AddFundsPage({super.key, required this.userId});

  @override
  State<AddFundsPage> createState() => _AddFundsPageState();
}

class _AddFundsPageState extends State<AddFundsPage> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Funds')),
      body: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletFundsAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funds added successfully!')),
            );
            context.pop(); // Go back to wallet
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text);
                  if (amount != null && amount > 0) {
                    context.read<WalletBloc>().add(AddFundsEvent(
                      userId: widget.userId,
                      amount: amount,
                      currency: 'USD',
                      paymentMethodId: 'credit_card', // Mock
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid amount')),
                    );
                  }
                },
                child: const Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
