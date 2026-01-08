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

  // Método para verificar logros nuevos (reemplaza el de achievement_checker_service.dart)
  static List<Achievement> checkAchievements(UserModel user) {
    final sampleAchievements = AchievementUtils.getSampleAchievements();
    final List<Achievement> newAchievements = [];

    // Verificar cada logro de muestra
    for (final achievement in sampleAchievements) {
      // Si el usuario no tiene este logro
      if (!user.hasAchievement(achievement.id)) {
        // Verificar si cumple los requisitos
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
        }
      }
    }

    return newAchievements;
  }
}
