// services/activity_service.dart
// import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/models/activity_model.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/achievement_model.dart';

class ActivityService {
  // Definir actividades con puntos
  static final List<Activity> _activities = [
    Activity(
      id: 'plant_seed',
      name: 'Plantar Semilla',
      description: 'Plantar una nueva semilla en tu huerto',
      points: 25,
      category: ActivityCategory.cultivo,
      icon: '🌱',
      color: freshMint,
      maxDaily: 5,
      frequency: ActivityFrequency.diaria,
      difficulty: ActivityDifficulty.facil,
      estimatedDuration: const Duration(minutes: 10),
      tags: ['cultivo', 'inicio', 'básico'],
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
      metadata: {
        'chapters': 5,
        'quiz': 'disponible al final',
        'certificate': 'disponible',
      },
    ),
  ];

  // Registrar actividad y devolver puntos
  static (UserModel, List<Achievement>) registerActivity(
    UserModel user,
    String activityId,
  ) {
    final activity = _activities.firstWhere(
      (a) => a.id == activityId,
      orElse: () => _activities.first,
    );

    // Registrar actividad
    final updatedUser = user.registerActivity(activityId, activity.points);

    // Verificar logros
    final newAchievements = _checkAchievements(updatedUser);

    return (updatedUser, newAchievements);
  }

  // Método temporal para verificar logros
  static List<Achievement> _checkAchievements(UserModel user) {
    final sampleAchievements = AchievementUtils.getSampleAchievements();
    final List<Achievement> newAchievements = [];

    for (final achievement in sampleAchievements) {
      if (!user.hasAchievement(achievement.id)) {
        // Lógica simple de verificación
        switch (achievement.id) {
          case 'first_seed':
            if ((user.activityCounts['plant_seed'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'water_master_beginner':
            if ((user.activityCounts['water_plant'] ?? 0) >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'daily_streak_3':
            if (user.consecutiveDays >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'level_2':
            if (user.calculatedLevel >= 2) {
              newAchievements.add(achievement);
            }
            break;
          case 'social_beginner':
            if ((user.activityCounts['share_garden'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'first_harvest':
            if ((user.activityCounts['harvest_plant'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'plant_collector':
            // CORRECCIÓN: Agregar paréntesis para precedencia correcta
            if ((user.activityCounts['plant_seed'] ?? 0) >= 2) {
              newAchievements.add(achievement);
            }
            break;
        }
      }
    }

    return newAchievements;
  }

  // Obtener actividad por ID
  static Activity? getActivityById(String activityId) {
    try {
      return _activities.firstWhere((activity) => activity.id == activityId);
    } catch (e) {
      return null;
    }
  }

  // Obtener todas las actividades
  static List<Activity> getAllActivities() {
    return List<Activity>.from(_activities);
  }

  // Obtener actividades disponibles
  static List<Activity> getAvailableActivities() {
    return _activities.where((activity) => activity.isAvailable).toList();
  }

  // Obtener actividades por categoría
  static Map<ActivityCategory, List<Activity>> getActivitiesByCategory() {
    final Map<ActivityCategory, List<Activity>> categorized = {};

    for (final activity in _activities) {
      categorized.putIfAbsent(activity.category, () => []).add(activity);
    }

    return categorized;
  }

  // Obtener actividades por dificultad
  static Map<ActivityDifficulty, List<Activity>> getActivitiesByDifficulty() {
    final Map<ActivityDifficulty, List<Activity>> byDifficulty = {};

    for (final activity in _activities) {
      byDifficulty.putIfAbsent(activity.difficulty, () => []).add(activity);
    }

    return byDifficulty;
  }

  // Obtener actividades recomendadas para un usuario
  static List<Activity> getRecommendedActivities({
    required UserModel user,
    int limit = 6,
  }) {
    final completedIds = user.activityCounts.keys.toList();
    final allActivities = getAvailableActivities();

    // Filtrar actividades no completadas
    var recommended = allActivities
        .where((activity) => !completedIds.contains(activity.id))
        .toList();

    // Ordenar por dificultad apropiada
    recommended.sort((a, b) {
      final aDiff = _difficultyValue(a.difficulty);
      final bDiff = _difficultyValue(b.difficulty);
      final userLevel = _getUserDifficultyLevel(user);

      final aDistance = (aDiff - userLevel).abs();
      final bDistance = (bDiff - userLevel).abs();

      return aDistance.compareTo(bDistance);
    });

    // Limitar resultados
    return recommended.take(limit).toList();
  }

  // Calcular nivel de dificultad del usuario
  static int _getUserDifficultyLevel(UserModel user) {
    final totalPoints = user.totalPoints;
    if (totalPoints < 100) return 1; // Fácil
    if (totalPoints < 300) return 2; // Medio
    if (totalPoints < 600) return 3; // Difícil
    return 4; // Experto
  }

  // Convertir dificultad a valor numérico
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

  // Obtener estadísticas de actividades
  static Map<String, dynamic> getActivityStats(UserModel user) {
    final totalActivities =
        user.activityCounts.values.fold(0, (sum, count) => sum + count);
    final totalPoints = user.totalPoints;
    final level = user.calculatedLevel;

    // Calcular actividad más común
    String mostCommonActivity = 'Ninguna';
    int maxCount = 0;
    user.activityCounts.forEach((activityId, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonActivity = getActivityById(activityId)?.name ?? activityId;
      }
    });

    // Calcular días activos esta semana
    final weekActivities = user.dailyActivities.where((daily) {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      return daily.date.isAfter(weekAgo);
    }).length;

    return {
      'totalActivities': totalActivities,
      'totalPoints': totalPoints,
      'level': level,
      'levelProgress': user.levelProgress,
      'mostCommonActivity': mostCommonActivity,
      'activityCounts': user.activityCounts,
      'consecutiveDays': user.consecutiveDays,
      'daysActiveThisWeek': weekActivities,
      'pointsPerDay': user.consecutiveDays > 0
          ? totalPoints / user.consecutiveDays
          : totalPoints,
      'hasLoggedInToday': user.hasLoggedInToday,
    };
  }

  // Obtener actividades completadas hoy
  static List<String> getTodayActivities(UserModel user) {
    final today = DateTime.now();
    final todayActivity = user.dailyActivities.firstWhere(
      (daily) =>
          daily.date.year == today.year &&
          daily.date.month == today.month &&
          daily.date.day == today.day,
      orElse: () => DailyActivity(
        date: today,
        activities: [],
        totalPoints: 0,
      ),
    );

    return todayActivity.activities;
  }

  // Obtener puntos ganados hoy
  static int getTodayPoints(UserModel user) {
    final today = DateTime.now();
    final todayActivity = user.dailyActivities.firstWhere(
      (daily) =>
          daily.date.year == today.year &&
          daily.date.month == today.month &&
          daily.date.day == today.day,
      orElse: () => DailyActivity(
        date: today,
        activities: [],
        totalPoints: 0,
      ),
    );

    return todayActivity.totalPoints;
  }

  // Verificar si una actividad puede realizarse hoy
  static bool canPerformActivityToday(UserModel user, String activityId) {
    final activity = getActivityById(activityId);
    if (activity == null) return false;

    // Verificar límite diario
    final todayActivities = getTodayActivities(user);
    final countToday = todayActivities.where((id) => id == activityId).length;

    return countToday < activity.maxDaily;
  }

  // Obtener actividades frecuentes del usuario
  static List<Activity> getFrequentActivities(UserModel user, {int limit = 4}) {
    // Ordenar actividades por frecuencia
    final sortedEntries = user.activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(limit)
        .map((entry) {
          return getActivityById(entry.key);
        })
        .where((activity) => activity != null)
        .cast<Activity>()
        .toList();
  }
}
