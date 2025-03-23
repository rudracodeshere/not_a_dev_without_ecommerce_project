import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'gender_age.dart';
import '../../widgets/custom_appbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildContinueButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 50 : 60,
      child: ElevatedButton(
        onPressed: () {
          if (_firstNameController.text.isEmpty ||
              _lastNameController.text.isEmpty ||
              _emailController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            FocusScope.of(context).unfocus();
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final theme = Theme.of(context);
            Future.delayed(const Duration(milliseconds: 100), () {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'Please fill in all fields',
                    style:
                        TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                  backgroundColor: theme.colorScheme.errorContainer,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          } else {
            final firstName = _firstNameController.text.trim();
            final lastName = _lastNameController.text.trim();
            final email = _emailController.text.trim();
            final password = _passwordController.text;
            log('$firstName $lastName $email $password');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GenderAgePage(
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                  password: password,
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInText() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          children: [
            const TextSpan(text: "Do you have an account? "),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).pop(),
              text: 'Sign In!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final _keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.03,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_keyboardVisible) _topHeading(),
                    _buildTextField(
                        controller: _firstNameController, hint: 'First Name'),
                    const SizedBox(height: 20),
                    _buildTextField(
                        controller: _lastNameController, hint: 'Last Name'),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        isPassword: true),
                    const SizedBox(height: 40),
                    _buildContinueButton(isSmallScreen),
                    const SizedBox(height: 30),
                    _buildSignInText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
