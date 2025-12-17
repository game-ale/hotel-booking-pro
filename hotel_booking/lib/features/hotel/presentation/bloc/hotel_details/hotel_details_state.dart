import 'package:equatable/equatable.dart';
import '../../../domain/entities/hotel_entity.dart';

abstract class HotelDetailsState extends Equatable {
  const HotelDetailsState();

  @override
  List<Object> get props => [];
}

class HotelDetailsInitial extends HotelDetailsState {}

class HotelDetailsLoading extends HotelDetailsState {}

class HotelDetailsLoaded extends HotelDetailsState {
  final HotelEntity hotel;

  const HotelDetailsLoaded(this.hotel);

  @override
  List<Object> get props => [hotel];
}

class HotelDetailsFailure extends HotelDetailsState {
  final String message;

  const HotelDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}
