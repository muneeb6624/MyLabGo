import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylab_go/widgets/language_toggle.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFDFEFF),
              Color(0xFFDFF6F9),
            ],
          ),
        ),
        child: SafeArea(
          child: Directionality(
            // 👈 This line is the hero
            textDirection:
                TextDirection.ltr, // Force left-to-right only for AppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Always left
                  Image.asset(
                    'assets/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  // Always centered
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: GoogleFonts.cabinSketch(
                          textStyle: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00ACC1),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Always right
                  const LanguageToggle(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
