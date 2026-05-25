import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:huerto_app/screens/home_screen.dart';
import 'package:huerto_app/screens/login_screen.dart';
import 'package:huerto_app/services/firebase_startup_service.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:huerto_app/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    debugPrint('No se pudo cargar el archivo .env.');
  }

  try {
    final initialized = await FirebaseStartupService.initialize();
    if (!initialized) {
      debugPrint(
        'Firebase no pudo inicializarse. Revisa FIREBASE_SETUP.md y tu configuracion nativa.',
      );
    }
  } catch (e) {
    debugPrint(
      'Firebase no pudo inicializarse. Error inesperado: $e',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huerto App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 2).theme().copyWith(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedLabelStyle: AppFont.bottomNavSelected,
              unselectedLabelStyle: AppFont.bottomNavUnselected,
            ),
          ),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
