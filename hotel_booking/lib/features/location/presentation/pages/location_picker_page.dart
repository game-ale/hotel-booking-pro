import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/location_entity.dart';
import '../bloc/place_search_bloc.dart';
import 'widgets/location_search_bar.dart';

class LocationPickerPage extends StatefulWidget {
  final LocationEntity? initialLocation;
  
  const LocationPickerPage({super.key, this.initialLocation});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _mapController;
  LatLng? _currentCenter; // Track center for selection

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _currentCenter = LatLng(widget.initialLocation!.latitude, widget.initialLocation!.longitude);
    } else {
      _currentCenter = const LatLng(37.7749, -122.4194); // Default
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PlaceSearchBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pick Location'),
          actions: [
            TextButton(
              onPressed: () {
                if (_currentCenter != null) {
                  Navigator.of(context).pop(LocationEntity(
                    latitude: _currentCenter!.latitude,
                    longitude: _currentCenter!.longitude,
                    // Address fetch is implicit via Repo in caller or unrelated
                  ));
                }
              },
              child: const Text('SELECT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentCenter!,
                zoom: 15,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: (position) {
                _currentCenter = position.target;
              },
              markers: {}, // No markers, just center pin
            ),
            const Center(
              child: Icon(Icons.location_pin, size: 50, color: Colors.blue),
            ),
            
            // Search for quick jump
             Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: BlocListener<PlaceSearchBloc, PlaceSearchState>(
                listener: (context, state) {
                   if (state is PlaceDetailsLoaded) {
                     final loc = LatLng(state.location.latitude, state.location.longitude);
                     _mapController?.animateCamera(CameraUpdate.newLatLng(loc));
                     // Update center manually? onCameraMove handles it.
                   }
                },
                child: LocationSearchBar(
                  onPlaceSelected: (placeId) {
                    context.read<PlaceSearchBloc>().add(PlaceSelected(placeId));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
