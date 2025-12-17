import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_hotel.dart';
import '../../../domain/usecases/get_owner_hotels.dart';
import '../../../domain/usecases/update_hotel.dart';
import 'owner_hotel_event.dart';
import 'owner_hotel_state.dart';

class OwnerHotelBloc extends Bloc<OwnerHotelEvent, OwnerHotelState> {
  final GetOwnerHotels getOwnerHotels;
  final CreateHotel createHotel;
  final UpdateHotel updateHotel;

  OwnerHotelBloc({
    required this.getOwnerHotels,
    required this.createHotel,
    required this.updateHotel,
  }) : super(OwnerHotelInitial()) {
    on<GetOwnerHotelsEvent>(_onGetOwnerHotels);
    on<CreateOwnerHotelEvent>(_onCreateOwnerHotel);
    on<UpdateOwnerHotelEvent>(_onUpdateOwnerHotel);
  }

  Future<void> _onGetOwnerHotels(
    GetOwnerHotelsEvent event,
    Emitter<OwnerHotelState> emit,
  ) async {
    emit(OwnerHotelLoading());
    final result = await getOwnerHotels(event.ownerId);
    result.fold(
      (failure) => emit(OwnerHotelError(failure.message)),
      (hotels) => emit(OwnerHotelsLoaded(hotels)),
    );
  }

  Future<void> _onCreateOwnerHotel(
    CreateOwnerHotelEvent event,
    Emitter<OwnerHotelState> emit,
  ) async {
    emit(OwnerHotelLoading());
    final result = await createHotel(event.hotel);
    result.fold(
      (failure) => emit(OwnerHotelError(failure.message)),
      (_) => emit(const OwnerHotelOperationSuccess('Hotel created successfully')),
    );
  }

  Future<void> _onUpdateOwnerHotel(
    UpdateOwnerHotelEvent event,
    Emitter<OwnerHotelState> emit,
  ) async {
    emit(OwnerHotelLoading());
    final result = await updateHotel(event.hotel);
    result.fold(
      (failure) => emit(OwnerHotelError(failure.message)),
      (_) => emit(const OwnerHotelOperationSuccess('Hotel updated successfully')),
    );
  }
}
