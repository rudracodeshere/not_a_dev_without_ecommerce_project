import 'package:e_commerce_project/providers/splash_cubit.dart';
import 'package:e_commerce_project/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final kColorSchemeLight = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 231, 162, 34),
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        theme: ThemeData.from(colorScheme: kColorSchemeLight),
        themeMode: ThemeMode.system,
        home: SplashScreen(),
      ),
    );
  }
}
