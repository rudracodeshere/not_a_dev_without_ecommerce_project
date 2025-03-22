import 'dart:developer';
import 'package:e_commerce_project/screens/gender_age.dart';
import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 110, horizontal: 16),
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
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 20),
                  _buildTextField('First Name', (value) => firstName = value),
                  const SizedBox(height: 20),
                  _buildTextField('Last Name', (value) => lastName = value),
                  const SizedBox(height: 20),
                  _buildTextField('Email Address', (value) => email = value, isEmail: true),
                  const SizedBox(height: 20),
                  _buildTextField('Password', (value) => password = value, isPassword: true),
                  const SizedBox(height: 20),
                  _buildContinueButton(context),
                  const SizedBox(height: 20),
                  _buildSignInText(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Create Account',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildTextField(String hint, Function(String) onSaved, {bool isEmail = false, bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter your $hint' : null,
      onSaved: (value) => onSaved(value!),
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.black),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            log('$firstName $lastName $email $password');

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GenderAgePage(
                  firstName: firstName!,
                  lastName: lastName!,
                  email: email!,
                  password: password!,
                ),
              ),
            );
          }
        },
        child: const Text('Continue'),
      ),
    );
  }

  Widget _buildSignInText(BuildContext context) {
    return RichText(
      textScaleFactor: 1.1,
      text: TextSpan(
        children: [
          const TextSpan(text: "Do you have an account? "),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pop(),
            text: 'Sign In!',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
