import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../repositories/profile_repository.dart';

class UpdateUserSettings {
  final ProfileRepository repository;

  UpdateUserSettings(this.repository);

  Future<Either<Failure, UserSettings>> call(UserSettings settings) async {
    return await repository.updateUserSettings(settings);
  }
}
