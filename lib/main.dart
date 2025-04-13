import 'package:e_commerce_project/models/add_to_cart_model.dart';
import 'package:e_commerce_project/models/favorite_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 231, 162, 34),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(AddToCardModelAdapter());
  Hive.registerAdapter(FavoriteProductAdapter());

  await Hive.openBox<AddToCardModel>('cartBox');
  await Hive.openBox<FavoriteProduct>('favorites');
  
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Project',
      theme: ThemeData.from(colorScheme: lightColorScheme),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
