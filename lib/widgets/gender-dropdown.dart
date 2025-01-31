import 'package:flutter/material.dart';

class GenderDropdown extends StatelessWidget {
  final TextEditingController genderController;

  const GenderDropdown({Key? key, required this.genderController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: genderController.text.isEmpty ? null : genderController.text,
      onChanged: (String? newValue) {
        genderController.text = newValue!;
      },
      decoration: const InputDecoration(labelText: 'Gender'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
      items: const [
        DropdownMenuItem(
          value: 'M',
          child: Text('Male'),
        ),
        DropdownMenuItem(
          value: 'F',
          child: Text('Female'),
        ),
      ],
    );
  }
}
