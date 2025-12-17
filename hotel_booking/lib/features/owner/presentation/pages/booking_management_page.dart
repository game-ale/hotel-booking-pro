import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/owner_booking/owner_booking_bloc.dart';
import '../bloc/owner_booking/owner_booking_event.dart';
import '../bloc/owner_booking/owner_booking_state.dart';

class BookingManagementPage extends StatelessWidget {
  const BookingManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String? ownerId;
    if (authState is Authenticated) {
      ownerId = authState.user.id;
    }

    return BlocProvider(
      create: (context) => sl<OwnerBookingBloc>()..add(GetOwnerBookingsEvent(ownerId ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings'),
        ),
        body: BlocBuilder<OwnerBookingBloc, OwnerBookingState>(
          builder: (context, state) {
            if (state is OwnerBookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OwnerBookingError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is OwnerBookingsLoaded) {
              if (state.bookings.isEmpty) {
                return const Center(child: Text('No bookings yet.'));
              }
              return ListView.builder(
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const Icon(Icons.confirmation_number),
                      title: Text(booking.userName),
                      subtitle: Text('${booking.checkIn.toString().split(' ')[0]} - ${booking.checkOut.toString().split(' ')[0]}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('\$${booking.totalPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(booking.status.name, style: TextStyle(color: _getStatusColor(booking.status.name))),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Please log in.'));
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'completed': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
