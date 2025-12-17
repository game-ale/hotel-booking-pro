import 'package:equatable/equatable.dart';
import '../../../domain/entities/owner_booking.dart';
import '../../../domain/entities/revenue_summary.dart';

abstract class OwnerBookingState extends Equatable {
  const OwnerBookingState();

  @override
  List<Object> get props => [];
}

class OwnerBookingInitial extends OwnerBookingState {}

class OwnerBookingLoading extends OwnerBookingState {}

class OwnerBookingsLoaded extends OwnerBookingState {
  final List<OwnerBooking> bookings;
  const OwnerBookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class RevenueLoaded extends OwnerBookingState {
  final RevenueSummary summary;
  const RevenueLoaded(this.summary);

  @override
  List<Object> get props => [summary];
}

class OwnerBookingError extends OwnerBookingState {
  final String message;
  const OwnerBookingError(this.message);

  @override
  List<Object> get props => [message];
}
