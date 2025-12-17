import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/owner/domain/entities/owner_hotel.dart';
import 'package:hotel_booking/features/owner/domain/repositories/owner_hotel_repository.dart';
import 'package:hotel_booking/features/owner/domain/usecases/get_owner_hotels.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_owner_hotels_test.mocks.dart';

@GenerateMocks([OwnerHotelRepository])
void main() {
  late GetOwnerHotels usecase;
  late MockOwnerHotelRepository mockOwnerHotelRepository;

  setUp(() {
    mockOwnerHotelRepository = MockOwnerHotelRepository();
    usecase = GetOwnerHotels(mockOwnerHotelRepository);
  });

  final tHotels = [
    OwnerHotel(
      id: '1',
      ownerId: 'owner1',
      name: 'Test Hotel',
      location: 'Test Location',
      description: 'Test Desc',
      images: ['img1.jpg'],
      amenities: ['wifi'],
      status: HotelStatus.active,
      createdAt: DateTime(2023, 1, 1),
    )
  ];
  const tOwnerId = 'owner1';

  test('should get list of hotels from the repository', () async {
    // arrange
    when(mockOwnerHotelRepository.getOwnerHotels(any))
        .thenAnswer((_) async => Right(tHotels));
    // act
    final result = await usecase(tOwnerId);
    // assert
    expect(result, Right(tHotels));
    verify(mockOwnerHotelRepository.getOwnerHotels(tOwnerId));
    verifyNoMoreInteractions(mockOwnerHotelRepository);
  });
}
