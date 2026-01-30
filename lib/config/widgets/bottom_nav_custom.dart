// Importaciones de paquetes necesarios
import 'package:flutter/material.dart'; // Widgets básicos de Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Tema de la aplicación
import 'package:huerto_app/themes/gradients.dart'; // Gradientes predefinidos

/*
    Barra de navegación inferior personalizada
    Con diseño de gradiente y tres opciones
*/
class CustomBottomNav extends StatelessWidget {
  // Propiedades del widget
  final int currentIndex; // Índice actual seleccionado
  final Function(int) onTap; // Función que se ejecuta al tocar un ítem

  // Constructor del widget
  const CustomBottomNav({
    super.key, // Clave para identificar el widget
    required this.currentIndex, // Índice actual obligatorio
    required this.onTap, // Función onTap obligatoria
  });

  // Método principal de construcción del widget
  @override
  Widget build(BuildContext context) {
    return Container(
      // Contenedor para el fondo con gradiente
      decoration: BoxDecoration(
        gradient: AppGradients.interactiveHover, // Gradiente para fondo
        boxShadow: AppGradients.cardShadow, // Sombra para efecto de elevación
      ),
      child: BottomNavigationBar(
        // Barra de navegación inferior estándar
        currentIndex: currentIndex, // Índice actual seleccionado
        onTap: onTap, // Función que se ejecuta al tocar
        backgroundColor:
            Colors.transparent, // Fondo transparente para mostrar gradiente
        elevation: 0, // Sin elevación (la sombra está en el contenedor)
        selectedItemColor: forestDepth, // Color para ítem seleccionado
        unselectedItemColor: forestDepth, // Color para ítems no seleccionados
        items: const [
          // Definición de los ítems de navegación
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios_new), // Icono de "Anterior"
            label: 'Anterior', // Etiqueta de "Anterior"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icono de "Inicio"
            label: 'Inicio', // Etiqueta de "Inicio"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), // Icono de "Cuenta"
            label: 'Cuenta', // Etiqueta de "Cuenta"
          ),
        ],
      ),
    );
  }
}
