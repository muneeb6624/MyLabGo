import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mylab_go/main.dart';
import 'package:mylab_go/screens/login.dart';
import 'package:mylab_go/widgets/custom-form-field.dart';
import 'package:mylab_go/widgets/custom_app_bar.dart';
import 'package:mylab_go/widgets/gender-dropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import './home.dart';
import '../services/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final user = await _authService.registerWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      // Save to Firestore with role
      await FirebaseFirestore.instance
          .collection('UserData') // Use "Users" collection (not UserData)
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'age': _ageController.text.trim(),
        'gender': _genderController.text.trim(),
        'role': 'user', // 🔑 Set the role explicitly
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Registration Successful!')),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Registration failed')),
      );
    }
  }
}

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: AppLocalizations.of(context)!.app_title),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.1 * 255).toInt()), // Updated to avoid deprecated withOpacity
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.create_account,
                  style: const TextStyle(
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
                        controller: _nameController,
                        label: AppLocalizations.of(context)!.name,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10),
                      CustomFormField(
                        controller: _emailController,
                        label: AppLocalizations.of(context)!.email,
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 10),
                      CustomFormField(
                        controller: _ageController,
                        label: AppLocalizations.of(context)!.age,
                        icon: Icons.cake,
                      ),
                      const SizedBox(height: 10),
                      GenderDropdown(genderController: _genderController),
                      const SizedBox(height: 10),
                      CustomFormField(
                        controller: _passwordController,
                        label: AppLocalizations.of(context)!.password,
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      CustomFormField(
                        controller: _confirmPasswordController,
                        label: AppLocalizations.of(context)!.confirm_password,
                        icon: Icons.lock,
                      ),
                      const SizedBox(height: 10),
                      buildCustomButton(
                        AppLocalizations.of(context)!.register,
                        Icons.check,
                        Colors.cyan,
                        Colors.black,
                        _submitForm,
                      ),
                      const SizedBox(height: 10),
                      buildCustomButton(
                        AppLocalizations.of(context)!.register_using_camera,
                        Icons.camera_alt,
                        Colors.green,
                        Colors.black,
                        () => Navigator.pushNamed(context, '/face-register'),
                      ),
                      const SizedBox(height: 10),
                        buildCustomButton(
                        AppLocalizations.of(context)!.register_as_lab,
                        Icons.medical_services,
                        Colors.orange,
                        Colors.black,
                        () async {
                          const url = 'https://mylabgo-admin.vercel.app/register';
                          if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not launch URL')),
                          );
                          }
                        },
                        ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!
                              .already_have_account,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.login,
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
                                      builder: (context) => const LoginPage(),
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
