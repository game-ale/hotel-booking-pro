import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/get_current_location_usecase.dart';

// Events
abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object> get props => [];
}

class GetCurrentLocationEvent extends LocationEvent {}

// States
abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}
class LocationLoading extends LocationState {}
class LocationLoaded extends LocationState {
  final LocationEntity location;
  const LocationLoaded(this.location);
  @override
  List<Object?> get props => [location];
}
class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocationUseCase getCurrentLocation;

  LocationBloc({required this.getCurrentLocation}) : super(LocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await getCurrentLocation();
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (location) => emit(LocationLoaded(location)),
    );
  }
}
