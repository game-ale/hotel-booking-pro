import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/place_suggestion.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/device_location_service.dart';
import '../datasources/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final DeviceLocationService deviceService;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.deviceService,
  });

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      final location = await deviceService.getCurrentLocation();
      // Optionally reverse geocode here?
      // For now just return coords.
      return Right(location);
    } on LocationException catch (e) {
       return Left(ServerFailure(e.message)); // Or specialized LocationFailure
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceSuggestion>>> searchPlaces(String query) async {
    try {
      final results = await remoteDataSource.searchPlaces(query);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getPlaceDetails(String placeId) async {
    try {
      final location = await remoteDataSource.getPlaceDetails(placeId);
      return Right(location);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getAddressFromCoordinates(double lat, double lng) async {
     try {
      final location = await remoteDataSource.getAddressFromCoordinates(lat, lng);
      return Right(location);
    } catch (e) { // Catch Unimplemented or ServerException
      return Left(ServerFailure(e.toString()));
    }
  }
}
