import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool isPassword; // For password fields

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword, // Hide text for password fields
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
