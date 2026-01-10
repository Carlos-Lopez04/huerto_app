// services/activity_service.dart
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/models/activity_model.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/services/achievement_checker_service.dart';

class ActivityService {
  // Definir actividades con puntos
  static final List<Activity> _activities = [
    const Activity(
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
      estimatedDuration: Duration(minutes: 10),
      tags: ['cultivo', 'inicio', 'básico'],
      metadata: {
        'requiredTools': ['semillas', 'tierra', 'maceta'],
        'season': ['primavera', 'verano', 'otoño'],
        'waterNeeds': 'medio',
      },
    ),
    const Activity(
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
      estimatedDuration: Duration(minutes: 5),
      tags: ['riego', 'mantenimiento', 'diario'],
      metadata: {
        'waterAmount': 'moderado',
        'bestTime': 'mañana',
        'avoid': 'hojas mojadas por la noche',
      },
    ),
    const Activity(
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
      estimatedDuration: Duration(minutes: 15),
      tags: ['cosecha', 'recompensa', 'fructífero'],
      metadata: {
        'requires': 'planta madura',
        'bestTime': 'mañana temprano',
        'tools': ['tijeras', 'canasta'],
      },
    ),
    const Activity(
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
      estimatedDuration: Duration(seconds: 30),
      tags: ['hábito', 'consistencia', 'diario'],
      metadata: {
        'streakBonus': 'puntos extra por racha',
        'reminder': 'activar notificaciones',
      },
    ),
    const Activity(
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
      estimatedDuration: Duration(minutes: 2),
      tags: ['social', 'compartir', 'comunidad'],
      metadata: {
        'platforms': ['whatsapp', 'instagram', 'facebook'],
        'reward': 'puntos sociales extra',
      },
    ),
    const Activity(
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
      estimatedDuration: Duration(minutes: 20),
      tags: ['aprendizaje', 'tutorial', 'habilidad'],
      metadata: {
        'chapters': 5,
        'quiz': 'disponible al final',
        'certificate': 'disponible',
      },
    ),
  ];

  // Registrar actividad COMPLETA que incluye logros
  static (UserModel, List<Achievement>) registerActivityComplete(
    UserModel user,
    String activityId,
  ) {
    final activity = getActivityById(activityId);
    if (activity == null) {
      return (user, []);
    }

    // 1. Actualizar contador de actividades
    final updatedUser = user.updateActivityCount(activityId, 1);

    // 2. Agregar puntos
    final userWithPoints = updatedUser.addPoints(activity.points);

    // 3. Marcar actividad como completada
    final userWithActivity = userWithPoints.completeActivity(activityId);

    // 4. Verificar logros nuevos
    final newAchievements = AchievementCheckerService.checkAchievements(
      userWithActivity,
    );

    // 5. Agregar logros nuevos al usuario
    UserModel finalUser = userWithActivity;
    for (final achievement in newAchievements) {
      finalUser = finalUser.addAchievement(achievement.id);
    }

    return (finalUser, newAchievements);
  }

  // Método simplificado para compatibilidad
  static (UserModel, List<Achievement>) registerActivity(
    UserModel user,
    String activityId,
  ) {
    return registerActivityComplete(user, activityId);
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

  // Obtener actividades disponibles (simplificado)
  static List<Activity> getAvailableActivities() {
    return _activities;
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

  // Obtener actividades recomendadas para un usuario (simplificado)
  static List<Activity> getRecommendedActivities({
    required UserModel user,
    int limit = 6,
  }) {
    // Filtrar actividades no completadas
    var recommended = _activities
        .where((activity) => !user.completedActivityIds.contains(activity.id))
        .toList();

    // Si no hay suficientes, incluir algunas ya completadas
    if (recommended.length < limit) {
      final completed = _activities
          .where((activity) => user.completedActivityIds.contains(activity.id))
          .take(limit - recommended.length)
          .toList();
      recommended.addAll(completed);
    }

    // Limitar resultados
    return recommended.take(limit).toList();
  }

  // Obtener estadísticas de actividades simplificadas
  static Map<String, dynamic> getActivityStats(UserModel user) {
    final totalActivities = user.totalActivitiesCompleted;

    // Calcular actividad más común
    String mostCommonActivity = 'Ninguna';
    int maxCount = 0;
    user.activityCounts.forEach((activityId, count) {
      if (count > maxCount) {
        maxCount = count;
        final activity = getActivityById(activityId);
        mostCommonActivity = activity?.name ?? activityId;
      }
    });

    // Calcular categoría más activa
    String mostActiveCategory = 'Ninguna';
    int maxCategoryCount = 0;
    final Map<String, int> categoryCounts = {};

    for (final entry in user.activityCounts.entries) {
      final activity = getActivityById(entry.key);
      if (activity != null) {
        final categoryName = getCategoryDisplayName(activity.category);
        categoryCounts[categoryName] =
            (categoryCounts[categoryName] ?? 0) + entry.value;
      }
    }

    categoryCounts.forEach((category, count) {
      if (count > maxCategoryCount) {
        maxCategoryCount = count;
        mostActiveCategory = category;
      }
    });

    return {
      'totalActivities': totalActivities,
      'totalPoints': user.totalPoints,
      'level': user.level,
      'levelProgress': user.levelProgress,
      'mostCommonActivity': mostCommonActivity,
      'mostActiveCategory': mostActiveCategory,
      'activityCounts': user.activityCounts,
      'consecutiveDays': user.consecutiveDays,
      'unlockedAchievements': user.unlockedAchievementsCount,
    };
  }

  // Método público para obtener nombre de categoría - CORREGIDO
  static String getCategoryDisplayName(ActivityCategory category) {
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

  // Verificar si una actividad puede realizarse hoy
  static bool canPerformActivityToday(
    UserModel user,
    String activityId,
  ) {
    final activity = getActivityById(activityId);
    if (activity == null) return false;

    // Verificar límite diario basado en fecha de última actividad
    final today = DateTime.now();
    final lastActivityDate = user.lastActivityDate;

    // Si la última actividad no fue hoy, reiniciar contadores
    if (lastActivityDate == null ||
        lastActivityDate.year != today.year ||
        lastActivityDate.month != today.month ||
        lastActivityDate.day != today.day) {
      return true; // Nuevo día, puede realizar
    }

    // Verificar contador del día actual (simplificado)
    final countToday = user.getActivityCount(activityId);
    return countToday < activity.maxDaily;
  }

  // Obtener actividades frecuentes del usuario
  static List<Activity> getFrequentActivities(UserModel user, {int limit = 4}) {
    // Ordenar actividades por frecuencia
    final sortedEntries = user.activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(limit)
        .map((entry) => getActivityById(entry.key))
        .where((activity) => activity != null)
        .cast<Activity>()
        .toList();
  }
}
