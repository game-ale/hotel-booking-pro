import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}
