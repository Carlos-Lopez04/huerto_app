// Importa el paquete de Flutter, necesario para desarrollar aplicaciones Flutter
import 'package:flutter/material.dart';
// Importa el tema personalizado de la aplicación
import 'package:huerto_app/themes/app_theme.dart';
// Importa la pantalla de inicio (HomeScreen) que se mostrará al abrir la app
import 'package:huerto_app/screens/home_screen.dart';
// Importa las fuentes tipográficas personalizadas de la aplicación
import 'package:huerto_app/themes/app_font.dart';
// Importa el paquete para cargar variables de entorno desde archivo .env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Importa la pantalla de login
import 'package:huerto_app/screens/login_screen.dart';
// Importa el servicio de autenticación

// Función principal que inicia la aplicación Flutter
// Se agrega 'async' porque await para cargar el archivo .env
void main() async {
  // Inicializar WidgetsBinding
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno desde el archivo .env en la raíz del proyecto
  // El método load() es asíncrono y puede lanzar excepciones si el archivo no existe
  try {
    await dotenv.load(fileName: ".env");
    print('✅ Archivo .env cargado correctamente');
    print('🔑 API Key configurada: ${dotenv.env['API_KEY'] != null ? 'Sí' : 'No'}');
  } catch (e) {
    print('❌ Error al cargar archivo .env: $e');
    // La app sigue funcionando, pero las funciones que requieran API no funcionarán
  }
  
  runApp(const MyApp());
}

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
      // Cambiar HomeScreen por LoginScreen como pantalla inicial
      home: const LoginScreen(),
      // Configurar rutas adicionales (opcional)
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}