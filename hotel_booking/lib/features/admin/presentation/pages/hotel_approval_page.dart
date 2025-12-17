import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/admin_hotel_bloc.dart';

class HotelApprovalPage extends StatelessWidget {
  const HotelApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminHotelBloc>()..add(const LoadAllHotels(pendingOnly: true)),
      child: Column(
        children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               children: [
                 const Text('Show Pending Only'),
                 Switch(value: true, onChanged: (val) {
                   // Toggle logic could be added here to reload bloc
                 }),
                 const Spacer(),
                 IconButton(icon: Icon(Icons.refresh), onPressed: () => context.read<AdminHotelBloc>().add(LoadAllHotels(pendingOnly: true))),
               ],
             ),
           ),
           Expanded(
             child: BlocBuilder<AdminHotelBloc, AdminHotelState>(
               builder: (context, state) {
                 if (state is AdminHotelLoading) {
                   return const Center(child: CircularProgressIndicator());
                 } else if (state is AdminHotelLoaded) {
                   if (state.hotels.isEmpty) return const Center(child: Text('No hotels found.'));
                   return ListView.builder(
                     itemCount: state.hotels.length,
                     itemBuilder: (context, index) {
                       final hotel = state.hotels[index];
                       return Card(
                         child: ListTile(
                           title: Text(hotel.name),
                           subtitle: Text('${hotel.address}\nOwner: ${hotel.ownerId}'),
                           isThreeLine: true,
                           trailing: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               IconButton(
                                 icon: const Icon(Icons.check, color: Colors.green),
                                 onPressed: () {
                                   context.read<AdminHotelBloc>().add(ApproveHotelEvent(hotel.id, true));
                                 },
                               ),
                               IconButton(
                                 icon: const Icon(Icons.close, color: Colors.red),
                                 onPressed: () {
                                   context.read<AdminHotelBloc>().add(ApproveHotelEvent(hotel.id, false)); // Reject/Disapprove
                                 },
                               ),
                             ],
                           ),
                         ),
                       );
                     },
                   );
                 } else if (state is AdminHotelError) {
                   return Center(child: Text('Error: ${state.message}'));
                 }
                 return const SizedBox.shrink();
               },
             ),
           ),
        ],
      ),
    );
  }
}
