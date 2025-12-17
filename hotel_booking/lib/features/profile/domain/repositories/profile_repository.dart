import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../entities/user_settings.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile);
  Future<Either<Failure, UserSettings>> getUserSettings(String userId);
  Future<Either<Failure, UserSettings>> updateUserSettings(UserSettings settings);
}
