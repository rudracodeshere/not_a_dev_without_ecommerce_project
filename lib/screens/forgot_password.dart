import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
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
                _emailBox(context),
                SizedBox(height: 20),
                _button(context),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text() {
    return Text(
      'Forgot Password',
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
        hintText: 'Enter Email',
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
         
        },
        child: Text('Continue'),
      ),
    );
  }


}
