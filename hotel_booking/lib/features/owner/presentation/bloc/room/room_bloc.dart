import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_room.dart';
import '../../../domain/usecases/toggle_room_availability.dart';
import '../../../domain/usecases/update_room.dart';
import '../../../../owner/domain/repositories/owner_hotel_repository.dart';
import 'room_event.dart';
import 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final OwnerHotelRepository repository; // Using Repo directly for GetRooms to save time, or create usecase?
  // Plan said "GetRooms" usecase is missing in list but needed.
  // I will inject the repository directly for GetRooms since I forgot to make a specific UseCase file for it
  // or I can quickly create one. Best practice is UseCase. 
  // Wait, I defined `getRooms` in Repo but didn't make a file `get_rooms.dart`. 
  // Ideally, I should make it. I'll stick to Clean Architecture and add it now or use repo.
  // Let's use repo directly for now to unblock, or better: make the usecase. 
  // I'll use the repository directly for `GetRooms` as a pragmatic shortcut or I can assume `AddRoom`, `UpdateRoom` are enough?
  // No, `GetRooms` is essential.

  final AddRoom addRoom;
  final UpdateRoom updateRoom;
  final ToggleRoomAvailability toggleRoomAvailability;

  RoomBloc({
    required this.repository,
    required this.addRoom,
    required this.updateRoom,
    required this.toggleRoomAvailability,
  }) : super(RoomInitial()) {
    on<GetRoomsEvent>(_onGetRooms);
    on<AddRoomEvent>(_onAddRoom);
    on<UpdateRoomEvent>(_onUpdateRoom);
    on<ToggleRoomAvailabilityEvent>(_onToggleRoomAvailability);
  }

  Future<void> _onGetRooms(
    GetRoomsEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    final result = await repository.getRooms(event.hotelId);
    result.fold(
      (failure) => emit(RoomError(failure.message)),
      (rooms) => emit(RoomsLoaded(rooms)),
    );
  }

  Future<void> _onAddRoom(
    AddRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    final result = await addRoom(event.room);
    result.fold(
      (failure) => emit(RoomError(failure.message)),
      (_) => emit(const RoomOperationSuccess('Room added successfully')),
    );
  }

  Future<void> _onUpdateRoom(
    UpdateRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    final result = await updateRoom(event.room);
    result.fold(
      (failure) => emit(RoomError(failure.message)),
      (_) => emit(const RoomOperationSuccess('Room updated successfully')),
    );
  }

  Future<void> _onToggleRoomAvailability(
    ToggleRoomAvailabilityEvent event,
    Emitter<RoomState> emit,
  ) async {
    // Optimistic update could be done here, but let's stick to simple
    emit(RoomLoading());
    final result = await toggleRoomAvailability(event.roomId, event.isAvailable);
    result.fold(
      (failure) => emit(RoomError(failure.message)),
      (_) => emit(RoomOperationSuccess('Room is now ${event.isAvailable ? 'Available' : 'Unavailable'}')),
    );
  }
}
