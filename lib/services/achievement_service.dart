// Importar librerías necesarias para manejo de JSON y assets
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/models/user_model.dart';

class AchievementService {
  /*
    OBTENER CATEGORÍAS DESDE JSON
  */

  // Método asíncrono para cargar categorías desde archivo JSON
  static Future<List<AchievementCategoryModel>> getCategories() async {
    try {
      // Cargar contenido del archivo JSON desde assets
      final jsonString =
          await rootBundle.loadString('lib/data/achievements_data.json');
      // Imprimir confirmación de carga exitosa
      print(
          'JSON cargado exitosamente. Longitud: ${jsonString.length} caracteres');

      // Decodificar string JSON a objeto Dart
      final data = json.decode(jsonString);
      // Obtener lista de categorías, usar lista vacía si no existe
      final categoriesJson = data['categories'] as List? ?? [];

      // Convertir cada objeto JSON a modelo de categoría
      return categoriesJson
          .map(
              (categoryJson) => AchievementCategoryModel.fromJson(categoryJson))
          .cast<AchievementCategoryModel>() // Asegurar tipo
          .toList(); // Convertir a lista
    } catch (e) {
      // Manejar error de carga
      print('Error cargando categorías: $e');

      /*
        USAR DATOS DE MUESTRA EN CASO DE ERROR
      */

      // Retornar categorías predefinidas como respaldo
      return AchievementUtils.getSampleCategories();
    }
  }

  /*
    OBTENER LOGROS DESDE JSON
  */

  // Método asíncrono para cargar logros desde archivo JSON
  static Future<List<Achievement>> getAchievements() async {
    try {
      // Cargar archivo JSON
      final jsonString =
          await rootBundle.loadString('lib/data/achievements_data.json');
      final data = json.decode(jsonString);
      // Obtener lista de logros, usar lista vacía si no existe
      final achievementsJson = data['achievements'] as List? ?? [];

      // Convertir cada objeto JSON a modelo de logro
      return achievementsJson
          .map((achievementJson) => Achievement.fromJson(achievementJson))
          .cast<Achievement>() // Asegurar tipo
          .toList(); // Convertir a lista
    } catch (e) {
      // Manejar error de carga
      print('Error cargando logros: $e');

      /*
        USAR DATOS DE MUESTRA EN CASO DE ERROR
      */

      // Retornar logros predefinidos como respaldo
      return AchievementUtils.getSampleAchievements();
    }
  }

  /*
    VERIFICAR LOGROS NUEVOS
  */

  // Método para verificar logros nuevos de un usuario
  static List<Achievement> checkAchievements(UserModel user) {
    // Obtener logros de muestra predefinidos
    final sampleAchievements = AchievementUtils.getSampleAchievements();
    // Lista para almacenar logros nuevos
    final List<Achievement> newAchievements = [];

    // Obtener lista de IDs de logros completados
    // (Necesitarías agregar este campo a UserModel)
    final List<String> completedAchievementIds = [];

    // Contadores de actividades (necesitarías agregar esto a UserModel o usar otro sistema)
    final Map<String, int> activityCounts =
        {}; // Deberías obtener esto de algún lugar

    // Días consecutivos (necesitarías agregar esto a UserModel)
    const int consecutiveDays = 0;

    /*
      VERIFICAR CADA LOGRO DE MUESTRA
    */

    // Iterar sobre cada logro disponible
    for (final achievement in sampleAchievements) {
      // Si el usuario no tiene este logro (verificar por ID)
      if (!completedAchievementIds.contains(achievement.id)) {
        /*
          EVALUAR CONDICIONES SEGÚN TIPO DE LOGRO
        */

        // Evaluar requisitos usando switch-case
        switch (achievement.id) {
          case 'first_seed': // Plantar primera semilla
            if ((activityCounts['plant_seed'] ?? 0) >= 1) {
              newAchievements.add(achievement); // Agregar a nuevos logros
            }
            break;
          case 'water_master_beginner': // 10 riegos
            if ((activityCounts['water_plant'] ?? 0) >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'daily_streak_3': // 3 días consecutivos
            if (consecutiveDays >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'level_2': // Alcanzar nivel 2
            if (user.level >= 2) {
              // Usar user.level en lugar de calculatedLevel
              newAchievements.add(achievement);
            }
            break;
          case 'social_beginner': // Compartir jardín 1 vez
            if ((activityCounts['share_garden'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'first_harvest': // Primera cosecha
            if ((activityCounts['harvest_plant'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
        }
      }
    }

    // Retornar lista de logros nuevos desbloqueados
    return newAchievements;
  }
}
