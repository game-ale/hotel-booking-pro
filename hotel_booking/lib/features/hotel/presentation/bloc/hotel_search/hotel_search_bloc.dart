import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_hotels_usecase.dart';
import 'hotel_search_event.dart';
import 'hotel_search_state.dart';

class HotelSearchBloc extends Bloc<HotelSearchEvent, HotelSearchState> {
  final SearchHotelsUseCase searchHotelsUseCase;

  HotelSearchBloc({required this.searchHotelsUseCase})
      : super(HotelSearchInitial()) {
    on<SearchHotels>(_onSearchHotels);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchHotels(
    SearchHotels event,
    Emitter<HotelSearchState> emit,
  ) async {
    emit(HotelSearchLoading());
    final result = await searchHotelsUseCase(event.filter);
    result.fold(
      (failure) => emit(HotelSearchFailure(failure.message)),
      (hotels) => emit(HotelSearchLoaded(hotels)),
    );
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<HotelSearchState> emit,
  ) async {
    emit(HotelSearchInitial());
  }
}
