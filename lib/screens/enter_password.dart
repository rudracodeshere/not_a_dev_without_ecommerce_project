import 'package:e_commerce_project/screens/forgot_password.dart';
import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EnterPasswordPage extends StatelessWidget {
  const EnterPasswordPage({super.key});
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
                _passwordBox(context),
                SizedBox(height: 20),
                _button(context),
                SizedBox(height: 20),
                _forgotPassword(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text() {
    return Text(
      'Sign In',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _passwordBox(BuildContext context) {
    return TextField(
      //autofocus: true,
      decoration: InputDecoration(
        hintText: 'Enter Password',
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
      child: ElevatedButton(onPressed: () {}, child: Text('Sign In')),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return RichText(
      textScaleFactor: 1.1,
      text: TextSpan(
        children: [
          TextSpan(text: "Forgot Password? "),
          TextSpan(
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ),
                    );
                  },
            text: 'Reset',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
