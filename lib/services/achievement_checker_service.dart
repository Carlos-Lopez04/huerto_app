// services/achievement_checker_service.dart
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/achievement_model.dart';

class AchievementCheckerService {
  /*
    VERIFICAR TODOS LOS LOGROS
  */

  // Método estático que verifica todos los logros disponibles para un usuario
  static List<Achievement> checkAchievements(UserModel user) {
    // Lista temporal para almacenar nuevos logros desbloqueados
    final List<Achievement> newAchievements = [];
    // Obtener lista de logros de muestra predefinidos
    final sampleAchievements = AchievementUtils.getSampleAchievements();

    /*
      VERIFICAR CADA LOGRO DE MUESTRA
    */

    // Iterar sobre cada logro disponible
    for (final achievement in sampleAchievements) {
      // Si el usuario no tiene este logro (verificar por ID)
      if (!user.hasAchievement(achievement.id)) {
        /*
          EVALUAR REQUISITOS SEGÚN TIPO DE LOGRO
        */

        // Usar switch para evaluar cada tipo de logro específico
        switch (achievement.id) {
          case 'first_seed': // Primer plantación de semilla
            if (user.getActivityCount('plant_seed') >= 1) {
              newAchievements.add(achievement); // Agregar a lista de nuevos
            }
            break;
          case 'daily_streak_3': // Racha de 3 días consecutivos
            if (user.consecutiveDays >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'total_activities_10': // 10 actividades totales completadas
            if (user.totalActivitiesCompleted >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'water_master_beginner': // 10 riegos completados
            if (user.getActivityCount('water_plant') >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'level_2': // Alcanzar nivel 2
            if (user.level >= 2) {
              newAchievements.add(achievement);
            }
            break;
          case 'social_beginner': // Compartir jardín al menos 1 vez
            if (user.getActivityCount('share_garden') >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'first_harvest': // Primera cosecha
            if (user.getActivityCount('harvest_plant') >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'plant_collector': // Plantar 3 semillas
            if (user.getActivityCount('plant_seed') >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'daily_streak_7': // Racha de 7 días consecutivos
            if (user.consecutiveDays >= 7) {
              newAchievements.add(achievement);
            }
            break;
          case 'level_5': // Alcanzar nivel 5
            if (user.level >= 5) {
              newAchievements.add(achievement);
            }
            break;
          case 'water_master_intermediate': // 50 riegos completados
            if (user.getActivityCount('water_plant') >= 50) {
              newAchievements.add(achievement);
            }
            break;
          case 'social_expert': // Compartir jardín 10 veces
            if (user.getActivityCount('share_garden') >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'harvest_master': // Cosechar 5 plantas
            if (user.getActivityCount('harvest_plant') >= 5) {
              newAchievements.add(achievement);
            }
            break;
          case 'plant_expert': // Plantar 10 semillas
            if (user.getActivityCount('plant_seed') >= 10) {
              newAchievements.add(achievement);
            }
            break;
        }
      }
    }

    // Retornar lista de nuevos logros desbloqueados
    return newAchievements;
  }

  /*
    VERIFICAR LOGRO ESPECÍFICO
  */

  // Método para verificar un logro específico por ID
  static bool checkSingleAchievement(UserModel user, String achievementId) {
    // Si el usuario ya tiene el logro, retornar false
    if (user.hasAchievement(achievementId)) return false;

    // Obtener lista de logros de muestra
    final sampleAchievements = AchievementUtils.getSampleAchievements();
    // Buscar el logro específico por ID
    final achievement = sampleAchievements.firstWhere(
      (a) => a.id == achievementId, // Condición de búsqueda
      orElse: () =>
          sampleAchievements.first, // Valor por defecto si no encuentra
    );

    /*
      EVALUAR CONDICIÓN DEL LOGRO ESPECÍFICO
    */

    // Evaluar requisitos según ID del logro
    switch (achievementId) {
      case 'first_seed':
        return user.getActivityCount('plant_seed') >= 1;
      case 'daily_streak_3':
        return user.consecutiveDays >= 3;
      case 'total_activities_10':
        return user.totalActivitiesCompleted >= 10;
      case 'water_master_beginner':
        return user.getActivityCount('water_plant') >= 10;
      case 'level_2':
        return user.level >= 2;
      case 'social_beginner':
        return user.getActivityCount('share_garden') >= 1;
      case 'first_harvest':
        return user.getActivityCount('harvest_plant') >= 1;
      case 'plant_collector':
        return user.getActivityCount('plant_seed') >= 3;
      default:
        return false; // Retornar false si no es un logro reconocido
    }
  }
}
