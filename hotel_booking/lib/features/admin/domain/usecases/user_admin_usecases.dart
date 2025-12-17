import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/admin_repository.dart';

class GetAllUsersUseCase {
  final AdminRepository repository;
  GetAllUsersUseCase(this.repository);
  Future<Either<Failure, List<AdminUser>>> call() => repository.getAllUsers();
}

class SuspendUserUseCase {
  final AdminRepository repository;
  SuspendUserUseCase(this.repository);
  Future<Either<Failure, void>> call(String userId, bool isSuspended) => 
      repository.suspendUser(userId, isSuspended);
}
