import 'package:e_commerce_project/providers/splash_cubit.dart';
import 'package:e_commerce_project/providers/splash_state.dart';
import 'package:e_commerce_project/screens/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit,SplashState>(
      listener:(context, state) {
        if(state is Unauthenticated){
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SigninPage()),
          );
        }
      },
      child: Scaffold(
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
          child: Center(
            child: Image.asset(
              'assets/logo.png',
              width: MediaQuery.sizeOf(context).width * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
