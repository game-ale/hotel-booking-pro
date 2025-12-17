import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/auth/domain/entities/user_entity.dart';
import 'package:hotel_booking/features/auth/domain/repositories/auth_repository.dart';
import 'package:hotel_booking/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:hotel_booking/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:hotel_booking/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:hotel_booking/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:hotel_booking/core/usecases/usecase.dart';
import 'package:hotel_booking/core/error/failures.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({required String name, required String email, required String password}) async {
    return const Right(UserEntity(id: '1', email: 'test@test.com', name: 'Test User'));
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({required String email, required String password}) async {
    return const Right(UserEntity(id: '1', email: 'test@test.com', name: 'Test User'));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    return const Right(UserEntity(id: '1', email: 'test@test.com', name: 'Test User'));
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    return const Right(true);
  }
}

void main() {
  late SignUpUseCase signUpUseCase;
  late SignInUseCase signInUseCase;
  late SignOutUseCase signOutUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late FakeAuthRepository fakeAuthRepository;

  setUp(() {
    fakeAuthRepository = FakeAuthRepository();
    signUpUseCase = SignUpUseCase(fakeAuthRepository);
    signInUseCase = SignInUseCase(fakeAuthRepository);
    signOutUseCase = SignOutUseCase(fakeAuthRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(fakeAuthRepository);
  });

  const tUser = UserEntity(
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
  );

  const tName = 'Test User';
  const tEmail = 'test@test.com';
  const tPassword = 'password123';

  group('SignUpUseCase', () {
    test('should return UserEntity on success', () async {
      // act
      final result = await signUpUseCase(const SignUpParams(
        name: tName,
        email: tEmail,
        password: tPassword,
      ));

      // assert
      expect(result, const Right(tUser));
    });
  });

  group('SignInUseCase', () {
    test('should return UserEntity on success', () async {
      // act
      final result = await signInUseCase(const SignInParams(
        email: tEmail,
        password: tPassword,
      ));

      // assert
      expect(result, const Right(tUser));
    });
  });

  group('SignOutUseCase', () {
    test('should return void on success', () async {
      // act
      final result = await signOutUseCase(NoParams());

      // assert
      expect(result, const Right(null));
    });
  });

  group('GetCurrentUserUseCase', () {
    test('should return UserEntity on success', () async {
      // act
      final result = await getCurrentUserUseCase(NoParams());

      // assert
      expect(result, const Right(tUser));
    });
  });
}
