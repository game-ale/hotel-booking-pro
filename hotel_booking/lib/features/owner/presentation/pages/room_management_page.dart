import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/room/room_bloc.dart';
import '../bloc/room/room_event.dart';
import '../bloc/room/room_state.dart';
import 'add_edit_room_page.dart';

class RoomManagementPage extends StatelessWidget {
  final String hotelId;

  const RoomManagementPage({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RoomBloc>()..add(GetRoomsEvent(hotelId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Rooms'),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddEditRoomPage(hotelId: hotelId),
                    ),
                  ).then((_) {
                    context.read<RoomBloc>().add(GetRoomsEvent(hotelId));
                  });
                },
              );
            }),
          ],
        ),
        body: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            if (state is RoomLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoomError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is RoomsLoaded) {
              if (state.rooms.isEmpty) {
                return const Center(child: Text('No rooms found. Add one!'));
              }
              return ListView.builder(
                itemCount: state.rooms.length,
                itemBuilder: (context, index) {
                  final room = state.rooms[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(room.name),
                      subtitle: Text('Capacity: ${room.capacity} | Price: \$${room.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: room.isAvailable,
                            onChanged: (val) {
                              context.read<RoomBloc>().add(ToggleRoomAvailabilityEvent(room.id, val));
                              // Optimistically update UI or wait for BLoC
                              // BLoC emits RoomOperationSuccess or RoomError
                              // Ideally we should reload headers or handle state better, 
                              // but for now listener or reload. 
                              // Current Bloc implementation toggles and emits Success message, losing List state.
                              // This is a common BLoC issue. 
                              // Ideally Toggle should just update the list in State.
                              // My generic RoomBloc emits OperationSuccess which REPLACES RoomLoaded.
                              // This will cause the list to vanish and show "Room Updated" message.
                              // I should fix the BLoC to re-emit Loaded or handle it in UI.
                              // For MVP: I will just refresh the list after success in a Listener.
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddEditRoomPage(hotelId: hotelId, room: room),
                                  ),
                                ).then((_) {
                                  context.read<RoomBloc>().add(GetRoomsEvent(hotelId));
                                });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            // Handle Success state which replaces Loaded state
            if (state is RoomOperationSuccess) {
              // Trigger reload
              context.read<RoomBloc>().add(GetRoomsEvent(hotelId));
              return const Center(child: CircularProgressIndicator());
            }
            return Container();
          },
        ),
      ),
    );
  }
}
