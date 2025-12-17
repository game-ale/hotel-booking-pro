import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hotel/features/location/domain/entities/location_entity.dart';
import 'package:hotel/features/location/domain/repositories/location_repository.dart';
import 'package:hotel/features/location/domain/usecases/get_current_location_usecase.dart';

@GenerateMocks([LocationRepository])
import 'get_current_location_usecase_test.mocks.dart';

void main() {
  late GetCurrentLocationUseCase usecase;
  late MockLocationRepository mockRepository;

  setUp(() {
    mockRepository = MockLocationRepository();
    usecase = GetCurrentLocationUseCase(mockRepository);
  });

  const tLocation = LocationEntity(latitude: 37.7749, longitude: -122.4194);

  test('should get current location from repository', () async {
    // arrange
    when(mockRepository.getCurrentLocation())
        .thenAnswer((_) async => const Right(tLocation));
    // act
    final result = await usecase();
    // assert
    expect(result, const Right(tLocation));
    verify(mockRepository.getCurrentLocation());
    verifyNoMoreInteractions(mockRepository);
  });
}
