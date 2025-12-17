import 'package:equatable/equatable.dart';

abstract class HotelDetailsEvent extends Equatable {
  const HotelDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadHotelDetails extends HotelDetailsEvent {
  final String hotelId;

  const LoadHotelDetails(this.hotelId);

  @override
  List<Object> get props => [hotelId];
}
