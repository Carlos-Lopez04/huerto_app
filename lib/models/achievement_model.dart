// models/achievement_model.dart
import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final String icon;
  final String color;
  final int requiredPoints;
  final int currentProgress;
  final int totalRequired;
  final bool isSecret;
  final AchievementLevel level;
  final List<String> requirements;
  final String? unlockedDescription;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.requiredPoints,
    this.currentProgress = 0,
    this.totalRequired = 1,
    this.isSecret = false,
    this.level = AchievementLevel.bronze,
    this.requirements = const [],
    this.unlockedDescription,
  });

  // Getters útiles
  double get progressPercentage => totalRequired > 0
      ? (currentProgress / totalRequired).clamp(0.0, 1.0)
      : 0.0;

  bool get isCompleted => currentProgress >= totalRequired;
  bool get isInProgress => currentProgress > 0 && !isCompleted;

  Color get colorValue => _getColor(color);

  // Método para actualizar progreso
  Achievement updateProgress(int newProgress) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      category: category,
      icon: icon,
      color: color,
      requiredPoints: requiredPoints,
      currentProgress: newProgress.clamp(0, totalRequired),
      totalRequired: totalRequired,
      isSecret: isSecret,
      level: level,
      requirements: requirements,
      unlockedDescription: unlockedDescription,
    );
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id']?.toString() ?? '0',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: _parseCategory(json['category'] ?? ''),
      icon: json['icon'] ?? '🏆',
      color: json['color'] ?? 'freshMint',
      requiredPoints: json['points'] ?? 0,
      currentProgress: json['currentProgress'] ?? 0,
      totalRequired: json['totalRequired'] ?? 1,
      isSecret: json['isSecret'] ?? false,
      level: _parseLevel(json['level'] ?? 'bronze'),
      requirements: List<String>.from(json['requirements'] ?? []),
      unlockedDescription: json['unlockedDescription'],
    );
  }

  static AchievementCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cultivo':
        return AchievementCategory.cultivo;
      case 'hábitos':
      case 'habitos':
        return AchievementCategory.habitos;
      case 'dedicación':
      case 'dedicacion':
        return AchievementCategory.dedicacion;
      case 'habilidad':
        return AchievementCategory.habilidad;
      case 'social':
        return AchievementCategory.social;
      case 'colección':
      case 'coleccion':
        return AchievementCategory.coleccion;
      default:
        return AchievementCategory.cultivo;
    }
  }

  static AchievementLevel _parseLevel(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return AchievementLevel.bronze;
      case 'silver':
        return AchievementLevel.silver;
      case 'gold':
        return AchievementLevel.gold;
      case 'platinum':
        return AchievementLevel.platinum;
      case 'diamond':
        return AchievementLevel.diamond;
      default:
        return AchievementLevel.bronze;
    }
  }

  static Color _getColor(String colorName) {
    switch (colorName) {
      case 'freshMint':
        return freshMint;
      case 'clearBlue':
        return clearBlue;
      case 'sunflower':
        return sunflower;
      case 'goldenSun':
        return goldenSun;
      case 'berryPink':
        return berryPink;
      case 'emeraldLeaf':
        return emeraldLeaf;
      case 'forestDepth':
        return forestDepth;
      default:
        return freshMint;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'icon': icon,
      'color': color,
      'points': requiredPoints,
      'currentProgress': currentProgress,
      'totalRequired': totalRequired,
      'isSecret': isSecret,
      'level': level.name,
      'requirements': requirements,
      'unlockedDescription': unlockedDescription,
    };
  }
}

// Enumeraciones mejoradas
enum AchievementCategory {
  cultivo,
  habitos,
  dedicacion,
  habilidad,
  social,
  coleccion,
}

enum AchievementLevel {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

// Modelo de categoría de logros
class AchievementCategoryModel {
  final String name;
  final String emoji;
  final String color;
  final int totalAchievements;
  final int unlockedAchievements;
  final double progressPercentage;
  final List<Achievement> achievements;

  AchievementCategoryModel({
    required this.name,
    required this.emoji,
    required this.color,
    required this.totalAchievements,
    required this.unlockedAchievements,
    required this.progressPercentage,
    required this.achievements,
  });

  factory AchievementCategoryModel.fromJson(Map<String, dynamic> json) {
    final achievementsJson = json['achievements'] as List? ?? [];
    return AchievementCategoryModel(
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '',
      color: json['color'] ?? '',
      totalAchievements: json['totalAchievements'] ?? 0,
      unlockedAchievements: json['unlockedAchievements'] ?? 0,
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
      achievements: achievementsJson
          .map((achievementJson) => Achievement.fromJson(achievementJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'color': color,
      'totalAchievements': totalAchievements,
      'unlockedAchievements': unlockedAchievements,
      'progressPercentage': progressPercentage,
      'achievements': achievements.map((a) => a.toJson()).toList(),
    };
  }

  // Método para obtener el nombre en español
  String get displayName {
    switch (name.toLowerCase()) {
      case 'cultivo':
        return 'Cultivo';
      case 'hábitos':
      case 'habitos':
        return 'Hábitos';
      case 'dedicación':
      case 'dedicacion':
        return 'Dedicación';
      case 'habilidad':
        return 'Habilidad';
      case 'social':
        return 'Social';
      case 'colección':
      case 'coleccion':
        return 'Colección';
      default:
        return name;
    }
  }
}

// Clase de utilidad para el sistema de logros
class AchievementUtils {
  static String getCategoryName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.cultivo:
        return 'Cultivo';
      case AchievementCategory.habitos:
        return 'Hábitos';
      case AchievementCategory.dedicacion:
        return 'Dedicación';
      case AchievementCategory.habilidad:
        return 'Habilidad';
      case AchievementCategory.social:
        return 'Social';
      case AchievementCategory.coleccion:
        return 'Colección';
    }
  }

  static String getLevelName(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return 'Bronce';
      case AchievementLevel.silver:
        return 'Plata';
      case AchievementLevel.gold:
        return 'Oro';
      case AchievementLevel.platinum:
        return 'Platino';
      case AchievementLevel.diamond:
        return 'Diamante';
    }
  }

  static Color getLevelColor(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return const Color(0xFFCD7F32);
      case AchievementLevel.silver:
        return const Color(0xFFC0C0C0);
      case AchievementLevel.gold:
        return const Color(0xFFFFD700);
      case AchievementLevel.platinum:
        return const Color(0xFFE5E4E2);
      case AchievementLevel.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  static IconData getLevelIcon(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return Icons.ac_unit;
      case AchievementLevel.silver:
        return Icons.brightness_medium;
      case AchievementLevel.gold:
        return Icons.star;
      case AchievementLevel.platinum:
        return Icons.diamond;
      case AchievementLevel.diamond:
        return Icons.workspace_premium;
    }
  }

  static Color getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.cultivo:
        return freshMint;
      case AchievementCategory.habitos:
        return clearBlue;
      case AchievementCategory.dedicacion:
        return sunflower;
      case AchievementCategory.habilidad:
        return goldenSun;
      case AchievementCategory.social:
        return berryPink;
      case AchievementCategory.coleccion:
        return emeraldLeaf;
    }
  }

  static String getCategoryEmoji(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.cultivo:
        return '🌱';
      case AchievementCategory.habitos:
        return '⚡';
      case AchievementCategory.dedicacion:
        return '🔥';
      case AchievementCategory.habilidad:
        return '⭐';
      case AchievementCategory.social:
        return '👥';
      case AchievementCategory.coleccion:
        return '🏆';
    }
  }

  // Método para obtener todos los logros de ejemplo
  static List<Achievement> getSampleAchievements() {
    return [
      Achievement(
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
      Achievement(
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
      Achievement(
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
      Achievement(
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
      Achievement(
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
      Achievement(
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
      Achievement(
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

  // Método para obtener categorías de ejemplo
  static List<AchievementCategoryModel> getSampleCategories() {
    final achievements = getSampleAchievements();

    final Map<AchievementCategory, List<Achievement>> categorized = {};
    for (final achievement in achievements) {
      categorized.putIfAbsent(achievement.category, () => []).add(achievement);
    }

    return categorized.entries.map((entry) {
      final category = entry.key;
      final categoryAchievements = entry.value;
      final unlockedCount =
          categoryAchievements.where((a) => a.isCompleted).length;

      return AchievementCategoryModel(
        name: getCategoryName(category),
        emoji: getCategoryEmoji(category),
        color: _getColorName(getCategoryColor(category)),
        totalAchievements: categoryAchievements.length,
        unlockedAchievements: unlockedCount,
        progressPercentage: categoryAchievements.isNotEmpty
            ? (unlockedCount / categoryAchievements.length) * 100
            : 0,
        achievements: categoryAchievements,
      );
    }).toList();
  }

  static String _getColorName(Color color) {
    if (color.value == freshMint.value) return 'freshMint';
    if (color.value == clearBlue.value) return 'clearBlue';
    if (color.value == sunflower.value) return 'sunflower';
    if (color.value == goldenSun.value) return 'goldenSun';
    if (color.value == berryPink.value) return 'berryPink';
    if (color.value == emeraldLeaf.value) return 'emeraldLeaf';
    if (color.value == forestDepth.value) return 'forestDepth';
    return 'freshMint';
  }
}
