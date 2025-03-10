import 'package:flutter/material.dart';
import 'package:mylab_go/screens/registration.dart';
import 'package:mylab_go/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Lab Go!',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue).copyWith(
          secondary: Colors.lightBlueAccent,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor:
            Colors.transparent, // Set scaffold background to transparent
      ),
      home: const GradientBackground(
          child: RegistrationPage()), // Start with the registration page
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFDFEFF), // Color Gradient left
            Color(0xFFDFF6F9), // Right
          ],
        ),
      ),
      child: child,
    );
  }
}
