import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppGradients {
  // =============================================
  // GRADIENTES PARA CARDS Y CONTENEDORES
  // =============================================

  /// Gradiente suave para cards principales
  static Gradient get cardPrimary => LinearGradient(
        colors: [
          cloudWhite,
          lightSage.withOpacity(0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.8],
      );

  /// Gradiente vibrante para cards destacadas
  static Gradient get cardHighlight => LinearGradient(
        colors: [
          emeraldLeaf.withOpacity(0.9),
          freshMint.withOpacity(0.8),
          springGrass.withOpacity(0.7),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.0, 0.6, 1.0],
      );

  /// Gradiente sutil para fondos de sección
  static Gradient get backgroundSoft => LinearGradient(
        colors: [
          paleOlive.withOpacity(0.1),
          paperCream.withOpacity(0.8),
          lightSage.withOpacity(0.2),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.5, 1.0],
      );

  /// Gradiente para elementos hover/activos
  static Gradient get interactiveHover => const LinearGradient(
        colors: [
          lightSage,
          paleOlive,
          cloudWhite,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.5, 1.0],
      );

  /// Gradiente natural para cards de plantas
  static Gradient get plantCard => const LinearGradient(
        colors: [
          springGrass,
          freshMint,
          lightSage,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
      );

  /// Gradiente terroso para elementos de tierra
  static Gradient get earthyCard => LinearGradient(
        colors: [
          sandyBeach,
          oakWood.withOpacity(0.7),
          warmClay.withOpacity(0.5),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.6, 1.0],
      );

  // =============================================
  // GRADIENTES PARA BOTONES
  // =============================================

  /// Gradiente principal para botones
  static Gradient get buttonPrimary => const LinearGradient(
        colors: [
          forestDepth,
          emeraldLeaf,
          freshMint,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.6, 1.0],
      );

  /// Gradiente para botones en estado hover/presionado
  static Gradient get buttonPressed => const LinearGradient(
        colors: [
          emeraldLeaf,
          forestDepth,
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        stops: [0.0, 0.8],
      );

  /// Gradiente para botones secundarios
  static Gradient get buttonSecondary => LinearGradient(
        colors: [
          springGrass.withOpacity(0.9),
          lightSage.withOpacity(0.8),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.9],
      );

  /// Gradiente para botones de acción positiva
  static Gradient get buttonSuccess => const LinearGradient(
        colors: [
          freshMint,
          springGrass,
          emeraldLeaf,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
      );

  /// Gradiente para botones de advertencia
  static Gradient get buttonWarning => const LinearGradient(
        colors: [
          goldenSun,
          sunflower,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  /// Gradiente para botones de peligro
  static Gradient get buttonDanger => LinearGradient(
        colors: [
          tomatoRed,
          berryPink.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // =============================================
  // GRADIENTES PARA APP BAR Y HEADERS
  // =============================================

  /// Gradiente para AppBar principal
  static Gradient get appBarPrimary => const LinearGradient(
        colors: [
          freshMint,
          emeraldLeaf,
          forestDepth,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [0.0, 0.5, 1.0],
      );

  /// Gradiente para encabezados de sección
  static Gradient get sectionHeader => LinearGradient(
        colors: [
          forestDepth.withOpacity(0.2),
          emeraldLeaf.withOpacity(0.3),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.5, 1.0],
      );

  /// Gradiente para footer
  static Gradient get footerGradient => LinearGradient(
        colors: [
          richSoil.withOpacity(0.8),
          oakWood.withOpacity(0.6),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  // =============================================
  // GRADIENTES ESPECIALES TEMÁTICOS
  // =============================================

  /// Gradiente acuático para elementos de riego/agua
  static Gradient get waterTheme => const LinearGradient(
        colors: [
          deepSky,
          clearBlue,
          oceanMist,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
      );

  /// Gradiente soleado para elementos de luz
  static Gradient get sunTheme => const LinearGradient(
        colors: [
          goldenSun,
          sunflower,
          cloudWhite,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.7, 1.0],
      );

  /// Gradiente floral para elementos decorativos
  static Gradient get floralTheme => LinearGradient(
        colors: [
          berryPink.withOpacity(0.8),
          goldenSun.withOpacity(0.6),
          freshMint.withOpacity(0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Gradiente estacional para primavera
  static Gradient get springTheme => const LinearGradient(
        colors: [
          paleOlive,
          lightSage,
          springGrass,
          freshMint,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.3, 0.7, 1.0],
      );

  // =============================================
  // EFECTOS DE SOMBRA CON COLORES TEMÁTICOS
  // =============================================

  /// Sombra suave para cards
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: forestDepth.withOpacity(0.15),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: forestDepth.withOpacity(0.08),
          blurRadius: 4,
          spreadRadius: 0.5,
          offset: const Offset(0, 1),
        ),
      ];

  /// Sombra para botones
  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: emeraldLeaf.withOpacity(0.3),
          blurRadius: 6,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ];

  /// Sombra para elementos elevados
  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: forestDepth.withOpacity(0.2),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];

  /// Sombra sutil para elementos internos
  static List<BoxShadow> get innerShadow => [
        BoxShadow(
          color: forestDepth.withOpacity(0.1),
          blurRadius: 4,
          spreadRadius: -1,
          offset: const Offset(0, 2),
        ),
      ];

  /// Sombra para elementos acuáticos
  static List<BoxShadow> get waterShadow => [
        BoxShadow(
          color: deepSky.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ];

  // =============================================
  // EFECTOS ESPECIALES Y MÁSCARAS
  // =============================================

  /// Efecto de desvanecimiento para textos
  static ShaderMask createTextGradient(Text textWidget) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [forestDepth, emeraldLeaf, freshMint],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.5, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: textWidget,
    );
  }

  /// Efecto de brillo para iconos
  static ShaderMask createIconGradient(Icon iconWidget) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            freshMint,
            springGrass,
            emeraldLeaf,
          ],
          stops: [0.0, 0.6, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: iconWidget,
    );
  }

  /// Efecto de sol para iconos relacionados con luz
  static ShaderMask createSunIconGradient(Icon iconWidget) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            goldenSun,
            sunflower,
            Colors.white,
          ],
          stops: [0.0, 0.7, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: iconWidget,
    );
  }

  // =============================================
  // MÉTODOS UTILITARIOS
  // =============================================

  /// Crea un gradiente personalizado con colores específicos
  static Gradient createCustomGradient(List<Color> colors,
      {Alignment begin = Alignment.centerLeft,
      Alignment end = Alignment.centerRight,
      List<double>? stops}) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    );
  }

  /// Crea un gradiente radial personalizado
  static Gradient createRadialGradient(List<Color> colors,
      {Alignment center = Alignment.center, double radius = 0.8}) {
    return RadialGradient(
      colors: colors,
      center: center,
      radius: radius,
    );
  }

  /// Mezcla dos colores con opacidad
  static Color blendColors(Color color1, Color color2, double ratio) {
    return Color.alphaBlend(
      color2.withOpacity(ratio),
      color1,
    );
  }

  /// Gradiente predefinido para estados de crecimiento
  static Gradient get growthStage1 => const LinearGradient(
        colors: [paleOlive, lightSage],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static Gradient get growthStage2 => const LinearGradient(
        colors: [lightSage, springGrass],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static Gradient get growthStage3 => const LinearGradient(
        colors: [springGrass, freshMint],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static Gradient get growthStage4 => const LinearGradient(
        colors: [freshMint, emeraldLeaf],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}
