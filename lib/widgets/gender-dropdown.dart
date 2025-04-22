import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderDropdown extends StatelessWidget {
  final TextEditingController genderController;

  const GenderDropdown({required this.genderController, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/gender.png', // main gender icon
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value:
                  genderController.text.isEmpty ? null : genderController.text,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.gender,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
              ),
              items: [
                DropdownMenuItem(
                  value: 'Male',
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/male.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.male),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/female.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.female),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Other',
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/transgender.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.other),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                genderController.text = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your gender';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
