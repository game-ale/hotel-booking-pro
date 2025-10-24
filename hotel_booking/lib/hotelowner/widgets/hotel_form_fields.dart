import 'package:flutter/material.dart';

class HotelFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController chargeController;
  final TextEditingController descriptionController;

  const HotelFormFields({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.chargeController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Hotel Name"),
          validator: (v) => v!.isEmpty ? "Enter hotel name" : null,
        ),
        TextFormField(
          controller: chargeController,
          decoration: const InputDecoration(labelText: "Room Charge"),
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? "Enter charge" : null,
        ),
        TextFormField(
          controller: addressController,
          decoration: const InputDecoration(labelText: "Address"),
          validator: (v) => v!.isEmpty ? "Enter address" : null,
        ),
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(labelText: "Description"),
          maxLines: 3,
          validator: (v) => v!.isEmpty ? "Enter description" : null,
        ),
      ],
    );
  }
}
