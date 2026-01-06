import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/screens/home_screen.dart'; // NUEVA IMPORTACIÓN
import 'package:huerto_app/themes/app_font.dart';

void main() => runApp(const MyApp());

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
      home: const HomeScreen(), // Clase importada
    );
  }
}
