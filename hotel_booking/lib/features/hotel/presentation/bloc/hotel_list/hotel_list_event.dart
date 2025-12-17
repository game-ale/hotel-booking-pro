import 'package:equatable/equatable.dart';
import '../../../domain/entities/hotel_entity.dart';

abstract class HotelListEvent extends Equatable {
  const HotelListEvent();

  @override
  List<Object> get props => [];
}

class LoadHotels extends HotelListEvent {}

class LoadMoreHotels extends HotelListEvent {}

class RefreshHotels extends HotelListEvent {}
