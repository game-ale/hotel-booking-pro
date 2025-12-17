import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hotel/features/profile/domain/entities/user_profile.dart'; // Adjust path if needed package:hotel/...
import 'package:hotel/features/profile/domain/repositories/profile_repository.dart';
import 'package:hotel/features/profile/domain/usecases/get_user_profile.dart';

// Generate Mocks
@GenerateMocks([ProfileRepository])
import 'get_user_profile_test.mocks.dart';

void main() {
  late GetUserProfile usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = GetUserProfile(mockProfileRepository);
  });

  const tUserId = 'user123';
  const tUserProfile = UserProfile(
    id: tUserId,
    email: 'test@example.com',
    displayName: 'Test User',
  );

  test(
    'should get user profile from the repository',
    () async {
      // arrange
      when(mockProfileRepository.getUserProfile(tUserId))
          .thenAnswer((_) async => const Right(tUserProfile));
      // act
      final result = await usecase(tUserId);
      // assert
      expect(result, const Right(tUserProfile));
      verify(mockProfileRepository.getUserProfile(tUserId));
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );
}
