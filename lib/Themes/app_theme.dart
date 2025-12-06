import 'package:flutter/material.dart';

// Colores base con nombres descriptivos
const Color blancoHueso = Color.fromRGBO(227, 218, 201, 1.0); // Blanco Hueso
const Color verdeClaro = Color.fromRGBO(106, 189, 140, 1.0); // Verde Claro
const Color verdeMenta = Color.fromRGBO(136, 212, 152, 1.0); // Verde Menta
const Color verdeBosque = Color.fromRGBO(53, 93, 59, 1.0); // Verde Bosque
const Color verdeGelido = Color.fromRGBO(226, 240, 231, 1.0); // Verde Gelido
const Color sombraVerde = Color.fromRGBO(76, 175, 80, 1.0); // Sombra Verde
const Color verdeSeco = Color.fromRGBO(169, 182, 74, 1.0); // Verde pasto seco
const Color verdeSF =
    Color.fromRGBO(141, 148, 64, 1.0); // Verde pasto seco fuerte

const Color forestDepth = Color(0xFF1B5E20); // Verde bosque profundo
const Color emeraldLeaf = Color(0xFF2E7D32); // Verde esmeralda
const Color freshMint = Color(0xFF4CAF50); // Verde menta fresco
const Color springGrass = Color(0xFF66BB6A); // Verde hierba primavera
const Color lightSage = Color(0xFF81C784); // Verde salvia claro
const Color paleOlive = Color(0xFFAED581); // Verde oliva pálido

// Tierras y Marrones - Base y estabilidad
const Color richSoil = Color(0xFF4E342E); // Marrón tierra rica
const Color warmClay = Color(0xFF6D4C41); // Marrón arcilla cálido
const Color oakWood = Color(0xFF795548); // Marrón roble natural
const Color sandyBeach = Color(0xFFA1887F); // Beige arena playa

// Azules - Cielo y agua
const Color deepSky = Color(0xFF0277BD); // Azul cielo profundo
const Color clearBlue = Color(0xFF29B6F6); // Azul claro cristalino
const Color oceanMist = Color(0xFF4FC3F7); // Azul bruma oceánica

// Acentos y Flores
const Color sunflower = Color(0xFFFFB300); // Amarillo girasol
const Color goldenSun = Color(0xFFFFD54F); // Amarillo sol dorado
const Color tomatoRed = Color(0xFFE53935); // Rojo tomate maduro
const Color berryPink = Color(0xFFEC407A); // Rosa frutilla

// Neutros y Bases
const Color cloudWhite = Color(0xFFFAFAFA); // Blanco nube
const Color paperCream = Color(0xFFF5F5F5); // Crema papel natural
const Color stoneGray = Color(0xFF78909C); // Gris piedra

const List<Color> colorThemes = [
  blancoHueso, // 0 - Blanco hueso
  verdeClaro, // 1 - Verde claro
  verdeMenta, // 2 - Verde menta
  verdeBosque, // 3 - Verde bosque (oscuro)
  verdeGelido, // 4 - Verde gélido (muy claro)
  sombraVerde, // 5 - Sombra verde
  verdeSeco, // 6 - Verde seco
  verdeSF, // 7 - Verde Seco Oscuro
  forestDepth, // 8 - Verde bosque profundo
  emeraldLeaf, // 9 - Verde esmeralda
  freshMint, // 10 - Verde menta fresco
  springGrass, // 11 - Verde hierba primavera
  lightSage, // 12 - Verde salvia claro
  paleOlive, // 13 - Verde oliva pálido
  richSoil, // 14 - Marrón tierra rica
  warmClay, // 15 - Marrón arcilla cálido
  oakWood, // 16 - Marrón roble natural
  sandyBeach, // 17 - Beige arena playa
  deepSky, // 18 - Azul cielo profundo
  clearBlue, // 19 - Azul claro cristalino
  oceanMist, // 20 - Azul bruma oceánica
  sunflower, // 21 - Amarillo girasol
  goldenSun, // 22 - Amarillo sol dorado
  tomatoRed, // 23 - Rojo tomate maduro
  berryPink, // 24 - Rosa frutilla
  cloudWhite, // 25 - Blanco nube
  paperCream, // 26 - Crema papel natural
  stoneGray, // 27 - Gris piedra
];

// Mapa de nombres para referencia fácil
const Map<int, String> colorNames = {
  0: 'Blanco Hueso',
  1: 'Verde Claro',
  2: 'Verde Menta',
  3: 'Verde Bosque',
  4: 'Verde Gélido',
  5: 'Sombra Verde',
  6: 'Verde Seco',
  7: 'Verde Seco Oscuro',
  8: 'Verde Bosque Profundo',
  9: 'Verde Esmeralda',
  10: 'Verde Menta Fresco',
  11: 'Verde Hierba Primavera',
  12: 'Verde Salvia Claro',
  13: 'Verde Oliva Pálido',
  14: 'Marrón Tierra Rica',
  15: 'Marrón Arcilla Cálido',
  16: 'Marrón Roble Natural',
  17: 'Beige Arena Playa',
  18: 'Azul Cielo Profundo',
  19: 'Azul Claro Cristalino',
  20: 'Azul Bruma Oceánica',
  21: 'Amarillo Girasol',
  22: 'Amarillo Sol Dorado',
  23: 'Rojo Tomate Maduro',
  24: 'Rosa Frutilla',
  25: 'Blanco Nube',
  26: 'Crema Papel Natural',
  27: 'Gris Piedra',
};

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(
          selectedColor >= 0 && selectedColor <= colorThemes.length - 1,
          'Colors must be between 0 to ${colorThemes.length - 1}',
        );

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: colorThemes[selectedColor],
    );
  }

  // Método útil para obtener el nombre del color seleccionado
  String get selectedColorName => colorNames[selectedColor] ?? 'Desconocido';

  // Método para obtener un color específico por índice
  static Color getColorByIndex(int index) {
    if (index >= 0 && index < colorThemes.length) {
      return colorThemes[index];
    }
    return colorThemes[0]; // Color por defecto
  }
}
