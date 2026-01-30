// Importa el paquete de Flutter, necesario para desarrollar aplicaciones Flutter
import 'package:flutter/material.dart';
// Importa el tema personalizado de la aplicación
import 'package:huerto_app/themes/app_theme.dart';
// Importa la pantalla de inicio (HomeScreen) que se mostrará al abrir la app
import 'package:huerto_app/screens/home_screen.dart';
// Importa las fuentes tipográficas personalizadas de la aplicación
import 'package:huerto_app/themes/app_font.dart';

// Función principal que inicia la aplicación Flutter
void main() => runApp(const MyApp());

// Clase principal de la aplicación, que extiende StatelessWidget (sin estado interno)
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor con una llave (key) opcional

  @override
  Widget build(BuildContext context) {
    // Retorna un MaterialApp, widget raíz de una app Flutter con diseño Material
    return MaterialApp(
      title: 'Huerto App', // Título visible en el switcher de apps del sistema
      debugShowCheckedModeBanner:
          false, // Oculta la bandera "DEBUG" en modo release
      theme: AppTheme(selectedColor: 2).theme().copyWith(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedLabelStyle: AppFont
                  .bottomNavSelected, // Estilo de texto para etiqueta seleccionada
              unselectedLabelStyle: AppFont
                  .bottomNavUnselected, // Estilo para etiquetas no seleccionadas
            ),
          ),
      home: const HomeScreen(), // Pantalla inicial al abrir la aplicación
    );
  }
}
