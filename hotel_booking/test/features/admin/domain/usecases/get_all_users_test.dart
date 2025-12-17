import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hotel/features/admin/domain/entities/admin_user.dart';
import 'package:hotel/features/admin/domain/repositories/admin_repository.dart';
import 'package:hotel/features/admin/domain/usecases/user_admin_usecases.dart';

@GenerateMocks([AdminRepository])
import 'get_all_users_test.mocks.dart';

void main() {
  late GetAllUsersUseCase usecase;
  late MockAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockAdminRepository();
    usecase = GetAllUsersUseCase(mockRepository);
  });

  const tUsers = [
    AdminUser(id: '1', email: 'test@admin.com', role: 'admin'),
    AdminUser(id: '2', email: 'user@user.com', role: 'user'),
  ];

  test('should get all users from repository', () async {
    // arrange
    when(mockRepository.getAllUsers())
        .thenAnswer((_) async => const Right(tUsers));
    // act
    final result = await usecase();
    // assert
    expect(result, const Right(tUsers));
    verify(mockRepository.getAllUsers());
    verifyNoMoreInteractions(mockRepository);
  });
}
