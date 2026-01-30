// Importa el paquete de Flutter para widgets y Material Design
import 'package:flutter/material.dart';
// Importa el archivo de tema para acceder a los colores definidos
import 'app_theme.dart';

// Clase que centraliza todos los gradientes y efectos visuales reutilizables
class AppGradients {
  /*
    GRADIENTES PARA CARDS Y CONTENEDORES
  */

  /// Gradiente suave para cards principales
  static Gradient get cardPrimary => LinearGradient(
        colors: [
          cloudWhite, // Blanco nube como color inicial
          lightSage.withOpacity(0.5), // Verde salvia claro con transparencia
        ],
        begin: Alignment.topLeft, // Punto inicial del gradiente
        end: Alignment.bottomRight, // Punto final del gradiente
        stops: const [0.0, 0.8], // Puntos de transición entre colores
      );

  /// Gradiente vibrante para cards destacadas
  static Gradient get cardHighlight => LinearGradient(
        colors: [
          emeraldLeaf.withOpacity(0.9), // Verde esmeralda con 90% opacidad
          freshMint.withOpacity(0.8), // Verde menta fresco con 80% opacidad
          springGrass
              .withOpacity(0.7), // Verde hierba primavera con 70% opacidad
        ],
        begin: Alignment.centerLeft, // Comienza en el centro izquierdo
        end: Alignment.centerRight, // Termina en el centro derecho
        stops: const [0.0, 0.6, 1.0], // Tres puntos de transición
      );

  /// Gradiente sutil para fondos de sección
  static Gradient get backgroundSoft => LinearGradient(
        colors: [
          paleOlive.withOpacity(0.1), // Verde oliva pálido muy transparente
          paperCream.withOpacity(0.8), // Crema papel con buena opacidad
          lightSage.withOpacity(0.2), // Verde salvia claro poco transparente
        ],
        begin: Alignment.topCenter, // Comienza en la parte superior central
        end: Alignment.bottomCenter, // Termina en la parte inferior central
        stops: const [0.0, 0.5, 1.0], // Transiciones equidistantes
      );

  /// Gradiente para elementos hover/activos
  static Gradient get interactiveHover => const LinearGradient(
        colors: [
          lightSage, // Verde salvia claro (inicio)
          paleOlive, // Verde oliva pálido (medio)
          cloudWhite, // Blanco nube (fin)
        ],
        begin: Alignment.topCenter, // Dirección vertical hacia abajo
        end: Alignment.bottomCenter, // Termina abajo
        stops: [0.0, 0.5, 1.0], // Puntos de transición equidistantes
      );

  /// Gradiente natural para cards de plantas
  static Gradient get plantCard => const LinearGradient(
        colors: [
          springGrass, // Verde hierba primavera
          freshMint, // Verde menta fresco
          lightSage, // Verde salvia claro
        ],
        begin: Alignment.topLeft, // Diagonal superior izquierda
        end: Alignment.bottomRight, // Diagonal inferior derecha
        stops: [0.0, 0.5, 1.0], // Transiciones suaves
      );

  /// Gradiente terroso para elementos de tierra
  static Gradient get earthyCard => LinearGradient(
        colors: [
          sandyBeach, // Beige arena playa (color claro)
          oakWood.withOpacity(0.7), // Marrón roble con 70% opacidad
          warmClay.withOpacity(0.5), // Marrón arcilla con 50% opacidad
        ],
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
        stops: const [0.0, 0.6, 1.0], // Transiciones graduales
      );

  /*
    GRADIENTES PARA BOTONES
  */

  /// Gradiente principal para botones
  static Gradient get buttonPrimary => const LinearGradient(
        colors: [
          forestDepth, // Verde bosque profundo (oscuro)
          emeraldLeaf, // Verde esmeralda (medio)
          freshMint, // Verde menta fresco (claro)
        ],
        begin: Alignment.topLeft, // Diagonal superior izquierda
        end: Alignment.bottomRight, // Diagonal inferior derecha
        stops: [0.0, 0.6, 1.0], // Puntos de transición
      );

  /// Gradiente para botones en estado hover/presionado
  static Gradient get buttonPressed => const LinearGradient(
        colors: [
          emeraldLeaf, // Verde esmeralda (inicio)
          forestDepth, // Verde bosque profundo (fin)
        ],
        begin: Alignment.bottomRight, // Comienza en esquina inferior derecha
        end: Alignment.topLeft, // Termina en esquina superior izquierda
        stops: [0.0, 0.8], // Punto de transición
      );

  /// Gradiente para botones secundarios
  static Gradient get buttonSecondary => LinearGradient(
        colors: [
          springGrass.withOpacity(0.9), // Verde hierba primavera 90% opacidad
          lightSage.withOpacity(0.8), // Verde salvia claro 80% opacidad
        ],
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
        stops: const [0.0, 0.9], // Transición larga
      );

  /// Gradiente para botones de acción positiva
  static Gradient get buttonSuccess => const LinearGradient(
        colors: [
          freshMint, // Verde menta fresco
          springGrass, // Verde hierba primavera
          emeraldLeaf, // Verde esmeralda
        ],
        begin: Alignment.topLeft, // Diagonal
        end: Alignment.bottomRight, // Diagonal opuesta
        stops: [0.0, 0.5, 1.0], // Tres colores
      );

  /// Gradiente para botones de advertencia
  static Gradient get buttonWarning => const LinearGradient(
        colors: [
          goldenSun, // Amarillo sol dorado
          sunflower, // Amarillo girasol
        ],
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
        // Sin stops definidos para transición uniforme
      );

  /// Gradiente para botones de peligro
  static Gradient get buttonDanger => LinearGradient(
        colors: [
          tomatoRed, // Rojo tomate
          berryPink.withOpacity(0.8), // Rosa frutilla 80% opacidad
        ],
        begin: Alignment.topLeft, // Comienza en esquina superior izquierda
        end: Alignment.bottomRight, // Termina en esquina inferior derecha
        // Sin stops definidos
      );

  /*
    GRADIENTES PARA APP BAR Y HEADERS
  */

  /// Gradiente para AppBar principal
  static Gradient get appBarPrimary => const LinearGradient(
        colors: [
          freshMint, // Verde menta fresco (claro)
          emeraldLeaf, // Verde esmeralda (medio)
          forestDepth, // Verde bosque profundo (oscuro)
        ],
        begin: Alignment.centerLeft, // Horizontal de izquierda a derecha
        end: Alignment.centerRight, // Termina a la derecha
        stops: [0.0, 0.5, 1.0], // Tres colores equidistantes
      );

  /// Gradiente para encabezados de sección
  static Gradient get sectionHeader => LinearGradient(
        colors: [
          forestDepth.withOpacity(0.2), // Verde bosque 20% transparente
          emeraldLeaf.withOpacity(0.3), // Verde esmeralda 30% transparente
          Colors.transparent, // Totalmente transparente al final
        ],
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
        stops: const [0.0, 0.5, 1.0], // Transiciones
      );

  /// Gradiente para footer
  static Gradient get footerGradient => LinearGradient(
        colors: [
          richSoil.withOpacity(0.8), // Marrón tierra 80% opacidad
          oakWood.withOpacity(0.6), // Marrón roble 60% opacidad
        ],
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
        // Sin stops para transición uniforme
      );

  /*
    GRADIENTES ESPECIALES TEMÁTICOS
  */

  /// Gradiente acuático para elementos de riego/agua
  static Gradient get waterTheme => const LinearGradient(
        colors: [
          deepSky, // Azul cielo profundo
          clearBlue, // Azul claro cristalino
          oceanMist, // Azul bruma oceánica
        ],
        begin: Alignment.topLeft, // Diagonal
        end: Alignment.bottomRight, // Diagonal opuesta
        stops: [0.0, 0.5, 1.0], // Tres colores
      );

  /// Gradiente soleado para elementos de luz
  static Gradient get sunTheme => const LinearGradient(
        colors: [
          goldenSun, // Amarillo sol dorado
          sunflower, // Amarillo girasol
          cloudWhite, // Blanco nube
        ],
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
        stops: [0.0, 0.7, 1.0], // Transiciones
      );

  /// Gradiente floral para elementos decorativos
  static Gradient get floralTheme => LinearGradient(
        colors: [
          berryPink.withOpacity(0.8), // Rosa frutilla 80% opacidad
          goldenSun.withOpacity(0.6), // Amarillo sol 60% opacidad
          freshMint.withOpacity(0.4), // Verde menta 40% opacidad
        ],
        begin: Alignment.topLeft, // Comienza en esquina superior izquierda
        end: Alignment.bottomRight, // Termina en esquina inferior derecha
        // Sin stops para transición gradual
      );

  /// Gradiente estacional para primavera
  static Gradient get springTheme => const LinearGradient(
        colors: [
          paleOlive, // Verde oliva pálido
          lightSage, // Verde salvia claro
          springGrass, // Verde hierba primavera
          freshMint, // Verde menta fresco
        ],
        begin: Alignment.topLeft, // Comienza en esquina superior izquierda
        end: Alignment.bottomRight, // Termina en esquina inferior derecha
        stops: [0.0, 0.3, 0.7, 1.0], // Cuatro colores con puntos específicos
      );

  /*
    EFECTOS DE SOMBRA CON COLORES TEMÁTICOS
  */

  /// Sombra suave para cards
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: forestDepth.withOpacity(0.15), // Color con 15% opacidad
          blurRadius: 8, // Radio de desenfoque en píxeles
          spreadRadius: 1, // Cuánto se expande la sombra
          offset: const Offset(0, 2), // Desplazamiento (x, y)
        ),
        BoxShadow(
          color: forestDepth.withOpacity(0.08), // Sombra más sutil
          blurRadius: 4, // Menor desenfoque
          spreadRadius: 0.5, // Menor expansión
          offset: const Offset(0, 1), // Menor desplazamiento vertical
        ),
      ];

  /// Sombra para botones
  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: emeraldLeaf.withOpacity(0.3), // Verde con 30% opacidad
          blurRadius: 6, // Desenfoque medio
          spreadRadius: 1, // Expansión estándar
          offset: const Offset(0, 2), // Desplazamiento hacia abajo
        ),
      ];

  /// Sombra para elementos elevados
  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: forestDepth.withOpacity(0.2), // Verde con 20% opacidad
          blurRadius: 12, // Gran desenfoque
          spreadRadius: 2, // Expansión considerable
          offset: const Offset(0, 4), // Mayor desplazamiento
        ),
      ];

  /// Sombra sutil para elementos internos
  static List<BoxShadow> get innerShadow => [
        BoxShadow(
          color: forestDepth.withOpacity(0.1), // Verde con 10% opacidad
          blurRadius: 4, // Desenfoque pequeño
          spreadRadius: -1, // Negativo para efecto interno
          offset: const Offset(0, 2), // Desplazamiento
        ),
      ];

  /// Sombra para elementos acuáticos
  static List<BoxShadow> get waterShadow => [
        BoxShadow(
          color: deepSky.withOpacity(0.2), // Azul con 20% opacidad
          blurRadius: 8, // Desenfoque medio
          spreadRadius: 1, // Expansión estándar
          offset: const Offset(0, 2), // Desplazamiento vertical
        ),
      ];

  /*
    EFECTOS ESPECIALES Y MÁSCARAS
  */

  /// Efecto de desvanecimiento para textos
  static ShaderMask createTextGradient(Text textWidget) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        // Función que crea el gradiente para el texto
        return const LinearGradient(
          colors: [forestDepth, emeraldLeaf, freshMint], // Tres verdes
          begin: Alignment.centerLeft, // De izquierda a derecha
          end: Alignment.centerRight, // Termina a la derecha
          stops: [0.0, 0.5, 1.0], // Puntos de transición
        ).createShader(bounds); // Crea el shader dentro de los límites
      },
      blendMode: BlendMode.srcIn, // Modo de mezcla que aplica al texto
      child: textWidget, // Widget de texto al que se aplica el efecto
    );
  }

  /// Efecto de brillo para iconos
  static ShaderMask createIconGradient(Icon iconWidget) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        // Función que crea gradiente radial para iconos
        return const RadialGradient(
          center: Alignment.center, // Centro del gradiente
          radius: 0.8, // Radio del gradiente (80% del tamaño)
          colors: [
            freshMint, // Verde menta en el centro
            springGrass, // Verde hierba en medio
            emeraldLeaf, // Verde esmeralda en los bordes
          ],
          stops: [0.0, 0.6, 1.0], // Puntos de transición
        ).createShader(bounds); // Crea shader dentro de los límites
      },
      blendMode: BlendMode.srcIn, // Modo de mezcla
      child: iconWidget, // Widget de icono
    );
  }

  /// Efecto de sol para iconos relacionados con luz
  static ShaderMask createSunIconGradient(Icon iconWidget) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        // Función que crea gradiente radial solar
        return const RadialGradient(
          center: Alignment.center, // Centro del gradiente
          radius: 0.8, // Radio 80%
          colors: [
            goldenSun, // Amarillo dorado en centro
            sunflower, // Amarillo girasol en medio
            Colors.white, // Blanco en bordes
          ],
          stops: [0.0, 0.7, 1.0], // Puntos de transición
        ).createShader(bounds); // Crea shader
      },
      blendMode: BlendMode.srcIn, // Modo de mezcla
      child: iconWidget, // Widget de icono
    );
  }

  /*
    MÉTODOS UTILITARIOS
  */

  /// Crea un gradiente personalizado con colores específicos
  static Gradient createCustomGradient(List<Color> colors,
      {Alignment begin = Alignment.centerLeft, // Dirección inicio por defecto
      Alignment end = Alignment.centerRight, // Dirección fin por defecto
      List<double>? stops}) {
    // Puntos de transición opcionales
    return LinearGradient(
      colors: colors, // Lista de colores proporcionada
      begin: begin, // Dirección inicial
      end: end, // Dirección final
      stops: stops, // Puntos de transición (puede ser null)
    );
  }

  /// Crea un gradiente radial personalizado
  static Gradient createRadialGradient(List<Color> colors,
      {Alignment center = Alignment.center, // Centro por defecto
      double radius = 0.8}) {
    // Radio por defecto 80%
    return RadialGradient(
      colors: colors, // Lista de colores
      center: center, // Centro del gradiente
      radius: radius, // Radio del gradiente
    );
  }

  /// Mezcla dos colores con opacidad
  static Color blendColors(Color color1, Color color2, double ratio) {
    return Color.alphaBlend(
      color2.withOpacity(ratio), // Segundo color con opacidad específica
      color1, // Primer color base
    );
  }

  /*
    GRADIENTES PRE DEFINIDOS PARA ESTADOS DE CRECIMIENTO
  */

  /// Gradiente para etapa 1 de crecimiento - Inicial
  static Gradient get growthStage1 => const LinearGradient(
        colors: [paleOlive, lightSage], // Colores suaves iniciales
        begin: Alignment.topCenter, // Dirección vertical
        end: Alignment.bottomCenter, // Termina abajo
      );

  /// Gradiente para etapa 2 de crecimiento - Desarrollo
  static Gradient get growthStage2 => const LinearGradient(
        colors: [lightSage, springGrass], // Colores más vibrantes
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
      );

  /// Gradiente para etapa 3 de crecimiento - Maduración
  static Gradient get growthStage3 => const LinearGradient(
        colors: [springGrass, freshMint], // Colores verdes fuertes
        begin: Alignment.topCenter, // Dirección vertical
        end: Alignment.bottomCenter, // Termina abajo
      );

  /// Gradiente para etapa 4 de crecimiento - Completo
  static Gradient get growthStage4 => const LinearGradient(
        colors: [freshMint, emeraldLeaf], // Colores profundos
        begin: Alignment.topCenter, // Comienza arriba
        end: Alignment.bottomCenter, // Termina abajo
      );
}
