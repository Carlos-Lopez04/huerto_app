// models/achievement_model.dart
import 'package:flutter/material.dart'; // Importar framework Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Importar tema de la aplicación

// Clase principal que representa un logro/conquista
class Achievement {
  final String id; // Identificador único del logro
  final String title; // Título del logro
  final String description; // Descripción del logro
  final AchievementCategory category; // Categoría del logro
  final String icon; // Icono del logro (emoji o ruta)
  final String color; // Nombre del color del logro
  final int requiredPoints; // Puntos requeridos para desbloquear
  final int currentProgress; // Progreso actual hacia la meta
  final int totalRequired; // Total requerido para completar
  final bool isSecret; // Si el logro es secreto (no visible hasta desbloquear)
  final AchievementLevel level; // Nivel del logro (bronce, plata, etc.)
  final List<String> requirements; // Lista de requisitos para completar
  final String?
      unlockedDescription; // Descripción adicional al desbloquear (opcional)

  // Constructor de la clase Achievement
  const Achievement({
    required this.id, // Requerido: ID único
    required this.title, // Requerido: título
    required this.description, // Requerido: descripción
    required this.category, // Requerido: categoría
    required this.icon, // Requerido: icono
    required this.color, // Requerido: color
    required this.requiredPoints, // Requerido: puntos necesarios
    this.currentProgress = 0, // Opcional: progreso actual (0 por defecto)
    this.totalRequired = 1, // Opcional: total requerido (1 por defecto)
    this.isSecret = false, // Opcional: si es secreto (false por defecto)
    this.level =
        AchievementLevel.bronze, // Opcional: nivel (bronce por defecto)
    this.requirements =
        const [], // Opcional: requisitos (lista vacía por defecto)
    this.unlockedDescription, // Opcional: descripción al desbloquear
  });

  /*
    Calcula el porcentaje de progreso del logro
  */
  double get progressPercentage => totalRequired > 0
      ? (currentProgress / totalRequired).clamp(
          0.0, 1.0) // Divide progreso actual entre total y limita entre 0 y 1
      : 0.0; // Si totalRequired es 0, retorna 0

  /*
    Verifica si el logro está completamente completado
  */
  bool get isCompleted =>
      currentProgress >= totalRequired; // True si progreso >= total requerido

  /*
    Verifica si el logro está en progreso (empezado pero no terminado)
  */
  bool get isInProgress =>
      currentProgress > 0 &&
      !isCompleted; // True si hay progreso pero no está completado

  /*
    Obtiene el valor Color a partir del nombre del color
  */
  Color get colorValue =>
      _getColor(color); // Llama a función privada para convertir nombre a Color

  /*
    Método para actualizar el progreso del logro
  */
  Achievement updateProgress(int newProgress) {
    return Achievement(
      // Crea una nueva instancia con el progreso actualizado
      id: id,
      title: title,
      description: description,
      category: category,
      icon: icon,
      color: color,
      requiredPoints: requiredPoints,
      currentProgress: newProgress.clamp(
          0, totalRequired), // Limita el nuevo progreso entre 0 y totalRequired
      totalRequired: totalRequired,
      isSecret: isSecret,
      level: level,
      requirements: requirements,
      unlockedDescription: unlockedDescription,
    );
  }

  /*
    Constructor factory para crear Achievement desde JSON
  */
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id']?.toString() ??
          '0', // Convierte a string o usa '0' por defecto
      title: json['title'] ?? '', // Título o string vacío
      description: json['description'] ?? '', // Descripción o string vacío
      category: _parseCategory(json['category'] ?? ''), // Parsea la categoría
      icon: json['icon'] ?? '🏆', // Icono o emoji de trofeo por defecto
      color: json['color'] ?? 'freshMint', // Color o 'freshMint' por defecto
      requiredPoints: json['points'] ?? 0, // Puntos o 0 por defecto
      currentProgress: json['currentProgress'] ?? 0, // Progreso actual o 0
      totalRequired: json['totalRequired'] ?? 1, // Total requerido o 1
      isSecret: json['isSecret'] ?? false, // Es secreto o false
      level: _parseLevel(json['level'] ?? 'bronze'), // Parsea el nivel
      requirements:
          List<String>.from(json['requirements'] ?? []), // Lista de requisitos
      unlockedDescription: json[
          'unlockedDescription'], // Descripción al desbloquear (puede ser null)
    );
  }

  /*
    Convierte string de categoría a enum AchievementCategory
  */
  static AchievementCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      // Convierte a minúsculas para comparación
      case 'cultivo':
        return AchievementCategory.cultivo; // Categoría cultivo
      case 'hábitos':
      case 'habitos':
        return AchievementCategory.habitos; // Categoría hábitos
      case 'dedicación':
      case 'dedicacion':
        return AchievementCategory.dedicacion; // Categoría dedicación
      case 'habilidad':
        return AchievementCategory.habilidad; // Categoría habilidad
      case 'social':
        return AchievementCategory.social; // Categoría social
      case 'colección':
      case 'coleccion':
        return AchievementCategory.coleccion; // Categoría colección
      default:
        return AchievementCategory.cultivo; // Por defecto: cultivo
    }
  }

  /*
    Convierte string de nivel a enum AchievementLevel
  */
  static AchievementLevel _parseLevel(String level) {
    switch (level.toLowerCase()) {
      // Convierte a minúsculas
      case 'bronze':
        return AchievementLevel.bronze; // Nivel bronce
      case 'silver':
        return AchievementLevel.silver; // Nivel plata
      case 'gold':
        return AchievementLevel.gold; // Nivel oro
      case 'platinum':
        return AchievementLevel.platinum; // Nivel platino
      case 'diamond':
        return AchievementLevel.diamond; // Nivel diamante
      default:
        return AchievementLevel.bronze; // Por defecto: bronce
    }
  }

  /*
    Convierte nombre de color a objeto Color
  */
  static Color _getColor(String colorName) {
    switch (colorName) {
      case 'freshMint':
        return freshMint; // Color menta fresca del tema
      case 'clearBlue':
        return clearBlue; // Color azul claro del tema
      case 'sunflower':
        return sunflower; // Color girasol del tema
      case 'goldenSun':
        return goldenSun; // Color sol dorado del tema
      case 'berryPink':
        return berryPink; // Color rosa baya del tema
      case 'emeraldLeaf':
        return emeraldLeaf; // Color hoja esmeralda del tema
      case 'forestDepth':
        return forestDepth; // Color profundidad bosque del tema
      default:
        return freshMint; // Por defecto: menta fresca
    }
  }

  /*
    Convierte Achievement a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name, // Usa el nombre del enum
      'icon': icon,
      'color': color,
      'points': requiredPoints,
      'currentProgress': currentProgress,
      'totalRequired': totalRequired,
      'isSecret': isSecret,
      'level': level.name, // Usa el nombre del enum
      'requirements': requirements,
      'unlockedDescription': unlockedDescription,
    };
  }
}

/*
    Enumeración para categorías de logros
*/
enum AchievementCategory {
  cultivo, // Logros de cultivo
  habitos, // Logros de hábitos
  dedicacion, // Logros de dedicación
  habilidad, // Logros de habilidad
  social, // Logros sociales
  coleccion, // Logros de colección
}

/*
    Enumeración para niveles de logros
*/
enum AchievementLevel {
  bronze, // Nivel bronce
  silver, // Nivel plata
  gold, // Nivel oro
  platinum, // Nivel platino
  diamond, // Nivel diamante
}

/*
    Modelo para agrupar logros por categoría
*/
class AchievementCategoryModel {
  final String name; // Nombre de la categoría
  final String emoji; // Emoji representativo
  final String color; // Color de la categoría
  final int totalAchievements; // Total de logros en la categoría
  final int unlockedAchievements; // Logros desbloqueados en la categoría
  final double progressPercentage; // Porcentaje de progreso de la categoría
  final List<Achievement> achievements; // Lista de logros en la categoría

  // Constructor de AchievementCategoryModel
  AchievementCategoryModel({
    required this.name, // Requerido: nombre
    required this.emoji, // Requerido: emoji
    required this.color, // Requerido: color
    required this.totalAchievements, // Requerido: total de logros
    required this.unlockedAchievements, // Requerido: logros desbloqueados
    required this.progressPercentage, // Requerido: porcentaje de progreso
    required this.achievements, // Requerido: lista de logros
  });

  /*
    Constructor factory para crear desde JSON
  */
  factory AchievementCategoryModel.fromJson(Map<String, dynamic> json) {
    final achievementsJson = json['achievements'] as List? ??
        []; // Obtiene lista de logros o lista vacía
    return AchievementCategoryModel(
      name: json['name'] ?? '', // Nombre o string vacío
      emoji: json['emoji'] ?? '', // Emoji o string vacío
      color: json['color'] ?? '', // Color o string vacío
      totalAchievements: json['totalAchievements'] ?? 0, // Total o 0
      unlockedAchievements:
          json['unlockedAchievements'] ?? 0, // Desbloqueados o 0
      progressPercentage:
          (json['progressPercentage'] ?? 0.0).toDouble(), // Porcentaje o 0.0
      achievements: achievementsJson
          .map((achievementJson) => Achievement.fromJson(
              achievementJson)) // Convierte cada JSON a Achievement
          .toList(), // Convierte a lista
    );
  }

  /*
    Convierte a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'color': color,
      'totalAchievements': totalAchievements,
      'unlockedAchievements': unlockedAchievements,
      'progressPercentage': progressPercentage,
      'achievements': achievements
          .map((a) => a.toJson())
          .toList(), // Convierte cada Achievement a JSON
    };
  }

  /*
    Obtiene el nombre en español para mostrar
  */
  String get displayName {
    switch (name.toLowerCase()) {
      // Convierte a minúsculas para comparación
      case 'cultivo':
        return 'Cultivo'; // Nombre en español
      case 'hábitos':
      case 'habitos':
        return 'Hábitos'; // Nombre en español
      case 'dedicación':
      case 'dedicacion':
        return 'Dedicación'; // Nombre en español
      case 'habilidad':
        return 'Habilidad'; // Nombre en español
      case 'social':
        return 'Social'; // Nombre en español
      case 'colección':
      case 'coleccion':
        return 'Colección'; // Nombre en español
      default:
        return name; // Retorna el nombre original
    }
  }
}

/*
    Clase de utilidad para operaciones comunes con logros
*/
class AchievementUtils {
  /*
    Obtiene el nombre de la categoría en español
  */
  static String getCategoryName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.cultivo:
        return 'Cultivo'; // Nombre en español
      case AchievementCategory.habitos:
        return 'Hábitos'; // Nombre en español
      case AchievementCategory.dedicacion:
        return 'Dedicación'; // Nombre en español
      case AchievementCategory.habilidad:
        return 'Habilidad'; // Nombre en español
      case AchievementCategory.social:
        return 'Social'; // Nombre en español
      case AchievementCategory.coleccion:
        return 'Colección'; // Nombre en español
    }
  }

  /*
    Obtiene el nombre del nivel en español
  */
  static String getLevelName(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return 'Bronce'; // Nombre en español
      case AchievementLevel.silver:
        return 'Plata'; // Nombre en español
      case AchievementLevel.gold:
        return 'Oro'; // Nombre en español
      case AchievementLevel.platinum:
        return 'Platino'; // Nombre en español
      case AchievementLevel.diamond:
        return 'Diamante'; // Nombre en español
    }
  }

  /*
    Obtiene el color asociado a cada nivel
  */
  static Color getLevelColor(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return const Color(0xFFCD7F32); // Color bronce
      case AchievementLevel.silver:
        return const Color(0xFFC0C0C0); // Color plata
      case AchievementLevel.gold:
        return const Color(0xFFFFD700); // Color oro
      case AchievementLevel.platinum:
        return const Color(0xFFE5E4E2); // Color platino
      case AchievementLevel.diamond:
        return const Color(0xFFB9F2FF); // Color diamante
    }
  }

  /*
    Obtiene el icono asociado a cada nivel
  */
  static IconData getLevelIcon(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return Icons.ac_unit; // Icono para bronce
      case AchievementLevel.silver:
        return Icons.brightness_medium; // Icono para plata
      case AchievementLevel.gold:
        return Icons.star; // Icono para oro
      case AchievementLevel.platinum:
        return Icons.diamond; // Icono para platino
      case AchievementLevel.diamond:
        return Icons.workspace_premium; // Icono para diamante
    }
  }

  /*
    Obtiene el color asociado a cada categoría
  */
  static Color getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.cultivo:
        return freshMint; // Color del tema
      case AchievementCategory.habitos:
        return clearBlue; // Color del tema
      case AchievementCategory.dedicacion:
        return sunflower; // Color del tema
      case AchievementCategory.habilidad:
        return goldenSun; // Color del tema
      case AchievementCategory.social:
        return berryPink; // Color del tema
      case AchievementCategory.coleccion:
        return emeraldLeaf; // Color del tema
    }
  }

  /*
    Obtiene el emoji asociado a cada categoría
  */
  static String getCategoryEmoji(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.cultivo:
        return '🌱'; // Emoji de brote
      case AchievementCategory.habitos:
        return '⚡'; // Emoji de rayo
      case AchievementCategory.dedicacion:
        return '🔥'; // Emoji de fuego
      case AchievementCategory.habilidad:
        return '⭐'; // Emoji de estrella
      case AchievementCategory.social:
        return '👥'; // Emoji de personas
      case AchievementCategory.coleccion:
        return '🏆'; // Emoji de trofeo
    }
  }

  /*
    Genera una lista de logros de ejemplo para pruebas
  */
  static List<Achievement> getSampleAchievements() {
    return [
      const Achievement(
        // Logro de primera semilla
        id: 'first_seed',
        title: 'Primera Semilla',
        description: 'Planta tu primera semilla',
        category: AchievementCategory.cultivo,
        icon: '🌱',
        color: 'freshMint',
        requiredPoints: 25,
        currentProgress: 1,
        totalRequired: 1,
        level: AchievementLevel.bronze,
        requirements: ['activity:plant_seed'],
      ),
      const Achievement(
        // Logro de riego
        id: 'water_master_beginner',
        title: 'Aprendiz del Riego',
        description: 'Riega plantas 10 veces',
        category: AchievementCategory.cultivo,
        icon: '💧',
        color: 'clearBlue',
        requiredPoints: 50,
        currentProgress: 8,
        totalRequired: 10,
        level: AchievementLevel.bronze,
        requirements: ['activity_count:water_plant|10'],
      ),
      const Achievement(
        // Logro de racha
        id: 'daily_streak_3',
        title: 'Racha de 3 Días',
        description: '3 días consecutivos usando la app',
        category: AchievementCategory.dedicacion,
        icon: '🔥',
        color: 'sunflower',
        requiredPoints: 30,
        currentProgress: 3,
        totalRequired: 3,
        level: AchievementLevel.bronze,
        requirements: ['consecutive_days:3'],
      ),
      const Achievement(
        // Logro de nivel
        id: 'level_2',
        title: 'Crecimiento Inicial',
        description: 'Alcanza el nivel 2',
        category: AchievementCategory.habilidad,
        icon: '⭐',
        color: 'goldenSun',
        requiredPoints: 100,
        currentProgress: 1,
        totalRequired: 1,
        level: AchievementLevel.bronze,
        requirements: ['level:2'],
      ),
      const Achievement(
        // Logro social
        id: 'social_beginner',
        title: 'Primer Compartir',
        description: 'Comparte tu huerto por primera vez',
        category: AchievementCategory.social,
        icon: '📤',
        color: 'berryPink',
        requiredPoints: 15,
        currentProgress: 1,
        totalRequired: 1,
        level: AchievementLevel.bronze,
        requirements: ['activity:share_garden'],
      ),
      const Achievement(
        // Logro de cosecha
        id: 'first_harvest',
        title: 'Primera Cosecha',
        description: 'Cosecha tu primera planta',
        category: AchievementCategory.coleccion,
        icon: '🌾',
        color: 'emeraldLeaf',
        requiredPoints: 50,
        currentProgress: 0,
        totalRequired: 1,
        level: AchievementLevel.silver,
        requirements: ['activity:harvest_plant'],
        unlockedDescription: '¡Felicidades por tu primera cosecha!',
      ),
      const Achievement(
        // Logro de coleccionista
        id: 'plant_collector',
        title: 'Coleccionista Novato',
        description: 'Cultiva 3 tipos diferentes de plantas',
        category: AchievementCategory.coleccion,
        icon: '🌿',
        color: 'forestDepth',
        requiredPoints: 100,
        currentProgress: 2,
        totalRequired: 3,
        level: AchievementLevel.silver,
        requirements: ['achievement_count:3'],
      ),
    ];
  }

  /*
    Genera categorías de ejemplo con sus logros
  */
  static List<AchievementCategoryModel> getSampleCategories() {
    final achievements = getSampleAchievements(); // Obtiene logros de ejemplo

    final Map<AchievementCategory, List<Achievement>> categorized =
        {}; // Mapa para categorizar
    for (final achievement in achievements) {
      categorized
          .putIfAbsent(achievement.category, () => [])
          .add(achievement); // Agrupa por categoría
    }

    return categorized.entries.map((entry) {
      final category = entry.key; // Categoría
      final categoryAchievements = entry.value; // Logros de la categoría
      final unlockedCount = categoryAchievements
          .where((a) => a.isCompleted)
          .length; // Cuenta logros completados

      return AchievementCategoryModel(
        name: getCategoryName(category), // Nombre de la categoría
        emoji: getCategoryEmoji(category), // Emoji de la categoría
        color: _getColorName(getCategoryColor(category)), // Nombre del color
        totalAchievements: categoryAchievements.length, // Total de logros
        unlockedAchievements: unlockedCount, // Logros desbloqueados
        progressPercentage: categoryAchievements.isNotEmpty
            ? (unlockedCount / categoryAchievements.length) *
                100 // Calcula porcentaje
            : 0, // Si no hay logros, 0%
        achievements: categoryAchievements, // Lista de logros
      );
    }).toList(); // Convierte a lista
  }

  /*
    Obtiene el nombre del color a partir del objeto Color
  */
  static String _getColorName(Color color) {
    if (color == freshMint) return 'freshMint'; // Compara valores hex
    if (color == clearBlue) return 'clearBlue'; // Compara valores hex
    if (color == sunflower) return 'sunflower'; // Compara valores hex
    if (color == goldenSun) return 'goldenSun'; // Compara valores hex
    if (color == berryPink) return 'berryPink'; // Compara valores hex
    if (color == emeraldLeaf) return 'emeraldLeaf'; // Compara valores hex
    if (color == forestDepth) return 'forestDepth'; // Compara valores hex
    return 'freshMint'; // Por defecto
  }
}
