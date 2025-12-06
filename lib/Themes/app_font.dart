import 'package:flutter/material.dart';
import 'package:huerto_app/Themes/app_theme.dart';

class AppFont {
  // Estilos para títulos principales
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: verdeBosque,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: verdeBosque,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: verdeBosque,
  );

  // Estilos para textos del cuerpo
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: verdeBosque,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: verdeBosque,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: verdeBosque,
  );

  // Estilos para AppBar
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: verdeBosque,
  );

  // Estilos para Botones
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: verdeBosque,
  );

  // Estilos para Cards
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: verdeBosque,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: verdeBosque,
  );

  // Estilos para BottomNavigationBar - CON MEJOR CONTRASTE
  static const TextStyle bottomNavSelected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF7A9D7C), // Color completo para seleccionado
  );

  static const TextStyle bottomNavUnselected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: verdeBosque, // Verde más claro para no seleccionado
  );

  // Método para aplicar colores de tu tema
  static TextStyle applyColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }

  // Método para aplicar tamaño personalizado
  static TextStyle applySize(TextStyle baseStyle, double size) {
    return baseStyle.copyWith(fontSize: size);
  }
}
