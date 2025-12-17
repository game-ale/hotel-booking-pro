import 'package:geolocator/geolocator.dart';
import '../../../../core/error/exceptions.dart';
import '../models/location_model.dart';

abstract class DeviceLocationService {
  Future<LocationModel> getCurrentLocation();
}

class DeviceLocationServiceImpl implements DeviceLocationService {
  @override
  Future<LocationModel> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException('Location permissions are permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition();
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);
}
