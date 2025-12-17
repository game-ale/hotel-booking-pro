import 'package:equatable/equatable.dart';
import '../../../domain/entities/hotel_entity.dart';

abstract class HotelSearchState extends Equatable {
  const HotelSearchState();

  @override
  List<Object> get props => [];
}

class HotelSearchInitial extends HotelSearchState {}

class HotelSearchLoading extends HotelSearchState {}

class HotelSearchLoaded extends HotelSearchState {
  final List<HotelEntity> hotels;

  const HotelSearchLoaded(this.hotels);

  @override
  List<Object> get props => [hotels];
}

class HotelSearchFailure extends HotelSearchState {
  final String message;

  const HotelSearchFailure(this.message);

  @override
  List<Object> get props => [message];
}
