// Importa el paquete de Flutter para widgets y Material Design
import 'package:flutter/material.dart';
// Importa el tema personalizado que contiene los colores definidos
import 'package:huerto_app/themes/app_theme.dart';

// Clase que centraliza todos los estilos de texto reutilizables
class AppFont {
  /*
    ESTILOS PARA TÍTULOS PRINCIPALES
  */

  // Título grande para encabezados principales
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20, // Tamaño grande para destacar
    fontWeight: FontWeight.bold, // Negrita para énfasis
    color: verdeBosque, // Color verde bosque de la paleta
  );

  // Título mediano para subtítulos importantes
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18, // Tamaño mediano estándar
    fontWeight: FontWeight.w600, // Peso seminegrita
    color: verdeBosque, // Mismo color para consistencia visual
  );

  // Título pequeño para encabezados secundarios
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16, // Tamaño pequeño pero legible
    fontWeight: FontWeight.w600, // Peso seminegrita
    color: verdeBosque, // Color verde bosque
  );

  /*
    ESTILOS PARA TEXTOS DEL CUERPO
  */

  // Texto grande para contenido principal
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, // Tamaño legible para contenido
    fontWeight: FontWeight.bold, // Negrita para visibilidad
    color: verdeBosque, // Verde bosque
  );

  // Texto mediano para contenido estándar
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, // Tamaño estándar para texto
    fontWeight: FontWeight.bold, // Negrita
    color: verdeBosque, // Color consistente
  );

  // Texto pequeño para notas o información secundaria
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, // Tamaño compacto
    fontWeight: FontWeight.bold, // Negrita para contraste
    color: verdeBosque, // Verde bosque
  );

  /*
    ESTILOS PARA APP BAR
  */

  // Estilo para el título en la barra de aplicación
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18, // Tamaño apropiado para AppBar
    fontWeight: FontWeight.bold, // Negrita para destacar
    color: verdeBosque, // Color que combina con el tema
  );

  /*
    ESTILOS PARA BOTONES
  */

  // Estilo para textos dentro de botones
  static const TextStyle button = TextStyle(
    fontSize: 16, // Tamaño legible en botones
    fontWeight: FontWeight.w600, // Peso medio para buen contraste
    color: verdeBosque, // Color del texto del botón
  );

  /*
    ESTILOS PARA CARDS
  */

  // Título dentro de tarjetas
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16, // Tamaño destacado en cards
    fontWeight: FontWeight.w800, // Peso extra negrita para énfasis
    color: verdeBosque, // Color verde bosque
  );

  // Subtítulo dentro de tarjetas
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14, // Tamaño ligeramente menor que el título
    fontWeight: FontWeight.w600, // Peso seminegrita
    color: verdeBosque, // Color consistente
  );

  /*
    ESTILOS PARA BOTTOMNAVIGATIONBAR - CON MEJOR CONTRASTE
  */

  // Texto seleccionado en barra de navegación inferior
  static const TextStyle bottomNavSelected = TextStyle(
    fontSize: 12, // Tamaño compacto para navegación
    fontWeight: FontWeight.w500, // Peso medio para estado activo
    color: Color(0xFF7A9D7C), // Color sólido hexadecimal para mejor contraste
  );

  // Texto no seleccionado en barra de navegación inferior
  static const TextStyle bottomNavUnselected = TextStyle(
    fontSize: 12, // Mismo tamaño que seleccionado
    fontWeight: FontWeight.w700, // Peso negrita para no seleccionado
    color: verdeBosque, // Verde más claro para estado inactivo
  );

  /*
    MÉTODO PARA APLICAR COLORES DE TU TEMA
  */

  // Método que copia un estilo base y cambia su color
  static TextStyle applyColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color); // Copia el estilo y cambia color
  }

  /*
    MÉTODO PARA APLICAR TAMAÑO PERSONALIZADO
  */

  // Método que copia un estilo base y cambia su tamaño de fuente
  static TextStyle applySize(TextStyle baseStyle, double size) {
    return baseStyle.copyWith(
        fontSize: size); // Copia el estilo y cambia tamaño
  }
}
