import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/models/user_model.dart';

class AchievementService {
  // Método para obtener categorías desde JSON
  static Future<List<AchievementCategoryModel>> getCategories() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/data/achievements_data.json');
      print(
          'JSON cargado exitosamente. Longitud: ${jsonString.length} caracteres');

      final data = json.decode(jsonString);
      final categoriesJson = data['categories'] as List? ?? [];

      return categoriesJson
          .map(
              (categoryJson) => AchievementCategoryModel.fromJson(categoryJson))
          .cast<AchievementCategoryModel>()
          .toList();
    } catch (e) {
      print('Error cargando categorías: $e');

      // Si falla, usar datos de muestra
      return AchievementUtils.getSampleCategories();
    }
  }

  // Método para obtener logros desde JSON
  static Future<List<Achievement>> getAchievements() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/data/achievements_data.json');
      final data = json.decode(jsonString);
      final achievementsJson = data['achievements'] as List? ?? [];

      return achievementsJson
          .map((achievementJson) => Achievement.fromJson(achievementJson))
          .cast<Achievement>()
          .toList();
    } catch (e) {
      print('Error cargando logros: $e');

      // Si falla, usar datos de muestra
      return AchievementUtils.getSampleAchievements();
    }
  }

  // Método para verificar logros nuevos
  static List<Achievement> checkAchievements(UserModel user) {
    final sampleAchievements = AchievementUtils.getSampleAchievements();
    final List<Achievement> newAchievements = [];

    // Obtener lista de IDs de logros completados
    // (Necesitarías agregar este campo a UserModel)
    final List<String> completedAchievementIds = [];

    // Contadores de actividades (necesitarías agregar esto a UserModel o usar otro sistema)
    final Map<String, int> activityCounts =
        {}; // Deberías obtener esto de algún lugar

    // Días consecutivos (necesitarías agregar esto a UserModel)
    const int consecutiveDays = 0;

    // Verificar cada logro de muestra
    for (final achievement in sampleAchievements) {
      // Si el usuario no tiene este logro
      if (!completedAchievementIds.contains(achievement.id)) {
        // Verificar si cumple los requisitos
        switch (achievement.id) {
          case 'first_seed':
            if ((activityCounts['plant_seed'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'water_master_beginner':
            if ((activityCounts['water_plant'] ?? 0) >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'daily_streak_3':
            if (consecutiveDays >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'level_2':
            if (user.level >= 2) {
              // Usar user.level en lugar de calculatedLevel
              newAchievements.add(achievement);
            }
            break;
          case 'social_beginner':
            if ((activityCounts['share_garden'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'first_harvest':
            if ((activityCounts['harvest_plant'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
        }
      }
    }

    return newAchievements;
  }
}
