import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import 'forgot_password.dart';

class EnterPasswordPage extends StatefulWidget {
  final String email;
  const EnterPasswordPage({super.key, required this.email});

  @override
  State<EnterPasswordPage> createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: _passwordController.text.trim(),
      );
      // Successful sign in; the auth state listener elsewhere will update the UI.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        body: Container(
          height: size.height, // Force container to fill full screen height
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
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
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
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 50 : 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Sign In',
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
                          style:
                              TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          children: [
                            const TextSpan(text: "Forgot Password? "),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordPage(),
                                      ),
                                    ),
                              text: 'Reset',
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
    );
  }
}
