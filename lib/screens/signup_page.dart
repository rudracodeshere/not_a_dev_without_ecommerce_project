import 'package:e_commerce_project/screens/enter_password.dart';
import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(),
        body: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _text(),
                SizedBox(height: 20),
                _firstNameBox(context),
                SizedBox(height: 20),
                _lastNameBox(context),
                SizedBox(height: 20),
                _emailBox(context),
                SizedBox(height: 20),
                _passwordBox(context),
                SizedBox(height: 20),
                _button(context),
                SizedBox(height: 20),
                _noAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text() {
    return Text(
      'Create Account',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _emailBox(BuildContext context) {
    return TextField(
      //autofocus: true,
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: TextStyle(
          color: Colors.grey[300],
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withOpacity(0.5),
      ),
    );
  }

  Widget _firstNameBox(BuildContext context) {
    return TextField(
      //autofocus: true,
      decoration: InputDecoration(
        hintText: 'First Name',
        hintStyle: TextStyle(
          color: Colors.grey[300],
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withOpacity(0.5),
      ),
    );
  }

  Widget _lastNameBox(BuildContext context) {
    return TextField(
      //autofocus: true,
      decoration: InputDecoration(
        hintText: 'Last Name',
        hintStyle: TextStyle(
          color: Colors.grey[300],
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withOpacity(0.5),
      ),
    );
  }

  Widget _passwordBox(BuildContext context) {
    return TextField(
      //autofocus: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.grey[300],
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withOpacity(0.5),
      ),
    );
  }

  Widget _button(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => EnterPasswordPage()));
        },
        child: Text('Continue'),
      ),
    );
  }

  Widget _noAccount(BuildContext context) {
    return RichText(
      textScaleFactor: 1.1,
      text: TextSpan(
        children: [
          TextSpan(text: "Do you have an account? "),
          TextSpan(
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pop();
                  },
            text: 'Sign In!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
