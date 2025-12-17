import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_owner_bookings.dart';
import '../../../domain/usecases/get_revenue_summary.dart';
import 'owner_booking_event.dart';
import 'owner_booking_state.dart';

class OwnerBookingBloc extends Bloc<OwnerBookingEvent, OwnerBookingState> {
  final GetOwnerBookings getOwnerBookings;
  final GetRevenueSummary getRevenueSummary;

  OwnerBookingBloc({
    required this.getOwnerBookings,
    required this.getRevenueSummary,
  }) : super(OwnerBookingInitial()) {
    on<GetOwnerBookingsEvent>(_onGetOwnerBookings);
    on<GetRevenueSummaryEvent>(_onGetRevenueSummary);
  }

  Future<void> _onGetOwnerBookings(
    GetOwnerBookingsEvent event,
    Emitter<OwnerBookingState> emit,
  ) async {
    emit(OwnerBookingLoading());
    final result = await getOwnerBookings(event.ownerId);
    result.fold(
      (failure) => emit(OwnerBookingError(failure.message)),
      (bookings) => emit(OwnerBookingsLoaded(bookings)),
    );
  }

  Future<void> _onGetRevenueSummary(
    GetRevenueSummaryEvent event,
    Emitter<OwnerBookingState> emit,
  ) async {
    emit(OwnerBookingLoading());
    final result = await getRevenueSummary(GetRevenueSummaryParams(
      ownerId: event.ownerId,
      start: event.start,
      end: event.end,
    ));
    result.fold(
      (failure) => emit(OwnerBookingError(failure.message)),
      (summary) => emit(RevenueLoaded(summary)),
    );
  }
}
