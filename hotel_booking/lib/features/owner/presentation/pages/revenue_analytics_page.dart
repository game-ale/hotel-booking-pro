import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/owner_booking/owner_booking_bloc.dart';
import '../bloc/owner_booking/owner_booking_event.dart';
import '../bloc/owner_booking/owner_booking_state.dart';

class RevenueAnalyticsPage extends StatelessWidget {
  const RevenueAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String? ownerId;
    if (authState is Authenticated) {
      ownerId = authState.user.id;
    }

    // Default: Last 30 days
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 30));

    return BlocProvider(
      create: (context) => sl<OwnerBookingBloc>()..add(GetRevenueSummaryEvent(
        ownerId: ownerId ?? '',
        start: start,
        end: end,
      )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Revenue Analytics'),
        ),
        body: BlocBuilder<OwnerBookingBloc, OwnerBookingState>(
          builder: (context, state) {
            if (state is OwnerBookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OwnerBookingError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is RevenueLoaded) {
              final summary = state.summary;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last 30 Days', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text('Total Revenue', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                            Text(
                              '\$${summary.totalRevenue.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Bookings', style: TextStyle(fontSize: 16)),
                            Text(
                              '${summary.totalBookings}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Center(child: Text('Detailed charts coming soon!')),
                    const Spacer(),
                  ],
                ),
              );
            }
            return const Center(child: Text('Please log in.'));
          },
        ),
      ),
    );
  }
}
