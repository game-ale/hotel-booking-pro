import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_hotels_usecase.dart';
import 'hotel_list_event.dart';
import 'hotel_list_state.dart';

class HotelListBloc extends Bloc<HotelListEvent, HotelListState> {
  final GetHotelsUseCase getHotelsUseCase;
  static const int _pageSize = 10;

  HotelListBloc({required this.getHotelsUseCase}) : super(HotelListInitial()) {
    on<LoadHotels>(_onLoadHotels);
    on<LoadMoreHotels>(_onLoadMoreHotels);
    on<RefreshHotels>(_onRefreshHotels);
  }

  Future<void> _onLoadHotels(
    LoadHotels event,
    Emitter<HotelListState> emit,
  ) async {
    emit(HotelListLoading());
    final result = await getHotelsUseCase(const GetHotelsParams(limit: _pageSize));
    result.fold(
      (failure) => emit(HotelListFailure(failure.message)),
      (hotels) => emit(HotelListLoaded(
        hotels: hotels,
        hasMore: hotels.length >= _pageSize,
      )),
    );
  }

  Future<void> _onLoadMoreHotels(
    LoadMoreHotels event,
    Emitter<HotelListState> emit,
  ) async {
    final currentState = state;
    if (currentState is HotelListLoaded && currentState.hasMore) {
      emit(HotelListLoadingMore(currentState.hotels));

      final lastHotelId = currentState.hotels.isNotEmpty 
          ? currentState.hotels.last.id 
          : null;

      final result = await getHotelsUseCase(GetHotelsParams(
        limit: _pageSize,
        startAfterId: lastHotelId,
      ));

      result.fold(
        (failure) => emit(HotelListLoaded(
          hotels: currentState.hotels,
          hasMore: false,
        )),
        (newHotels) => emit(HotelListLoaded(
          hotels: [...currentState.hotels, ...newHotels],
          hasMore: newHotels.length >= _pageSize,
        )),
      );
    }
  }

  Future<void> _onRefreshHotels(
    RefreshHotels event,
    Emitter<HotelListState> emit,
  ) async {
    final result = await getHotelsUseCase(const GetHotelsParams(limit: _pageSize));
    result.fold(
      (failure) => emit(HotelListFailure(failure.message)),
      (hotels) => emit(HotelListLoaded(
        hotels: hotels,
        hasMore: hotels.length >= _pageSize,
      )),
    );
  }
}
