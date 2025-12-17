import 'package:equatable/equatable.dart';
import '../../../domain/entities/owner_hotel.dart';

abstract class OwnerHotelState extends Equatable {
  const OwnerHotelState();
  
  @override
  List<Object> get props => [];
}

class OwnerHotelInitial extends OwnerHotelState {}

class OwnerHotelLoading extends OwnerHotelState {}

class OwnerHotelsLoaded extends OwnerHotelState {
  final List<OwnerHotel> hotels;
  const OwnerHotelsLoaded(this.hotels);

  @override
  List<Object> get props => [hotels];
}

class OwnerHotelOperationSuccess extends OwnerHotelState {
  final String message;
  const OwnerHotelOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OwnerHotelError extends OwnerHotelState {
  final String message;
  const OwnerHotelError(this.message);

  @override
  List<Object> get props => [message];
}
