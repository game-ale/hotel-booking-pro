import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';
import '../models/user_settings_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    try {
      final model = await remoteDataSource.getUserProfile(userId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final updatedModel = await remoteDataSource.updateUserProfile(model);
      return Right(updatedModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserSettings>> getUserSettings(String userId) async {
    try {
      final model = await remoteDataSource.getUserSettings(userId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserSettings>> updateUserSettings(UserSettings settings) async {
    try {
      final model = UserSettingsModel.fromEntity(settings);
      final updatedModel = await remoteDataSource.updateUserSettings(model);
      return Right(updatedModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
