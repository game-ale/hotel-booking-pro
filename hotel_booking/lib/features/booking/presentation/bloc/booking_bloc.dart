import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/check_availability_usecase.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_user_bookings_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CheckAvailabilityUseCase checkAvailabilityUseCase;
  final CreateBookingUseCase createBookingUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final GetUserBookingsUseCase getUserBookingsUseCase;

  BookingBloc({
    required this.checkAvailabilityUseCase,
    required this.createBookingUseCase,
    required this.cancelBookingUseCase,
    required this.getUserBookingsUseCase,
  }) : super(BookingInitial()) {
    on<CheckAvailability>(_onCheckAvailability);
    on<CreateBooking>(_onCreateBooking);
    on<CancelBooking>(_onCancelBooking);
    on<FetchUserBookings>(_onFetchUserBookings);
  }

  Future<void> _onCheckAvailability(
    CheckAvailability event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await checkAvailabilityUseCase(CheckAvailabilityParams(
      roomId: event.roomId,
      checkIn: event.checkIn,
      checkOut: event.checkOut,
    ));
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (isAvailable) => emit(AvailabilityChecked(isAvailable)),
    );
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await createBookingUseCase(event.booking);
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (booking) => emit(BookingSuccess(booking)),
    );
  }

  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await cancelBookingUseCase(event.bookingId);
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (_) => emit(BookingCancelled()),
    );
  }

  Future<void> _onFetchUserBookings(
    FetchUserBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await getUserBookingsUseCase(event.userId);
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (bookings) => emit(BookingListLoaded(bookings)),
    );
  }
}
