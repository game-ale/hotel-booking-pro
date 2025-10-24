import 'package:flutter/material.dart';

class HotelServicesCheckbox extends StatelessWidget {
  final Map<String, bool> selectedServices;
  final ValueChanged<Map<String, bool>> onChanged;

  const HotelServicesCheckbox({
    super.key,
    required this.selectedServices,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: selectedServices.keys.map((key) {
        return CheckboxListTile(
          title: Text(key.toUpperCase()),
          value: selectedServices[key],
          onChanged: (value) {
            final newServices = Map<String, bool>.from(selectedServices);
            newServices[key] = value ?? false;
            onChanged(newServices);
          },
        );
      }).toList(),
    );
  }
}
