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
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.wc),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
      items: [
        DropdownMenuItem(
          value: 'M',
          child: Row(
            children: const [
              Icon(Icons.male, color: Colors.blue),
              SizedBox(width: 8),
              Text('Male'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'F',
          child: Row(
            children: const [
              Icon(Icons.female, color: Colors.pink),
              SizedBox(width: 8),
              Text('Female'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'N',
          child: Row(
            children: const [
              Icon(Icons.transgender, color: Colors.grey),
              SizedBox(width: 8),
              Text('None'),
            ],
          ),
        ),
      ],
    );
  }
}
