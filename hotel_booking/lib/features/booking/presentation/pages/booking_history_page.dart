import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<BookingBloc>().add(FetchUserBookings(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingFailure) {
            return Center(child: Text(state.message));
          } else if (state is BookingListLoaded) {
            if (state.bookings.isEmpty) {
              return const Center(child: Text('No bookings found'));
            }
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Booking #${booking.id.substring(0, 8)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${booking.checkIn.toString().split(' ')[0]} - ${booking.checkOut.toString().split(' ')[0]}'),
                        Text('Status: ${booking.status}'),
                      ],
                    ),
                    trailing: Text('\$${booking.totalPrice}'),
                    onTap: () {
                      // Navigate to details (optional)
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
