// models/activity_model.dart
import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';

// Enumeración para categorías de actividades
enum ActivityCategory {
  cultivo,
  habitos,
  social,
  habilidad,
  misiones,
  riego,
  cosecha,
  mantenimiento,
}

// Enumeración para frecuencia de actividades
enum ActivityFrequency {
  diaria,
  semanal,
  mensual,
  unica,
  personalizada,
}

// Enumeración para dificultad de actividades
enum ActivityDifficulty {
  facil,
  medio,
  dificil,
  experto,
}

// Modelo principal de actividad
class Activity {
  final String id;
  final String name;
  final String description;
  final int points; // Puntos que otorga al completarse
  final ActivityCategory category;
  final String icon;
  final Color color;
  final int maxDaily; // Máximo de veces por día
  final ActivityFrequency frequency;
  final ActivityDifficulty difficulty;
  final Duration? estimatedDuration; // Duración estimada
  final List<String> tags;
  final String? tutorialUrl;
  final Map<String, dynamic>? metadata; // Datos adicionales
  final bool isActive;
  final DateTime? availableFrom;
  final DateTime? availableUntil;

  const Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.category,
    required this.icon,
    required this.color,
    this.maxDaily = 1,
    this.frequency = ActivityFrequency.diaria,
    this.difficulty = ActivityDifficulty.facil,
    this.estimatedDuration,
    this.tags = const [],
    this.tutorialUrl,
    this.metadata,
    this.isActive = true,
    this.availableFrom,
    this.availableUntil,
  });

  // Getters útiles
  bool get isAvailable {
    final now = DateTime.now();
    if (availableFrom != null && now.isBefore(availableFrom!)) return false;
    if (availableUntil != null && now.isAfter(availableUntil!)) return false;
    return isActive;
  }

  String get displayCategory => _getCategoryName(category);
  String get displayDifficulty => _getDifficultyName(difficulty);
  String get displayFrequency => _getFrequencyName(frequency);

  // Factory para crear desde JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      category: _parseCategory(json['category'] ?? ''),
      icon: json['icon'] ?? '🌱',
      color: ActivityUtils.parseColor(json['color'] ?? ''),
      maxDaily: json['maxDaily'] ?? 1,
      frequency: _parseFrequency(json['frequency'] ?? ''),
      difficulty: _parseDifficulty(json['difficulty'] ?? ''),
      estimatedDuration: json['estimatedDuration'] != null
          ? Duration(minutes: json['estimatedDuration'])
          : null,
      tags: List<String>.from(json['tags'] ?? []),
      tutorialUrl: json['tutorialUrl'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      isActive: json['isActive'] ?? true,
      availableFrom: json['availableFrom'] != null
          ? DateTime.parse(json['availableFrom'])
          : null,
      availableUntil: json['availableUntil'] != null
          ? DateTime.parse(json['availableUntil'])
          : null,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'points': points,
      'category': _getCategoryString(category),
      'icon': icon,
      'color': ActivityUtils.getColorString(color),
      'maxDaily': maxDaily,
      'frequency': _getFrequencyString(frequency),
      'difficulty': _getDifficultyString(difficulty),
      'estimatedDuration': estimatedDuration?.inMinutes,
      'tags': tags,
      'tutorialUrl': tutorialUrl,
      'metadata': metadata,
      'isActive': isActive,
      'availableFrom': availableFrom?.toIso8601String(),
      'availableUntil': availableUntil?.toIso8601String(),
    };
  }

  // Método copyWith
  Activity copyWith({
    String? id,
    String? name,
    String? description,
    int? points,
    ActivityCategory? category,
    String? icon,
    Color? color,
    int? maxDaily,
    ActivityFrequency? frequency,
    ActivityDifficulty? difficulty,
    Duration? estimatedDuration,
    List<String>? tags,
    String? tutorialUrl,
    Map<String, dynamic>? metadata,
    bool? isActive,
    DateTime? availableFrom,
    DateTime? availableUntil,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      points: points ?? this.points,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      maxDaily: maxDaily ?? this.maxDaily,
      frequency: frequency ?? this.frequency,
      difficulty: difficulty ?? this.difficulty,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      tags: tags ?? this.tags,
      tutorialUrl: tutorialUrl ?? this.tutorialUrl,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
    );
  }

  // Métodos estáticos para parsing
  static ActivityCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cultivo':
        return ActivityCategory.cultivo;
      case 'hábitos':
      case 'habitos':
        return ActivityCategory.habitos;
      case 'social':
        return ActivityCategory.social;
      case 'habilidad':
        return ActivityCategory.habilidad;
      case 'misiones':
        return ActivityCategory.misiones;
      case 'riego':
        return ActivityCategory.riego;
      case 'cosecha':
        return ActivityCategory.cosecha;
      case 'mantenimiento':
        return ActivityCategory.mantenimiento;
      default:
        return ActivityCategory.cultivo;
    }
  }

  static ActivityFrequency _parseFrequency(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'diaria':
        return ActivityFrequency.diaria;
      case 'semanal':
        return ActivityFrequency.semanal;
      case 'mensual':
        return ActivityFrequency.mensual;
      case 'única':
      case 'unica':
        return ActivityFrequency.unica;
      case 'personalizada':
        return ActivityFrequency.personalizada;
      default:
        return ActivityFrequency.diaria;
    }
  }

  static ActivityDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
      case 'facil':
        return ActivityDifficulty.facil;
      case 'medio':
        return ActivityDifficulty.medio;
      case 'difícil':
      case 'dificil':
        return ActivityDifficulty.dificil;
      case 'experto':
        return ActivityDifficulty.experto;
      default:
        return ActivityDifficulty.facil;
    }
  }

  static String _getCategoryString(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return 'cultivo';
      case ActivityCategory.habitos:
        return 'hábitos';
      case ActivityCategory.social:
        return 'social';
      case ActivityCategory.habilidad:
        return 'habilidad';
      case ActivityCategory.misiones:
        return 'misiones';
      case ActivityCategory.riego:
        return 'riego';
      case ActivityCategory.cosecha:
        return 'cosecha';
      case ActivityCategory.mantenimiento:
        return 'mantenimiento';
    }
  }

  static String _getFrequencyString(ActivityFrequency frequency) {
    switch (frequency) {
      case ActivityFrequency.diaria:
        return 'diaria';
      case ActivityFrequency.semanal:
        return 'semanal';
      case ActivityFrequency.mensual:
        return 'mensual';
      case ActivityFrequency.unica:
        return 'única';
      case ActivityFrequency.personalizada:
        return 'personalizada';
    }
  }

  static String _getDifficultyString(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 'fácil';
      case ActivityDifficulty.medio:
        return 'medio';
      case ActivityDifficulty.dificil:
        return 'difícil';
      case ActivityDifficulty.experto:
        return 'experto';
    }
  }

  String _getCategoryName(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return 'Cultivo';
      case ActivityCategory.habitos:
        return 'Hábitos';
      case ActivityCategory.social:
        return 'Social';
      case ActivityCategory.habilidad:
        return 'Habilidad';
      case ActivityCategory.misiones:
        return 'Misiones';
      case ActivityCategory.riego:
        return 'Riego';
      case ActivityCategory.cosecha:
        return 'Cosecha';
      case ActivityCategory.mantenimiento:
        return 'Mantenimiento';
    }
  }

  String _getDifficultyName(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 'Fácil';
      case ActivityDifficulty.medio:
        return 'Medio';
      case ActivityDifficulty.dificil:
        return 'Difícil';
      case ActivityDifficulty.experto:
        return 'Experto';
    }
  }

  String _getFrequencyName(ActivityFrequency frequency) {
    switch (frequency) {
      case ActivityFrequency.diaria:
        return 'Diaria';
      case ActivityFrequency.semanal:
        return 'Semanal';
      case ActivityFrequency.mensual:
        return 'Mensual';
      case ActivityFrequency.unica:
        return 'Única';
      case ActivityFrequency.personalizada:
        return 'Personalizada';
    }
  }
}

// Modelo para registrar una actividad completada por el usuario
class CompletedActivity {
  final String id;
  final String activityId;
  final String userId;
  final DateTime completedAt;
  final int pointsEarned;
  final Map<String, dynamic>? metadata;
  final Duration? timeSpent;
  final String? notes;
  final bool isVerified; // Si fue verificada automática o manualmente

  const CompletedActivity({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.completedAt,
    required this.pointsEarned,
    this.metadata,
    this.timeSpent,
    this.notes,
    this.isVerified = true,
  });

  factory CompletedActivity.fromJson(Map<String, dynamic> json) {
    return CompletedActivity(
      id: json['id'] ?? '',
      activityId: json['activityId'] ?? '',
      userId: json['userId'] ?? '',
      completedAt: DateTime.parse(json['completedAt']),
      pointsEarned: json['pointsEarned'] ?? 0,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      timeSpent: json['timeSpent'] != null
          ? Duration(seconds: json['timeSpent'])
          : null,
      notes: json['notes'],
      isVerified: json['isVerified'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'userId': userId,
      'completedAt': completedAt.toIso8601String(),
      'pointsEarned': pointsEarned,
      'metadata': metadata,
      'timeSpent': timeSpent?.inSeconds,
      'notes': notes,
      'isVerified': isVerified,
    };
  }

  CompletedActivity copyWith({
    String? id,
    String? activityId,
    String? userId,
    DateTime? completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
    Duration? timeSpent,
    String? notes,
    bool? isVerified,
  }) {
    return CompletedActivity(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      userId: userId ?? this.userId,
      completedAt: completedAt ?? this.completedAt,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      metadata: metadata ?? this.metadata,
      timeSpent: timeSpent ?? this.timeSpent,
      notes: notes ?? this.notes,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

// Modelo para estadísticas de actividad
class ActivityStats {
  final String userId;
  final int totalActivities;
  final int totalPoints;
  final Map<String, int> activitiesByCategory;
  final Map<String, int> activitiesByDay;
  final String mostActiveCategory;
  final String mostActiveDay;
  final Duration averageTimeSpent;
  final int currentStreak;
  final int longestStreak;
  final Map<ActivityDifficulty, int> activitiesByDifficulty;

  const ActivityStats({
    required this.userId,
    required this.totalActivities,
    required this.totalPoints,
    required this.activitiesByCategory,
    required this.activitiesByDay,
    required this.mostActiveCategory,
    required this.mostActiveDay,
    required this.averageTimeSpent,
    required this.currentStreak,
    required this.longestStreak,
    required this.activitiesByDifficulty,
  });

  factory ActivityStats.fromJson(Map<String, dynamic> json) {
    return ActivityStats(
      userId: json['userId'] ?? '',
      totalActivities: json['totalActivities'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      activitiesByCategory:
          Map<String, int>.from(json['activitiesByCategory'] ?? {}),
      activitiesByDay: Map<String, int>.from(json['activitiesByDay'] ?? {}),
      mostActiveCategory: json['mostActiveCategory'] ?? '',
      mostActiveDay: json['mostActiveDay'] ?? '',
      averageTimeSpent: Duration(seconds: json['averageTimeSpent'] ?? 0),
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      activitiesByDifficulty:
          (json['activitiesByDifficulty'] as Map<String, dynamic>? ?? {}).map(
              (key, value) => MapEntry(_parseDifficulty(key), value as int)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalActivities': totalActivities,
      'totalPoints': totalPoints,
      'activitiesByCategory': activitiesByCategory,
      'activitiesByDay': activitiesByDay,
      'mostActiveCategory': mostActiveCategory,
      'mostActiveDay': mostActiveDay,
      'averageTimeSpent': averageTimeSpent.inSeconds,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'activitiesByDifficulty': activitiesByDifficulty
          .map((key, value) => MapEntry(_getDifficultyString(key), value)),
    };
  }

  // Getters útiles
  double get averagePointsPerActivity {
    return totalActivities > 0 ? totalPoints / totalActivities : 0;
  }

  int get activitiesThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return activitiesByDay.entries
        .where((entry) {
          final date = DateTime.parse(entry.key);
          return date.isAfter(weekStart.subtract(const Duration(days: 1)));
        })
        .map((entry) => entry.value)
        .fold(0, (sum, count) => sum + count);
  }

  static ActivityDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
      case 'facil':
        return ActivityDifficulty.facil;
      case 'medio':
        return ActivityDifficulty.medio;
      case 'difícil':
      case 'dificil':
        return ActivityDifficulty.dificil;
      case 'experto':
        return ActivityDifficulty.experto;
      default:
        return ActivityDifficulty.facil;
    }
  }

  static String _getDifficultyString(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 'fácil';
      case ActivityDifficulty.medio:
        return 'medio';
      case ActivityDifficulty.dificil:
        return 'difícil';
      case ActivityDifficulty.experto:
        return 'experto';
    }
  }
}

// Clase de utilidad para actividades
class ActivityUtils {
  // Método para parsear color
  static Color parseColor(String colorName) {
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
      case 'tomatoRed':
        return tomatoRed;
      case 'oceanMist':
        return oceanMist;
      case 'lightSage':
        return lightSage;
      case 'springGrass':
        return springGrass;
      default:
        // Si es un código hexadecimal
        if (colorName.startsWith('0x') || colorName.startsWith('#')) {
          return Color(int.parse(colorName.replaceFirst('#', '0xff')));
        }
        return freshMint;
    }
  }

  // Método para obtener nombre de color
  static String getColorString(Color color) {
    if (color.value == freshMint.value) return 'freshMint';
    if (color.value == clearBlue.value) return 'clearBlue';
    if (color.value == sunflower.value) return 'sunflower';
    if (color.value == goldenSun.value) return 'goldenSun';
    if (color.value == berryPink.value) return 'berryPink';
    if (color.value == emeraldLeaf.value) return 'emeraldLeaf';
    if (color.value == forestDepth.value) return 'forestDepth';
    if (color.value == tomatoRed.value) return 'tomatoRed';
    if (color.value == oceanMist.value) return 'oceanMist';
    if (color.value == lightSage.value) return 'lightSage';
    if (color.value == springGrass.value) return 'springGrass';
    return 'freshMint';
  }

  // Obtener todas las actividades de ejemplo
  static List<Activity> getSampleActivities() {
    return [
      Activity(
        id: 'plant_seed',
        name: 'Plantar Semilla',
        description: 'Planta una nueva semilla en tu huerto',
        points: 25,
        category: ActivityCategory.cultivo,
        icon: '🌱',
        color: freshMint,
        maxDaily: 5,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: const Duration(minutes: 10),
        tags: ['cultivo', 'inicio', 'básico'],
        tutorialUrl: 'https://ejemplo.com/tutorial/plantar',
        metadata: {
          'requiredTools': ['semillas', 'tierra', 'maceta'],
          'season': ['primavera', 'verano', 'otoño'],
          'waterNeeds': 'medio',
        },
      ),
      Activity(
        id: 'water_plant',
        name: 'Regar Plantas',
        description: 'Riega las plantas de tu huerto',
        points: 10,
        category: ActivityCategory.riego,
        icon: '💧',
        color: clearBlue,
        maxDaily: 10,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: const Duration(minutes: 5),
        tags: ['riego', 'mantenimiento', 'diario'],
        metadata: {
          'waterAmount': 'moderado',
          'bestTime': 'mañana',
          'avoid': 'hojas mojadas por la noche',
        },
      ),
      Activity(
        id: 'harvest_plant',
        name: 'Cosechar Planta',
        description: 'Recoge los frutos de tus plantas maduras',
        points: 50,
        category: ActivityCategory.cosecha,
        icon: '🌾',
        color: goldenSun,
        maxDaily: 3,
        frequency: ActivityFrequency.semanal,
        difficulty: ActivityDifficulty.medio,
        estimatedDuration: const Duration(minutes: 15),
        tags: ['cosecha', 'recompensa', 'fructífero'],
        metadata: {
          'requires': 'planta madura',
          'bestTime': 'mañana temprano',
          'tools': ['tijeras', 'canasta'],
        },
      ),
      Activity(
        id: 'daily_login',
        name: 'Login Diario',
        description: 'Inicia sesión en la aplicación',
        points: 5,
        category: ActivityCategory.habitos,
        icon: '📅',
        color: sunflower,
        maxDaily: 1,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: const Duration(seconds: 30),
        tags: ['hábito', 'consistencia', 'diario'],
        metadata: {
          'streakBonus': 'puntos extra por racha',
          'reminder': 'activar notificaciones',
        },
      ),
      Activity(
        id: 'share_garden',
        name: 'Compartir Huerto',
        description: 'Comparte el progreso de tu huerto con amigos',
        points: 15,
        category: ActivityCategory.social,
        icon: '📤',
        color: berryPink,
        maxDaily: 3,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: const Duration(minutes: 2),
        tags: ['social', 'compartir', 'comunidad'],
        metadata: {
          'platforms': ['whatsapp', 'instagram', 'facebook'],
          'reward': 'puntos sociales extra',
        },
      ),
      Activity(
        id: 'complete_tutorial',
        name: 'Completar Tutorial',
        description: 'Aprende sobre el cuidado de plantas',
        points: 30,
        category: ActivityCategory.habilidad,
        icon: '🎓',
        color: forestDepth,
        maxDaily: 1,
        frequency: ActivityFrequency.unica,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: const Duration(minutes: 20),
        tags: ['aprendizaje', 'tutorial', 'habilidad'],
        tutorialUrl: 'https://ejemplo.com/tutorial/completo',
        metadata: {
          'chapters': 5,
          'quiz': 'disponible al final',
          'certificate': 'disponible',
        },
      ),
      Activity(
        id: 'prune_plant',
        name: 'Podar Planta',
        description: 'Poda las ramas y hojas secas de tus plantas',
        points: 20,
        category: ActivityCategory.mantenimiento,
        icon: '✂️',
        color: emeraldLeaf,
        maxDaily: 2,
        frequency: ActivityFrequency.semanal,
        difficulty: ActivityDifficulty.medio,
        estimatedDuration: const Duration(minutes: 15),
        tags: ['mantenimiento', 'salud', 'poda'],
        metadata: {
          'tools': ['tijeras de podar', 'guantes'],
          'season': 'todo el año',
          'frequency': 'cada 2 semanas',
        },
      ),
      Activity(
        id: 'add_fertilizer',
        name: 'Añadir Fertilizante',
        description: 'Nutre tus plantas con fertilizante natural',
        points: 35,
        category: ActivityCategory.cultivo,
        icon: '🧪',
        color: tomatoRed,
        maxDaily: 1,
        frequency: ActivityFrequency.mensual,
        difficulty: ActivityDifficulty.dificil,
        estimatedDuration: const Duration(minutes: 25),
        tags: ['nutrición', 'crecimiento', 'avanzado'],
        metadata: {
          'fertilizerType': 'orgánico',
          'bestTime': 'temporada de crecimiento',
          'precautions': 'no exceder dosis',
        },
      ),
      Activity(
        id: 'identify_pest',
        name: 'Identificar Plaga',
        description: 'Aprende a identificar y tratar plagas comunes',
        points: 40,
        category: ActivityCategory.habilidad,
        icon: '🐛',
        color: oceanMist,
        maxDaily: 1,
        frequency: ActivityFrequency.unica,
        difficulty: ActivityDifficulty.experto,
        estimatedDuration: const Duration(minutes: 30),
        tags: ['diagnóstico', 'salud', 'experto'],
        tutorialUrl: 'https://ejemplo.com/tutorial/plagas',
        metadata: {
          'commonPests': ['pulgón', 'araña roja', 'cochinilla'],
          'treatment': 'orgánico recomendado',
          'prevention': 'control regular',
        },
      ),
      Activity(
        id: 'garden_planning',
        name: 'Planificar Huerto',
        description: 'Planifica la distribución de tu huerto',
        points: 45,
        category: ActivityCategory.misiones,
        icon: '📝',
        color: lightSage,
        maxDaily: 1,
        frequency: ActivityFrequency.mensual,
        difficulty: ActivityDifficulty.medio,
        estimatedDuration: const Duration(minutes: 40),
        tags: ['planificación', 'diseño', 'organización'],
        metadata: {
          'tools': ['papel', 'lápiz', 'regla'],
          'considerations': ['luz solar', 'espacio', 'compatibilidad'],
          'reward': 'huerto más productivo',
        },
      ),
    ];
  }

  // Obtener actividades por categoría
  static Map<ActivityCategory, List<Activity>> getActivitiesByCategory() {
    final Map<ActivityCategory, List<Activity>> categorized = {};
    final activities = getSampleActivities();

    for (final activity in activities) {
      categorized.putIfAbsent(activity.category, () => []).add(activity);
    }

    return categorized;
  }

  // Obtener actividades por dificultad
  static Map<ActivityDifficulty, List<Activity>> getActivitiesByDifficulty() {
    final Map<ActivityDifficulty, List<Activity>> byDifficulty = {};
    final activities = getSampleActivities();

    for (final activity in activities) {
      byDifficulty.putIfAbsent(activity.difficulty, () => []).add(activity);
    }

    return byDifficulty;
  }

  // Obtener color por categoría
  static Color getCategoryColor(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return freshMint;
      case ActivityCategory.habitos:
        return sunflower;
      case ActivityCategory.social:
        return berryPink;
      case ActivityCategory.habilidad:
        return forestDepth;
      case ActivityCategory.misiones:
        return lightSage;
      case ActivityCategory.riego:
        return clearBlue;
      case ActivityCategory.cosecha:
        return goldenSun;
      case ActivityCategory.mantenimiento:
        return emeraldLeaf;
    }
  }

  // Obtener icono por categoría
  static String getCategoryIcon(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return '🌱';
      case ActivityCategory.habitos:
        return '📅';
      case ActivityCategory.social:
        return '👥';
      case ActivityCategory.habilidad:
        return '🎓';
      case ActivityCategory.misiones:
        return '📝';
      case ActivityCategory.riego:
        return '💧';
      case ActivityCategory.cosecha:
        return '🌾';
      case ActivityCategory.mantenimiento:
        return '🛠️';
    }
  }

  // Obtener nombre de categoría
  static String getCategoryName(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return 'Cultivo';
      case ActivityCategory.habitos:
        return 'Hábitos';
      case ActivityCategory.social:
        return 'Social';
      case ActivityCategory.habilidad:
        return 'Habilidad';
      case ActivityCategory.misiones:
        return 'Misiones';
      case ActivityCategory.riego:
        return 'Riego';
      case ActivityCategory.cosecha:
        return 'Cosecha';
      case ActivityCategory.mantenimiento:
        return 'Mantenimiento';
    }
  }

  // Obtener color por dificultad
  static Color getDifficultyColor(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return const Color(0xFF4CAF50); // Verde
      case ActivityDifficulty.medio:
        return const Color(0xFFFF9800); // Naranja
      case ActivityDifficulty.dificil:
        return const Color(0xFFF44336); // Rojo
      case ActivityDifficulty.experto:
        return const Color(0xFF9C27B0); // Púrpura
    }
  }

  // Crear estadísticas de ejemplo
  static ActivityStats getSampleStats(String userId) {
    return ActivityStats(
      userId: userId,
      totalActivities: 42,
      totalPoints: 875,
      activitiesByCategory: {
        'Cultivo': 15,
        'Riego': 12,
        'Cosecha': 5,
        'Hábitos': 8,
        'Social': 2,
      },
      activitiesByDay: {
        '2024-01-15': 3,
        '2024-01-16': 2,
        '2024-01-17': 4,
        '2024-01-18': 1,
        '2024-01-19': 3,
      },
      mostActiveCategory: 'Cultivo',
      mostActiveDay: 'Miércoles',
      averageTimeSpent: const Duration(minutes: 12),
      currentStreak: 5,
      longestStreak: 12,
      activitiesByDifficulty: {
        ActivityDifficulty.facil: 25,
        ActivityDifficulty.medio: 12,
        ActivityDifficulty.dificil: 4,
        ActivityDifficulty.experto: 1,
      },
    );
  }

  // Filtrar actividades por disponibilidad
  static List<Activity> getAvailableActivities() {
    return getSampleActivities()
        .where((activity) => activity.isAvailable)
        .toList();
  }

  // Obtener actividades recomendadas para un usuario
  static List<Activity> getRecommendedActivities({
    required List<String> completedActivityIds,
    required ActivityCategory? preferredCategory,
    required ActivityDifficulty? userLevel,
  }) {
    final allActivities = getAvailableActivities();

    // Filtrar actividades no completadas
    var recommended = allActivities
        .where((activity) => !completedActivityIds.contains(activity.id))
        .toList();

    // Priorizar categoría preferida
    if (preferredCategory != null) {
      recommended.sort((a, b) {
        if (a.category == preferredCategory && b.category != preferredCategory)
          return -1;
        if (a.category != preferredCategory && b.category == preferredCategory)
          return 1;
        return 0;
      });
    }

    // Ajustar dificultad según nivel del usuario
    if (userLevel != null) {
      recommended.sort((a, b) {
        final aDiff = _difficultyValue(a.difficulty);
        final bDiff = _difficultyValue(b.difficulty);
        final targetDiff = _difficultyValue(userLevel);

        final aDistance = (aDiff - targetDiff).abs();
        final bDistance = (bDiff - targetDiff).abs();

        return aDistance.compareTo(bDistance);
      });
    }

    // Limitar a 6 recomendaciones
    return recommended.take(6).toList();
  }

  static int _difficultyValue(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 1;
      case ActivityDifficulty.medio:
        return 2;
      case ActivityDifficulty.dificil:
        return 3;
      case ActivityDifficulty.experto:
        return 4;
    }
  }
}

// Modelo para misiones especiales (actividades agrupadas)
class Mission {
  final String id;
  final String name;
  final String description;
  final List<String> activityIds;
  final int rewardPoints;
  final String icon;
  final Color color;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  const Mission({
    required this.id,
    required this.name,
    required this.description,
    required this.activityIds,
    required this.rewardPoints,
    required this.icon,
    required this.color,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.metadata,
  });

  bool get isAvailable {
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return isActive;
  }

  double calculateProgress(List<String> completedActivityIds) {
    if (activityIds.isEmpty) return 0;
    final completed =
        activityIds.where((id) => completedActivityIds.contains(id)).length;
    return completed / activityIds.length;
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      activityIds: List<String>.from(json['activityIds'] ?? []),
      rewardPoints: json['rewardPoints'] ?? 0,
      icon: json['icon'] ?? '🎯',
      color: ActivityUtils.parseColor(json['color'] ?? ''),
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'] ?? true,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'activityIds': activityIds,
      'rewardPoints': rewardPoints,
      'icon': icon,
      'color': ActivityUtils.getColorString(color),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }
}
