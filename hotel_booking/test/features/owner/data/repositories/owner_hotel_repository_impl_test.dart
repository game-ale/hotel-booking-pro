import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:hotel_booking/features/owner/data/datasources/owner_remote_data_source.dart';
import 'package:hotel_booking/features/owner/data/models/owner_hotel_model.dart';
import 'package:hotel_booking/features/owner/data/repositories/owner_hotel_repository_impl.dart';
import 'package:hotel_booking/features/owner/domain/entities/owner_hotel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'owner_hotel_repository_impl_test.mocks.dart';

@GenerateMocks([OwnerRemoteDataSource])
void main() {
  late OwnerHotelRepositoryImpl repository;
  late MockOwnerRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockOwnerRemoteDataSource();
    repository = OwnerHotelRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tOwnerId = 'owner1';
  final tHotelModel = OwnerHotelModel(
    id: '1',
    ownerId: tOwnerId,
    name: 'Hotel 1',
    location: 'Loc',
    description: 'Desc',
    images: const [],
    amenities: const [],
    status: HotelStatus.active,
    createdAt: DateTime(2023, 1, 1),
  );
  final List<OwnerHotelModel> tHotelModels = [tHotelModel];
  final List<OwnerHotel> tHotels = tHotelModels;

  group('getOwnerHotels', () {
    test('should return list of hotels when remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getOwnerHotels(any))
          .thenAnswer((_) async => tHotelModels);
      // act
      final result = await repository.getOwnerHotels(tOwnerId);
      // assert
      verify(mockRemoteDataSource.getOwnerHotels(tOwnerId));
      expect(result, equals(Right(tHotels)));
    });

    test('should return ServerFailure when remote call is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getOwnerHotels(any))
          .thenThrow(Exception('Error'));
      // act
      final result = await repository.getOwnerHotels(tOwnerId);
      // assert
      verify(mockRemoteDataSource.getOwnerHotels(tOwnerId));
      expect(result, equals(const Left(ServerFailure('Exception: Error'))));
    });
  });
}
