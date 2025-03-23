import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
          height: size.height, // Ensure container fills the screen
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
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
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
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 50 : 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement reset password logic
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                          ),
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
