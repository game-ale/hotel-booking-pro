import 'package:equatable/equatable.dart';
import '../../../domain/entities/hotel_entity.dart';

abstract class HotelListState extends Equatable {
  const HotelListState();

  @override
  List<Object> get props => [];
}

class HotelListInitial extends HotelListState {}

class HotelListLoading extends HotelListState {}

class HotelListLoaded extends HotelListState {
  final List<HotelEntity> hotels;
  final bool hasMore;

  const HotelListLoaded({
    required this.hotels,
    this.hasMore = true,
  });

  @override
  List<Object> get props => [hotels, hasMore];

  HotelListLoaded copyWith({
    List<HotelEntity>? hotels,
    bool? hasMore,
  }) {
    return HotelListLoaded(
      hotels: hotels ?? this.hotels,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class HotelListLoadingMore extends HotelListState {
  final List<HotelEntity> hotels;

  const HotelListLoadingMore(this.hotels);

  @override
  List<Object> get props => [hotels];
}

class HotelListFailure extends HotelListState {
  final String message;

  const HotelListFailure(this.message);

  @override
  List<Object> get props => [message];
}
