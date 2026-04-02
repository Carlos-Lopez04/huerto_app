// services/activity_service.dart
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/models/activity_model.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/services/achievement_checker_service.dart';

class ActivityService {
  /*
    DEFINIR ACTIVIDADES CON PUNTOS
  */

  // Lista privada de actividades disponibles en la aplicación
  static final List<Activity> _activities = [
    const Activity(
      id: 'plant_seed', // Identificador único
      name: 'Plantar Semilla', // Nombre para mostrar
      description: 'Plantar una nueva semilla en tu huerto', // Descripción
      points: 25, // Puntos otorgados al completar
      category: ActivityCategory.cultivo, // Categoría de la actividad
      icon: '🌱', // Emoji para representar la actividad
      color: freshMint, // Color asociado de AppTheme
      maxDaily: 5, // Máximo de veces al día
      frequency: ActivityFrequency.diaria, // Frecuencia de realización
      difficulty: ActivityDifficulty.facil, // Nivel de dificultad
      estimatedDuration: Duration(minutes: 10), // Tiempo estimado
      tags: ['cultivo', 'inicio', 'básico'], // Etiquetas para búsqueda
      metadata: {
        // Metadatos adicionales
        'requiredTools': [
          'semillas',
          'tierra',
          'maceta'
        ], // Herramientas necesarias
        'season': ['primavera', 'verano', 'otoño'], // Estaciones adecuadas
        'waterNeeds': 'medio', // Necesidades de agua
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
        'waterAmount': 'moderado', // Cantidad de agua sugerida
        'bestTime': 'mañana', // Mejor momento para regar
        'avoid': 'hojas mojadas por la noche', // Precauciones
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
        'requires': 'planta madura', // Requisito previo
        'bestTime': 'mañana temprano', // Mejor momento para cosechar
        'tools': ['tijeras', 'canasta'], // Herramientas recomendadas
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
        'streakBonus': 'puntos extra por racha', // Beneficio por racha
        'reminder': 'activar notificaciones', // Sugerencia
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
        'platforms': [
          'whatsapp',
          'instagram',
          'facebook'
        ], // Plataformas compatibles
        'reward': 'puntos sociales extra', // Recompensa adicional
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
        'chapters': 5, // Número de capítulos
        'quiz': 'disponible al final', // Evaluación disponible
        'certificate': 'disponible', // Certificación otorgada
      },
    ),
  ];

  /*
    REGISTRAR ACTIVIDAD COMPLETA QUE INCLUYE LOGROS
  */

  // Método principal para registrar actividad con todas sus consecuencias
  static (UserModel, List<Achievement>) registerActivityComplete(
    UserModel user, // Usuario que realiza la actividad
    String activityId, // ID de la actividad a registrar
  ) {
    // Obtener objeto de actividad por ID
    final activity = getActivityById(activityId);
    // Si no se encuentra la actividad, retornar sin cambios
    if (activity == null) {
      return (user, []);
    }

    /*
      PROCESO DE REGISTRO EN 5 PASOS
    */

    // 1. Actualizar contador de actividades del usuario
    final updatedUser = user.updateActivityCount(activityId, 1);

    // 2. Agregar puntos correspondientes a la actividad
    final userWithPoints = updatedUser.addPoints(activity.points);

    // 3. Marcar actividad como completada
    final userWithActivity = userWithPoints.completeActivity(activityId);

    // 4. Verificar logros nuevos desbloqueados
    final newAchievements = AchievementCheckerService.checkAchievements(
      userWithActivity, // Usuario actualizado
    );

    // 5. Agregar logros nuevos al usuario
    UserModel finalUser = userWithActivity; // Usuario final a retornar
    for (final achievement in newAchievements) {
      finalUser =
          finalUser.addAchievement(achievement.id); // Agregar cada logro
    }

    // Retornar usuario actualizado y lista de logros nuevos
    return (finalUser, newAchievements);
  }

  /*
    MÉTODO SIMPLIFICADO PARA COMPATIBILIDAD
  */

  // Alias para mantener compatibilidad con código existente
  static (UserModel, List<Achievement>) registerActivity(
    UserModel user,
    String activityId,
  ) {
    return registerActivityComplete(user, activityId);
  }

  /*
    OBTENER ACTIVIDAD POR ID
  */

  // Buscar actividad en la lista por su ID
  static Activity? getActivityById(String activityId) {
    try {
      // Buscar actividad usando firstWhere
      return _activities.firstWhere((activity) => activity.id == activityId);
    } catch (e) {
      return null; // Retornar null si no se encuentra
    }
  }

  /*
    OBTENER TODAS LAS ACTIVIDADES
  */

  // Retornar copia de la lista de actividades
  static List<Activity> getAllActivities() {
    return List<Activity>.from(
        _activities); // Crear copia para evitar modificaciones
  }

  /*
    OBTENER ACTIVIDADES DISPONIBLES (SIMPLIFICADO)
  */

  // Alias para obtener todas las actividades
  static List<Activity> getAvailableActivities() {
    return _activities;
  }

  /*
    OBTENER ACTIVIDADES POR CATEGORÍA
  */

  // Agrupar actividades por su categoría
  static Map<ActivityCategory, List<Activity>> getActivitiesByCategory() {
    final Map<ActivityCategory, List<Activity>> categorized = {};

    for (final activity in _activities) {
      // Crear lista para categoría si no existe
      categorized.putIfAbsent(activity.category, () => []).add(activity);
    }

    return categorized;
  }

  /*
    OBTENER ACTIVIDADES POR DIFICULTAD
  */

  // Agrupar actividades por nivel de dificultad
  static Map<ActivityDifficulty, List<Activity>> getActivitiesByDifficulty() {
    final Map<ActivityDifficulty, List<Activity>> byDifficulty = {};

    for (final activity in _activities) {
      // Crear lista para dificultad si no existe
      byDifficulty.putIfAbsent(activity.difficulty, () => []).add(activity);
    }

    return byDifficulty;
  }

  /*
    OBTENER ACTIVIDADES RECOMENDADAS PARA UN USUARIO
  */

  // Generar lista de actividades recomendadas personalizadas
  static List<Activity> getRecommendedActivities({
    required UserModel user, // Usuario para personalización
    int limit = 6, // Límite de actividades a retornar
  }) {
    // Filtrar actividades no completadas por el usuario
    var recommended = _activities
        .where((activity) => !user.completedActivityIds.contains(activity.id))
        .toList();

    // Si no hay suficientes actividades no completadas
    if (recommended.length < limit) {
      // Incluir algunas actividades ya completadas
      final completed = _activities
          .where((activity) => user.completedActivityIds.contains(activity.id))
          .take(limit - recommended.length) // Tomar solo las necesarias
          .toList();
      recommended.addAll(completed);
    }

    // Limitar resultados al número especificado
    return recommended.take(limit).toList();
  }

  /*
    OBTENER ESTADÍSTICAS DE ACTIVIDADES SIMPLIFICADAS
  */

  // Calcular estadísticas detalladas de actividades del usuario
  static Map<String, dynamic> getActivityStats(UserModel user) {
    // Obtener total de actividades completadas
    final totalActivities = user.totalActivitiesCompleted;

    /*
      CALCULAR ACTIVIDAD MÁS COMÚN
    */

    String mostCommonActivity = 'Ninguna';
    int maxCount = 0;
    user.activityCounts.forEach((activityId, count) {
      if (count > maxCount) {
        maxCount = count;
        final activity = getActivityById(activityId);
        mostCommonActivity = activity?.name ?? activityId; // Usar nombre o ID
      }
    });

    /*
      CALCULAR CATEGORÍA MÁS ACTIVA
    */

    String mostActiveCategory = 'Ninguna';
    int maxCategoryCount = 0;
    final Map<String, int> categoryCounts = {};

    // Contar actividades por categoría
    for (final entry in user.activityCounts.entries) {
      final activity = getActivityById(entry.key);
      if (activity != null) {
        final categoryName = getCategoryDisplayName(activity.category);
        categoryCounts[categoryName] =
            (categoryCounts[categoryName] ?? 0) + entry.value;
      }
    }

    // Encontrar categoría con mayor conteo
    categoryCounts.forEach((category, count) {
      if (count > maxCategoryCount) {
        maxCategoryCount = count;
        mostActiveCategory = category;
      }
    });

    /*
      RETORNAR MAPA CON TODAS LAS ESTADÍSTICAS
    */

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

  /*
    MÉTODO PÚBLICO PARA OBTENER NOMBRE DE CATEGORÍA - CORREGIDO
  */

  // Convertir enum de categoría a string legible
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

  /*
    VERIFICAR SI UNA ACTIVIDAD PUEDE REALIZARSE HOY
  */

  // Validar si una actividad está disponible para hoy
  static bool canPerformActivityToday(
    UserModel user,
    String activityId,
  ) {
    // Obtener objeto de actividad
    final activity = getActivityById(activityId);
    if (activity == null) return false; // Si no existe, no puede realizarse

    /*
      VERIFICAR LÍMITE DIARIO BASADO EN FECHA
    */

    final today = DateTime.now(); // Fecha actual
    final lastActivityDate = user.lastActivityDate;

    // Si la última actividad no fue hoy, reiniciar contadores
    if (lastActivityDate == null ||
        lastActivityDate.year != today.year ||
        lastActivityDate.month != today.month ||
        lastActivityDate.day != today.day) {
      return true; // Nuevo día, puede realizar actividad
    }

    // Verificar contador del día actual
    final countToday = user.getActivityCount(activityId);
    return countToday < activity.maxDaily; // Comprobar límite diario
  }

  /*
    OBTENER ACTIVIDADES FRECUENTES DEL USUARIO
  */

  // Obtener actividades más frecuentes del usuario
  static List<Activity> getFrequentActivities(UserModel user, {int limit = 4}) {
    // Ordenar actividades por frecuencia (mayor a menor)
    final sortedEntries = user.activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Convertir entradas a objetos Activity
    return sortedEntries
        .take(limit) // Tomar solo las más frecuentes
        .map((entry) => getActivityById(entry.key))
        .where((activity) => activity != null) // Filtrar nulls
        .cast<Activity>() // Asegurar tipo
        .toList();
  }
}
