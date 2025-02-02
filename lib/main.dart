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
      ),
      home: const RegistrationPage(), // Start with the registration page
    );
  }
}
