import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_hotel_details_usecase.dart';
import 'hotel_details_event.dart';
import 'hotel_details_state.dart';

class HotelDetailsBloc extends Bloc<HotelDetailsEvent, HotelDetailsState> {
  final GetHotelDetailsUseCase getHotelDetailsUseCase;

  HotelDetailsBloc({required this.getHotelDetailsUseCase})
      : super(HotelDetailsInitial()) {
    on<LoadHotelDetails>(_onLoadHotelDetails);
  }

  Future<void> _onLoadHotelDetails(
    LoadHotelDetails event,
    Emitter<HotelDetailsState> emit,
  ) async {
    emit(HotelDetailsLoading());
    final result = await getHotelDetailsUseCase(event.hotelId);
    result.fold(
      (failure) => emit(HotelDetailsFailure(failure.message)),
      (hotel) => emit(HotelDetailsLoaded(hotel)),
    );
  }
}
