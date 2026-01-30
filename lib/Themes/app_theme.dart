// Importa el paquete de Flutter para widgets y Material Design
import 'package:flutter/material.dart';

/*
  COLORES BASE CON NOMBRES DESCRIPTIVOS
*/

// Color blanco hueso cálido (RGB con opacidad 1.0)
const Color blancoHueso = Color.fromRGBO(227, 218, 201, 1.0);
// Color verde claro para elementos destacados
const Color verdeClaro = Color.fromRGBO(106, 189, 140, 1.0);
// Color verde menta suave
const Color verdeMenta = Color.fromRGBO(136, 212, 152, 1.0);
// Color verde bosque oscuro principal
const Color verdeBosque = Color.fromRGBO(53, 93, 59, 1.0);
// Color verde gélido muy claro para fondos
const Color verdeGelido = Color.fromRGBO(226, 240, 231, 1.0);
// Color verde sombra para profundidad
const Color sombraVerde = Color.fromRGBO(76, 175, 80, 1.0);
// Color verde pasto seco para contrastes
const Color verdeSeco = Color.fromRGBO(169, 182, 74, 1.0);
// Color verde pasto seco fuerte
const Color verdeSF = Color.fromRGBO(141, 148, 64, 1.0);

// Verde bosque profundo (formato hexadecimal)
const Color forestDepth = Color(0xFF1B5E20);
// Verde esmeralda vibrante
const Color emeraldLeaf = Color(0xFF2E7D32);
// Verde menta fresco
const Color freshMint = Color(0xFF4CAF50);
// Verde hierba primavera
const Color springGrass = Color(0xFF66BB6A);
// Verde salvia claro
const Color lightSage = Color(0xFF81C784);
// Verde oliva pálido
const Color paleOlive = Color(0xFFAED581);

// Marrón tierra rica
const Color richSoil = Color(0xFF4E342E);
// Marrón arcilla cálido
const Color warmClay = Color(0xFF6D4C41);
// Marrón roble natural
const Color oakWood = Color(0xFF795548);
// Beige arena playa
const Color sandyBeach = Color(0xFFA1887F);

// Azul cielo profundo
const Color deepSky = Color(0xFF0277BD);
// Azul claro cristalino
const Color clearBlue = Color(0xFF29B6F6);
// Azul bruma oceánica
const Color oceanMist = Color(0xFF4FC3F7);

// Amarillo girasol vibrante
const Color sunflower = Color(0xFFFFB300);
// Amarillo sol dorado
const Color goldenSun = Color(0xFFFFD54F);
// Rojo tomate maduro
const Color tomatoRed = Color(0xFFE53935);
// Rosa frutilla
const Color berryPink = Color(0xFFEC407A);

// Blanco nube puro
const Color cloudWhite = Color(0xFFFAFAFA);
// Crema papel natural
const Color paperCream = Color(0xFFF5F5F5);
// Gris piedra neutro
const Color stoneGray = Color(0xFF78909C);

// Lista que contiene todos los colores disponibles para seleccionar como tema
const List<Color> colorThemes = [
  blancoHueso, // 0 - Primer color de la lista
  verdeClaro, // 1 - Índice 1
  verdeMenta, // 2 - Índice 2
  verdeBosque, // 3 - Índice 3
  verdeGelido, // 4 - Índice 4
  sombraVerde, // 5 - Índice 5
  verdeSeco, // 6 - Índice 6
  verdeSF, // 7 - Índice 7
  forestDepth, // 8 - Índice 8
  emeraldLeaf, // 9 - Índice 9
  freshMint, // 10 - Índice 10
  springGrass, // 11 - Índice 11
  lightSage, // 12 - Índice 12
  paleOlive, // 13 - Índice 13
  richSoil, // 14 - Índice 14
  warmClay, // 15 - Índice 15
  oakWood, // 16 - Índice 16
  sandyBeach, // 17 - Índice 17
  deepSky, // 18 - Índice 18
  clearBlue, // 19 - Índice 19
  oceanMist, // 20 - Índice 20
  sunflower, // 21 - Índice 21
  goldenSun, // 22 - Índice 22
  tomatoRed, // 23 - Índice 23
  berryPink, // 24 - Índice 24
  cloudWhite, // 25 - Índice 25
  paperCream, // 26 - Índice 26
  stoneGray, // 27 - Índice 27
];

/*
  MAPA DE NOMBRES PARA REFERENCIA FÁCIL
*/

// Mapa que relaciona índices numéricos con nombres descriptivos en español
const Map<int, String> colorNames = {
  0: 'Blanco Hueso', // Índice 0
  1: 'Verde Claro', // Índice 1
  2: 'Verde Menta', // Índice 2
  3: 'Verde Bosque', // Índice 3
  4: 'Verde Gélido', // Índice 4
  5: 'Sombra Verde', // Índice 5
  6: 'Verde Seco', // Índice 6
  7: 'Verde Seco Oscuro', // Índice 7
  8: 'Verde Bosque Profundo', // Índice 8
  9: 'Verde Esmeralda', // Índice 9
  10: 'Verde Menta Fresco', // Índice 10
  11: 'Verde Hierba Primavera', // Índice 11
  12: 'Verde Salvia Claro', // Índice 12
  13: 'Verde Oliva Pálido', // Índice 13
  14: 'Marrón Tierra Rica', // Índice 14
  15: 'Marrón Arcilla Cálido', // Índice 15
  16: 'Marrón Roble Natural', // Índice 16
  17: 'Beige Arena Playa', // Índice 17
  18: 'Azul Cielo Profundo', // Índice 18
  19: 'Azul Claro Cristalino', // Índice 19
  20: 'Azul Bruma Oceánica', // Índice 20
  21: 'Amarillo Girasol', // Índice 21
  22: 'Amarillo Sol Dorado', // Índice 22
  23: 'Rojo Tomate Maduro', // Índice 23
  24: 'Rosa Frutilla', // Índice 24
  25: 'Blanco Nube', // Índice 25
  26: 'Crema Papel Natural', // Índice 26
  27: 'Gris Piedra', // Índice 27
};

// Clase que maneja la configuración del tema visual de la aplicación
class AppTheme {
  final int selectedColor; // Índice del color seleccionado para el tema

  // Constructor con valor por defecto 0 y validación de rango
  AppTheme({this.selectedColor = 0})
      : assert(
          // Valida que el índice esté dentro del rango de colores disponibles
          selectedColor >= 0 && selectedColor <= colorThemes.length - 1,
          'Colors must be between 0 to ${colorThemes.length - 1}',
        );

  // Método que genera el objeto ThemeData de Flutter
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true, // Habilita Material Design 3
      colorSchemeSeed: colorThemes[selectedColor], // Color base para el esquema
    );
  }

  // Propiedad que devuelve el nombre del color seleccionado
  String get selectedColorName => colorNames[selectedColor] ?? 'Desconocido';

  // Método estático para obtener un color específico por su índice
  static Color getColorByIndex(int index) {
    // Verifica que el índice sea válido
    if (index >= 0 && index < colorThemes.length) {
      return colorThemes[index]; // Retorna el color correspondiente
    }
    return colorThemes[0]; // Color por defecto si el índice es inválido
  }
}
