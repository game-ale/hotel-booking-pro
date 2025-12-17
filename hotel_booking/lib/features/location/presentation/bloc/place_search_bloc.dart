import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/usecases/search_places_usecase.dart';
import '../../domain/usecases/get_place_details_usecase.dart';
import '../../domain/entities/place_suggestion.dart';
import '../../domain/entities/location_entity.dart';

// Events
abstract class PlaceSearchEvent extends Equatable {
  const PlaceSearchEvent();
  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends PlaceSearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}

class PlaceSelected extends PlaceSearchEvent {
  final String placeId;
  const PlaceSelected(this.placeId);
  @override
  List<Object> get props => [placeId];
}

class ClearSearch extends PlaceSearchEvent {}

// States
abstract class PlaceSearchState extends Equatable {
  const PlaceSearchState();
  @override
  List<Object?> get props => [];
}

class PlaceSearchInitial extends PlaceSearchState {}
class PlaceSearchLoading extends PlaceSearchState {}
class PlaceSearchLoaded extends PlaceSearchState {
  final List<PlaceSuggestion> suggestions;
  const PlaceSearchLoaded(this.suggestions);
  @override
  List<Object?> get props => [suggestions];
}
class PlaceDetailsLoaded extends PlaceSearchState {
  final LocationEntity location; // Lat/Lng of selected place
  const PlaceDetailsLoaded(this.location);
  @override
  List<Object?> get props => [location];
}
class PlaceSearchError extends PlaceSearchState {
  final String message;
  const PlaceSearchError(this.message);
   @override
  List<Object?> get props => [message];
}

// BLoC
class PlaceSearchBloc extends Bloc<PlaceSearchEvent, PlaceSearchState> {
  final SearchPlacesUseCase searchPlaces;
  final GetPlaceDetailsUseCase getPlaceDetails;

  PlaceSearchBloc({
    required this.searchPlaces,
    required this.getPlaceDetails,
  }) : super(PlaceSearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged, 
      transformer: (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper),
    );
    on<PlaceSelected>(_onPlaceSelected);
    on<ClearSearch>((event, emit) => emit(PlaceSearchInitial()));
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<PlaceSearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(PlaceSearchInitial());
      return;
    }
    emit(PlaceSearchLoading());
    final result = await searchPlaces(event.query);
    result.fold(
      (failure) => emit(PlaceSearchError(failure.message)),
      (suggestions) => emit(PlaceSearchLoaded(suggestions)),
    );
  }

  Future<void> _onPlaceSelected(
    PlaceSelected event,
    Emitter<PlaceSearchState> emit,
  ) async {
    // Show loading? Maybe. Or keep current suggestions visible?
    // Let's emit Loading to indicate fetching details
    emit(PlaceSearchLoading());
    final result = await getPlaceDetails(event.placeId);
    result.fold(
      (failure) => emit(PlaceSearchError(failure.message)),
      (location) => emit(PlaceDetailsLoaded(location)),
    );
  }
}
