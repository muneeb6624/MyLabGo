import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mylab_go/provider/locale_provider.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final isEnglish = provider.locale.languageCode == 'en';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isEnglish ? 'اردو' : 'English',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Switch(
          value: isEnglish,
          onChanged: (value) {
            provider.toggleLocale();
          },
          activeColor: Colors.teal,
          inactiveThumbColor: Colors.teal,
        ),
      ],
    );
  }
}
