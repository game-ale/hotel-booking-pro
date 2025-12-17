import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../repositories/profile_repository.dart';

class GetUserSettings {
  final ProfileRepository repository;

  GetUserSettings(this.repository);

  Future<Either<Failure, UserSettings>> call(String userId) async {
    return await repository.getUserSettings(userId);
  }
}
