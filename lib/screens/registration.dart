import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mylab_go/main.dart';
import 'package:mylab_go/screens/login.dart';
import 'package:mylab_go/widgets/custom-form-field.dart';
import 'package:mylab_go/widgets/custom_app_bar.dart';
import 'package:mylab_go/widgets/gender-dropdown.dart';
// ignore: unused_import
import '../widgets/gender_dropdown.dart';
import '../widgets/custom_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './home.dart';

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

  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // Optional: Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration Successful!')),
    );

    // Add a slight delay to allow the SnackBar to show before navigating
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
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
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      buildCustomButton(
                        AppLocalizations.of(context)!.register,
                        Icons.check,
                        Colors.cyan, // button color
                        Colors.black, // icon color
                        _submitForm,
                      ),
                      const SizedBox(height: 10),
                      buildCustomButton(
                        AppLocalizations.of(context)!.register_using_camera,
                        Icons.camera_alt,
                        Colors.green,
                        Colors.black,
                        () {},
                      ),
                      const SizedBox(height: 10),
                      buildCustomButton(
                        AppLocalizations.of(context)!.register_as_lab,
                        Icons.medical_services,
                        Colors.orange,
                        Colors.black,
                        () {},
                      ),
                      const SizedBox(height: 20),

                      /// Updated "Already have an account? Login" section
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!
                              .already_have_account,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Normal text color
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
                                        builder: (context) =>
                                            const LoginPage()),
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

  /// Custom button widget
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
            const SizedBox(width: 10), // spacing bet text and icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white, // White background for icon
                borderRadius:
                    BorderRadius.circular(5), // slightly rounded edges
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
