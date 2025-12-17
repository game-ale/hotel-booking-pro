import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/user_profile/user_profile_bloc.dart';
import '../bloc/user_profile/user_profile_event.dart';
import '../bloc/user_profile/user_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.profile.address ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserProfileBloc>(), // New instance for editing
      child: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.of(context).pop();
          } else if (state is UserProfileError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedProfile = UserProfile(
                        id: widget.profile.id,
                        email: widget.profile.email,
                        displayName: _nameController.text,
                        phoneNumber: _phoneController.text.isEmpty ? null : _phoneController.text,
                        address: _addressController.text.isEmpty ? null : _addressController.text,
                        bio: _bioController.text.isEmpty ? null : _bioController.text,
                        profileImageUrl: widget.profile.profileImageUrl,
                        dateOfBirth: widget.profile.dateOfBirth,
                      );
                      context.read<UserProfileBloc>().add(UpdateUserProfileEvent(updatedProfile));
                    }
                  },
                )
              ],
            ),
            body: state is UserProfileLoading 
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Display Name'),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(labelText: 'Phone Number'),
                            keyboardType: TextInputType.phone,
                          ),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(labelText: 'Address'),
                          ),
                          TextFormField(
                            controller: _bioController,
                            decoration: const InputDecoration(labelText: 'Bio'),
                            maxLines: 3,
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
