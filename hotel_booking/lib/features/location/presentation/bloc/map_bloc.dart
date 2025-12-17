import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/location_entity.dart'; // To center map
// We might need Hotel Entities to display markers.
// Assuming we accept a list of generic items or strictly Hotels.
// For Clean Arch, we might define a MapMarkerEntity or reuse Hotel.
// Let's assume we pass List<MapMarkerData> to the Event.

class MapMarkerData extends Equatable {
  final String id;
  final double lat;
  final double lng;
  final String title;
  
  const MapMarkerData({required this.id, required this.lat, required this.lng, required this.title});
  
  @override
  List<Object?> get props => [id, lat, lng, title];
}

// Events
abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object> get props => [];
}

class MapInitialized extends MapEvent {}

class UpdateMarkers extends MapEvent {
  final List<MapMarkerData> markers;
  const UpdateMarkers(this.markers);
  @override
  List<Object> get props => [markers];
}

class MoveMapCamera extends MapEvent {
  final LocationEntity target;
  final double zoom;
  const MoveMapCamera(this.target, {this.zoom = 14.0});
  @override
  List<Object> get props => [target, zoom];
}

class MarkerSelected extends MapEvent {
  final String markerId;
  const MarkerSelected(this.markerId);
  @override
  List<Object> get props => [markerId];
}

// States
abstract class MapState extends Equatable {
  const MapState();
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoaded extends MapState {
  final Set<Marker> markers;
  final LocationEntity? cameraPosition;
  final String? selectedMarkerId;

  const MapLoaded({
    this.markers = const {},
    this.cameraPosition,
    this.selectedMarkerId,
  });

  MapLoaded copyWith({
    Set<Marker>? markers,
    LocationEntity? cameraPosition,
    String? selectedMarkerId,
  }) {
    return MapLoaded(
      markers: markers ?? this.markers,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      selectedMarkerId: selectedMarkerId, // Nullable update logic... if I pass null, does it clear? 
      // Standard copyWith: if null passed, keep old? 
      // To allow clearing, I usually use a wrapper or specific boolean.
      // For selectedMarkerId, if I want to deselect, I pass empty string or specific null wrapper.
      // Ideally I separate selection into its own field update.
    );
  }

  @override
  List<Object?> get props => [markers, cameraPosition, selectedMarkerId];
}

// BLoC
class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<MapInitialized>((event, emit) {
      emit(const MapLoaded());
    });
    
    on<UpdateMarkers>(_onUpdateMarkers);
    on<MoveMapCamera>(_onMoveMapCamera);
    on<MarkerSelected>(_onMarkerSelected);
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) {
    // Convert MapMarkerData to Google Maps Markers
    final Set<Marker> googleMarkers = event.markers.map((data) {
      return Marker(
        markerId: MarkerId(data.id),
        position: LatLng(data.lat, data.lng),
        infoWindow: InfoWindow(title: data.title),
        onTap: () {
          add(MarkerSelected(data.id));
        },
      );
    }).toSet();
    
    if (state is MapLoaded) {
      // Preserve camera, update markers
      final currentState = state as MapLoaded;
      emit(MapLoaded(
        markers: googleMarkers,
        cameraPosition: currentState.cameraPosition,
        selectedMarkerId: currentState.selectedMarkerId,
      ));
    } else {
      emit(MapLoaded(markers: googleMarkers));
    }
  }

  void _onMoveMapCamera(MoveMapCamera event, Emitter<MapState> emit) {
     if (state is MapLoaded) {
       final currentState = state as MapLoaded;
       emit(MapLoaded(
         markers: currentState.markers,
         cameraPosition: event.target, // UI listens to this to animate camera
         selectedMarkerId: currentState.selectedMarkerId,
       ));
     } else {
       emit(MapLoaded(cameraPosition: event.target));
     }
  }

  void _onMarkerSelected(MarkerSelected event, Emitter<MapState> emit) {
     if (state is MapLoaded) {
       final currentState = state as MapLoaded;
       // We can trigger a side effect or just update state selection
       // If UI needs to show a card, it listens to selectedMarkerId
       emit(MapLoaded(
         markers: currentState.markers,
         cameraPosition: currentState.cameraPosition,
         selectedMarkerId: event.markerId,
       ));
     }
  }
}
