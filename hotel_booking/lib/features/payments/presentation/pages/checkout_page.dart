import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class CheckoutPage extends StatelessWidget {
  final String bookingId;
  final double amount;
  final String currency;

  const CheckoutPage({
    super.key,
    required this.bookingId,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentInitiated) {
            // Proceed to verification or success
            context.read<PaymentBloc>().add(VerifyPaymentEvent(paymentId: state.payment.id));
          } else if (state is PaymentVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment Successful!')),
            );
            context.go('/'); // Go home or booking details
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Booking ID: $bookingId', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Text('Total Amount: $amount $currency', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(InitiatePaymentEvent(
                      bookingId: bookingId,
                      amount: amount,
                      currency: currency,
                      method: 'credit_card', // Mock method
                    ));
                  },
                  child: const Text('Pay with Credit Card'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(InitiatePaymentEvent(
                      bookingId: bookingId,
                      amount: amount,
                      currency: currency,
                      method: 'wallet',
                    ));
                  },
                  child: const Text('Pay with Wallet'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
