import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/owner_hotel.dart';
import '../bloc/owner_hotel/owner_hotel_bloc.dart';
import '../bloc/owner_hotel/owner_hotel_event.dart';
import '../bloc/owner_hotel/owner_hotel_state.dart';

class AddEditHotelPage extends StatefulWidget {
  final OwnerHotel? hotel;

  const AddEditHotelPage({super.key, this.hotel});

  @override
  State<AddEditHotelPage> createState() => _AddEditHotelPageState();
}

class _AddEditHotelPageState extends State<AddEditHotelPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  
  // Minimal fields for now
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hotel?.name ?? '');
    _locationController = TextEditingController(text: widget.hotel?.location ?? '');
    _descriptionController = TextEditingController(text: widget.hotel?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.hotel != null;
    
    return BlocProvider(
      create: (context) => sl<OwnerHotelBloc>(),
      child: BlocConsumer<OwnerHotelBloc, OwnerHotelState>(
        listener: (context, state) {
          if (state is OwnerHotelOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).pop();
          } else if (state is OwnerHotelError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Edit Hotel' : 'Add Hotel'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Hotel Name'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                       validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                       validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    if (state is OwnerHotelLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is! Authenticated) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Not authenticated')),
                              );
                              return;
                            }
                            
                            final hotel = OwnerHotel(
                              id: widget.hotel?.id ?? '', // ID ignored on create
                              ownerId: authState.user.id,
                              name: _nameController.text,
                              location: _locationController.text,
                              description: _descriptionController.text,
                              images: const [], // Placeholder
                              amenities: const [], // Placeholder
                              status: HotelStatus.active,
                              createdAt: widget.hotel?.createdAt ?? DateTime.now(),
                            );
                            
                            if (isEditing) {
                              context.read<OwnerHotelBloc>().add(UpdateOwnerHotelEvent(hotel));
                            } else {
                              context.read<OwnerHotelBloc>().add(CreateOwnerHotelEvent(hotel));
                            }
                          }
                        },
                        child: Text(isEditing ? 'Update' : 'Create'),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
