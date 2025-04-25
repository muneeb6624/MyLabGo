import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Adjusted height to accommodate larger logo
      child: Stack(
        children: [
          // AppBar background
          AppBar(
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: GoogleFonts.cabinSketch(
                  textStyle: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00ACC1),
                  ),
                ),
              ),
            ),
            centerTitle: true,
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
            ),
          ),

          // Logo Position
          Positioned(
            top: 10,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 80, // Adjusted width
                height: 80, // Adjusted height
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(100); // Adjusted height to accommodate larger logo
}
