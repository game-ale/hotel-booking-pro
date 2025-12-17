import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/owner_hotel.dart';
import '../bloc/owner_hotel/owner_hotel_bloc.dart';
import '../bloc/owner_hotel/owner_hotel_event.dart';
import '../bloc/owner_hotel/owner_hotel_state.dart';
import 'add_edit_hotel_page.dart';
import 'room_management_page.dart';

class HotelManagementPage extends StatelessWidget {
  const HotelManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user to fetch their hotels
    final authState = context.read<AuthBloc>().state;
    String? ownerId;
    if (authState is Authenticated) {
      ownerId = authState.user.id;
    }

    return BlocProvider(
      create: (context) => sl<OwnerHotelBloc>()..add(GetOwnerHotelsEvent(ownerId ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Hotels'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Navigate to Add Hotel
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddEditHotelPage()),
                    ).then((_) {
                       // Refresh list after return
                       if (ownerId != null) {
                        context.read<OwnerHotelBloc>().add(GetOwnerHotelsEvent(ownerId));
                       }
                    });
                  },
                );
              }
            ),
          ],
        ),
        body: BlocBuilder<OwnerHotelBloc, OwnerHotelState>(
          builder: (context, state) {
            if (state is OwnerHotelLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OwnerHotelError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is OwnerHotelsLoaded) {
              if (state.hotels.isEmpty) {
                return const Center(child: Text('No hotels found. Add one!'));
              }
              return ListView.builder(
                itemCount: state.hotels.length,
                itemBuilder: (context, index) {
                  final hotel = state.hotels[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const Icon(Icons.hotel),
                      title: Text(hotel.name),
                      subtitle: Text('${hotel.location} • ${hotel.status.name}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                               Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => AddEditHotelPage(hotel: hotel)),
                              ).then((_) {
                                 if (ownerId != null) {
                                  context.read<OwnerHotelBloc>().add(GetOwnerHotelsEvent(ownerId));
                                 }
                              });
                            },
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      onTap: () {
                        // Navigate to Rooms
                         Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RoomManagementPage(hotelId: hotel.id)),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Please log in as owner.'));
          },
        ),
      ),
    );
  }
}
