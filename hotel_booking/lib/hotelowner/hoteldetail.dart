import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_booking/Services/hotel_service.dart';
import 'widgets/hotel_form_fields.dart';
import 'widgets/hotel_services_checkbox.dart';
import 'widgets/image_uploader.dart';
import 'widgets/submit_button.dart';
import '../pages/home.dart'; // ✅ Navigate after submit

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({super.key});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _chargeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Map<String, bool> _services = {
    'wifi': false,
    'hdtv': false,
    'kitchen': false,
    'bathroom': false,
  };

  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload an image")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      setState(() => _isLoading = false);
      return;
    }

    final success = await HotelService().addHotel(
      hotelName: _nameController.text.trim(),
      roomCharge: double.tryParse(_chargeController.text) ?? 0.0,
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim(),
      services: _services,
      imageUrl: _imageUrl!,
      ownerId: user.uid,
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hotel added successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save hotel")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Hotel Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ImageUploader(
                onImageUploaded: (url) => setState(() => _imageUrl = url),
              ),
              const SizedBox(height: 16),
              HotelFormFields(
                nameController: _nameController,
                addressController: _addressController,
                chargeController: _chargeController,
                descriptionController: _descriptionController,
              ),
              const SizedBox(height: 16),
              HotelServicesCheckbox(
                selectedServices: _services,
                onChanged: (newServices) => setState(() => _services = newServices),
              ),
              const SizedBox(height: 24),
              SubmitButton(
                isLoading: _isLoading,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
