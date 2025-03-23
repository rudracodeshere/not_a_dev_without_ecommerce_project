import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'enter_password.dart';
import 'signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Container(
          height: size.height, // Force container to fill the entire screen
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.03,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height - MediaQuery.of(context).padding.vertical,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.5),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: isSmallScreen ? 50 : 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EnterPasswordPage(
                                    email: _emailController.text.trim(),
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
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SignupPage(),
                                        ),
                                      ),
                                text: 'Create One!',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
