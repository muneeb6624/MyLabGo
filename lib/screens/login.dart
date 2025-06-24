import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mylab_go/main.dart';
import 'package:mylab_go/widgets/custom-form-field.dart';
import 'package:mylab_go/widgets/custom_app_bar.dart';
import 'registration.dart';
import 'home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/firebase_auth.dart'; // adjust path if different

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = FirebaseAuthService();
      final user = await authService.loginWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // 🔍 Step 1: Try to find user in LabData
        final labDoc = await FirebaseFirestore.instance
            .collection('LabData')
            .doc(user.uid)
            .get();

        if (labDoc.exists && labDoc.data()!['role'] == 'labadmin') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🎉 Lab Admin Login Successful!')),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          });
          return;
        }

        // 🔍 Step 2: Check if it's a regular user
        final userDoc = await FirebaseFirestore.instance
            .collection('UserData')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data()!['role'] == 'user') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Logged in as regular user')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          // Redirect to another user screen if exists:
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserHomePage()));
          return;
        }

        // ❌ If neither doc exists or no valid role
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Unknown user role or access denied.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Login failed. Check credentials.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'MyLabGo'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Login Account',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      CustomFormField(
                        controller: _emailController,
                        label: AppLocalizations.of(context)!.email,
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 10),
                      CustomFormField(
                        controller: _passwordController,
                        label: AppLocalizations.of(context)!.password,
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      buildCustomButton(
                        AppLocalizations.of(context)!.login,
                        Icons.check,
                        Colors.cyan,
                        Colors.black,
                        _submitForm,
                      ),
                      const SizedBox(height: 10),
                      buildCustomButton(
                        AppLocalizations.of(context)!.login_using_camera,
                        Icons.camera_alt,
                        Colors.green,
                        Colors.black,
                        () => Navigator.pushNamed(context, '/face-login'),
                      ),
                      const SizedBox(height: 10),
                      buildCustomButton(
                        AppLocalizations.of(context)!.login_as_lab,
                        Icons.medical_services,
                        Colors.orange,
                        Colors.black,
                        () {}, // if this button is for lab-only login flow, we can reuse the role-based logic too
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text:
                              AppLocalizations.of(context)!.do_not_have_account,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.signup,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegistrationPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomButton(
    String text,
    IconData icon,
    Color buttonColor,
    Color iconColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Icon(icon, size: 33, color: iconColor),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
