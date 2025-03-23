import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 231, 162, 34),
);

Future<void> main() async {
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
    return MaterialApp(
      title: 'E-Commerce Project',
      theme: ThemeData.from(colorScheme: lightColorScheme),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
