import 'package:equatable/equatable.dart';
import '../../../domain/entities/room.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class GetRoomsEvent extends RoomEvent {
  final String hotelId;
  const GetRoomsEvent(this.hotelId);

  @override
  List<Object> get props => [hotelId];
}

class AddRoomEvent extends RoomEvent {
  final Room room;
  const AddRoomEvent(this.room);

  @override
  List<Object> get props => [room];
}

class UpdateRoomEvent extends RoomEvent {
  final Room room;
  const UpdateRoomEvent(this.room);

  @override
  List<Object> get props => [room];
}

class ToggleRoomAvailabilityEvent extends RoomEvent {
  final String roomId;
  final bool isAvailable;
  const ToggleRoomAvailabilityEvent(this.roomId, this.isAvailable);

  @override
  List<Object> get props => [roomId, isAvailable];
}
