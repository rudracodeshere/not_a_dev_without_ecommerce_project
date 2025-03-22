import 'dart:developer';
import 'dart:ui';
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
    final keyBoardHeight =  MediaQuery.of(context).viewInsets.bottom;
  final double topPad = keyBoardHeight == 0 ? 110 : 100;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(),
        body: Container(
          height: double.infinity,
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
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: topPad, horizontal: 16),
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
                    const SizedBox(height: 20), // Added extra padding at bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Create Account',
      style: TextStyle(
        fontSize: 32, 
        fontWeight: FontWeight.bold, 
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildTextField(String hint, Function(String) onSaved, {bool isEmail = false, bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      onSaved: (value) => onSaved(value ?? ''),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7), 
          fontWeight: FontWeight.bold
        ),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _formKey.currentState!.save();
          
          if (firstName == null || firstName!.isEmpty ||
              lastName == null || lastName!.isEmpty ||
              email == null || email!.isEmpty ||
              password == null || password!.isEmpty) {
            
            // Close keyboard first
            FocusScope.of(context).unfocus();
            
            // Store context reference before the async gap
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final theme = Theme.of(context);
            
            // Now we use the stored references in the callback
            Future.delayed(const Duration(milliseconds: 100), () {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'Please fill in all fields',
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                  backgroundColor: theme.colorScheme.errorContainer,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          } else {
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
        ),
        child: const Text('Continue'),
      ),
    );
  }

  Widget _buildSignInText(BuildContext context) {
    return RichText(
      textScaleFactor: 1.1,
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
