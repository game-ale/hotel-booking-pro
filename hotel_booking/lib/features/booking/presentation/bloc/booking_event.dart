import 'package:equatable/equatable.dart';
import '../../../domain/entities/booking_entity.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CheckAvailability extends BookingEvent {
  final String roomId;
  final DateTime checkIn;
  final DateTime checkOut;

  const CheckAvailability({
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  List<Object> get props => [roomId, checkIn, checkOut];
}

class CreateBooking extends BookingEvent {
  final BookingEntity booking;

  const CreateBooking(this.booking);

  @override
  List<Object> get props => [booking];
}

class CancelBooking extends BookingEvent {
  final String bookingId;

  const CancelBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class FetchUserBookings extends BookingEvent {
  final String userId;

  const FetchUserBookings(this.userId);

  @override
  List<Object> get props => [userId];
}
