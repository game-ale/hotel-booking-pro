import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hotel_booking/core/error/failures.dart';
import 'package:hotel_booking/features/hotel/domain/entities/hotel_entity.dart';
import 'package:hotel_booking/features/hotel/domain/entities/search_filter_entity.dart';
import 'package:hotel_booking/features/hotel/domain/repositories/hotel_repository.dart';
import 'package:hotel_booking/features/hotel/domain/usecases/get_hotel_details_usecase.dart';
import 'package:hotel_booking/features/hotel/domain/usecases/get_hotels_usecase.dart';
import 'package:hotel_booking/features/hotel/domain/usecases/search_hotels_usecase.dart';

class FakeHotelRepository implements HotelRepository {
  @override
  Future<Either<Failure, List<HotelEntity>>> getHotels({required int limit, String? startAfterId}) async {
    return const Right([
      HotelEntity(
        id: '1',
        name: 'Hotel 1',
        location: 'Location 1',
        rating: 4.5,
        pricePerNight: 100,
        amenities: ['Wifi'],
        images: ['img1'],
        description: 'Desc 1',
      )
    ]);
  }

  @override
  Future<Either<Failure, List<HotelEntity>>> searchHotels(SearchFilterEntity filter) async {
    return const Right([
      HotelEntity(
        id: '2',
        name: 'Hotel 2',
        location: 'Location 2',
        rating: 5.0,
        pricePerNight: 200,
        amenities: ['Pool'],
        images: ['img2'],
        description: 'Desc 2',
      )
    ]);
  }

  @override
  Future<Either<Failure, HotelEntity>> getHotelDetails(String id) async {
    return const Right(HotelEntity(
      id: '1',
      name: 'Hotel 1',
      location: 'Location 1',
      rating: 4.5,
      pricePerNight: 100,
      amenities: ['Wifi'],
      images: ['img1'],
      description: 'Desc 1',
    ));
  }
}

void main() {
  late GetHotelsUseCase getHotelsUseCase;
  late SearchHotelsUseCase searchHotelsUseCase;
  late GetHotelDetailsUseCase getHotelDetailsUseCase;
  late FakeHotelRepository fakeHotelRepository;

  setUp(() {
    fakeHotelRepository = FakeHotelRepository();
    getHotelsUseCase = GetHotelsUseCase(fakeHotelRepository);
    searchHotelsUseCase = SearchHotelsUseCase(fakeHotelRepository);
    getHotelDetailsUseCase = GetHotelDetailsUseCase(fakeHotelRepository);
  });

  const tHotel = HotelEntity(
    id: '1',
    name: 'Hotel 1',
    location: 'Location 1',
    rating: 4.5,
    pricePerNight: 100,
    amenities: ['Wifi'],
    images: ['img1'],
    description: 'Desc 1',
  );

  group('GetHotelsUseCase', () {
    test('should return list of hotels', () async {
      final result = await getHotelsUseCase(const GetHotelsParams(limit: 10));
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return failure'),
        (r) => expect(r.length, 1),
      );
    });
  });

  group('SearchHotelsUseCase', () {
    test('should return list of hotels matching filter', () async {
      final result = await searchHotelsUseCase(const SearchFilterEntity(query: 'Hotel 2'));
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return failure'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, '2');
        },
      );
    });
  });

  group('GetHotelDetailsUseCase', () {
    test('should return hotel details', () async {
      final result = await getHotelDetailsUseCase('1');
      expect(result, const Right(tHotel));
    });
  });
}
