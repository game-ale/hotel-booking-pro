import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart'; // Assuming generic UseCase exists or I create ad-hoc
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, UserProfile>> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}
