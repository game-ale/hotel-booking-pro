import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/location_entity.dart';
import '../bloc/location_bloc.dart';
import '../bloc/map_bloc.dart';
import '../bloc/place_search_bloc.dart'; // For search details logic if needed, or injected
import 'widgets/location_search_bar.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LocationBloc>()..add(GetCurrentLocationEvent())),
        BlocProvider(create: (context) => sl<PlaceSearchBloc>()),
        BlocProvider(create: (context) => sl<MapBloc>()..add(MapInitialized())),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            BlocConsumer<MapBloc, MapState>(
              listener: (context, state) {
                if (state is MapLoaded && state.cameraPosition != null && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(state.cameraPosition!.latitude, state.cameraPosition!.longitude),
                      14, // default Zoom
                    ),
                  );
                }
              },
              builder: (context, mapState) {
                // If we also wait for LocationLoaded to center initially
                return BlocListener<LocationBloc, LocationState>(
                  listener: (context, locationState) {
                    if (locationState is LocationLoaded && mapState is MapLoaded && mapState.cameraPosition == null) {
                       // Move Initial Camera to User Location
                       context.read<MapBloc>().add(MoveMapCamera(locationState.location));
                    }
                  },
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(37.7749, -122.4194), // Default SF
                      zoom: 12,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      // Load map style if needed
                    },
                    markers: mapState is MapLoaded ? mapState.markers : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                );
              },
            ),
            
            // Search Bar Overlay
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: BlocListener<PlaceSearchBloc, PlaceSearchState>(
                listener: (context, state) {
                  if (state is PlaceDetailsLoaded) {
                     // Move map to selected place
                     context.read<MapBloc>().add(MoveMapCamera(state.location));
                     // Hide keyboard
                     FocusScope.of(context).unfocus();
                  }
                },
                child: LocationSearchBar(
                   onPlaceSelected: (placeId) {
                     context.read<PlaceSearchBloc>().add(PlaceSelected(placeId));
                   },
                ),
              ),
            ),
            
            // Bottom Sheet Placeholder for Selected Marker
            // Implement listener for MarkerSelected in MapBloc
          ],
        ),
      ),
    );
  }
}
