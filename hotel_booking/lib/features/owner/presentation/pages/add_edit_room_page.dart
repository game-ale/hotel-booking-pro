import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/room.dart';
import '../bloc/room/room_bloc.dart';
import '../bloc/room/room_event.dart';
import '../bloc/room/room_state.dart';

class AddEditRoomPage extends StatefulWidget {
  final String hotelId;
  final Room? room;

  const AddEditRoomPage({super.key, required this.hotelId, this.room});

  @override
  State<AddEditRoomPage> createState() => _AddEditRoomPageState();
}

class _AddEditRoomPageState extends State<AddEditRoomPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _capacityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room?.name ?? '');
    _descriptionController = TextEditingController(text: widget.room?.description ?? '');
    _priceController = TextEditingController(text: widget.room?.price.toString() ?? '');
    _capacityController = TextEditingController(text: widget.room?.capacity.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.room != null;

    return BlocProvider(
      create: (context) => sl<RoomBloc>(), // We just need add/update ability
      child: BlocConsumer<RoomBloc, RoomState>(
        listener: (context, state) {
          if (state is RoomOperationSuccess) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).pop();
          } else if (state is RoomError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Edit Room' : 'Add Room'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Room Name'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 2,
                         validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price per night'),
                        keyboardType: TextInputType.number,
                         validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: _capacityController,
                        decoration: const InputDecoration(labelText: 'Capacity (persons)'),
                        keyboardType: TextInputType.number,
                         validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),
                       if (state is RoomLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final price = double.tryParse(_priceController.text) ?? 0.0;
                              final capacity = int.tryParse(_capacityController.text) ?? 1;

                              final room = Room(
                                id: widget.room?.id ?? '',
                                hotelId: widget.hotelId,
                                name: _nameController.text,
                                description: _descriptionController.text,
                                price: price,
                                capacity: capacity,
                                amenities: widget.room?.amenities ?? [], // Placeholder
                                images: widget.room?.images ?? [], // Placeholder
                                isAvailable: widget.room?.isAvailable ?? true,
                              );

                              if (isEditing) {
                                context.read<RoomBloc>().add(UpdateRoomEvent(room));
                              } else {
                                context.read<RoomBloc>().add(AddRoomEvent(room));
                              }
                            }
                          },
                          child: Text(isEditing ? 'Update' : 'Add'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
