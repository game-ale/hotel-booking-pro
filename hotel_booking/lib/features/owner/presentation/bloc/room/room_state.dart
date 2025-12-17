import 'package:equatable/equatable.dart';
import '../../../domain/entities/room.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<Room> rooms;
  const RoomsLoaded(this.rooms);

  @override
  List<Object> get props => [rooms];
}

class RoomOperationSuccess extends RoomState {
  final String message;
  const RoomOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RoomError extends RoomState {
  final String message;
  const RoomError(this.message);

  @override
  List<Object> get props => [message];
}
