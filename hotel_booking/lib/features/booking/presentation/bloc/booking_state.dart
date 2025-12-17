import 'package:equatable/equatable.dart';
import '../../../domain/entities/booking_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class AvailabilityChecked extends BookingState {
  final bool isAvailable;

  const AvailabilityChecked(this.isAvailable);

  @override
  List<Object> get props => [isAvailable];
}

class BookingSuccess extends BookingState {
  final BookingEntity booking;

  const BookingSuccess(this.booking);

  @override
  List<Object> get props => [booking];
}

class BookingListLoaded extends BookingState {
  final List<BookingEntity> bookings;

  const BookingListLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class BookingCancelled extends BookingState {}

class BookingFailure extends BookingState {
  final String message;

  const BookingFailure(this.message);

  @override
  List<Object> get props => [message];
}
