import 'package:equatable/equatable.dart';
import '../../../domain/entities/owner_hotel.dart';

abstract class OwnerHotelEvent extends Equatable {
  const OwnerHotelEvent();

  @override
  List<Object> get props => [];
}

class GetOwnerHotelsEvent extends OwnerHotelEvent {
  final String ownerId;
  const GetOwnerHotelsEvent(this.ownerId);

  @override
  List<Object> get props => [ownerId];
}

class CreateOwnerHotelEvent extends OwnerHotelEvent {
  final OwnerHotel hotel;
  const CreateOwnerHotelEvent(this.hotel);

  @override
  List<Object> get props => [hotel];
}

class UpdateOwnerHotelEvent extends OwnerHotelEvent {
  final OwnerHotel hotel;
  const UpdateOwnerHotelEvent(this.hotel);

  @override
  List<Object> get props => [hotel];
}
