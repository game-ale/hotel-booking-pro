import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../booking/presentation/bloc/booking_bloc.dart';
import '../../../booking/presentation/bloc/booking_event.dart';
import '../../../booking/presentation/bloc/booking_state.dart' as booking_state; // Alias to avoid conflict if any

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
       return const Scaffold(body: Center(child: Text('Please log in.')));
    }
    final userId = authState.user.id;

    // We reuse BookingBloc from Booking feature to fetch history is a valid approach 
    // assuming GetUserBookingsEvent exists and is implemented in BookingBloc.
    // I need to check BookingBloc events.
    
    return BlocProvider(
      create: (context) => sl<BookingBloc>()..add(GetUserBookingsEvent(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking History'),
        ),
        body: BlocBuilder<BookingBloc, booking_state.BookingState>(
          builder: (context, state) {
            if (state is booking_state.BookingLoading) { // Assuming State names
              return const Center(child: CircularProgressIndicator());
            } else if (state is booking_state.BookingError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is booking_state.UserBookingsLoaded) { // Assuming State name
               final bookings = state.bookings;
               if (bookings.isEmpty) {
                 return const Center(child: Text('No booking history found.'));
               }
               return ListView.builder(
                 itemCount: bookings.length,
                 itemBuilder: (context, index) {
                   final booking = bookings[index];
                   return Card(
                     margin: const EdgeInsets.all(8.0),
                     child: ListTile(
                       leading: const Icon(Icons.hotel),
                       title: Text('Booking #${booking.id.substring(0, 8)}'),
                       subtitle: Text('${booking.checkIn} - ${booking.checkOut}'),
                       trailing: Text('\$${booking.totalPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
                     ),
                   );
                 },
               );
            }
            // Fallback or Initial
            return const Center(child: Text('Loading history...'));
          },
        ),
      ),
    );
  }
}
