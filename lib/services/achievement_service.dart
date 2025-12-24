import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/achievement_model.dart';

class AchievementService {
  static Future<List<AchievementCategory>> getCategories() async {
    try {
      // RUTA CORREGIDA
      final jsonString =
          await rootBundle.loadString('lib/data/achievements_data.json');
      print(
          'JSON cargado exitosamente. Longitud: ${jsonString.length} caracteres');

      final data = json.decode(jsonString);
      final categoriesJson = data['categories'] as List? ?? [];

      return categoriesJson
          .map((categoryJson) => AchievementCategory.fromJson(categoryJson))
          .cast<AchievementCategory>()
          .toList();
    } catch (e) {
      print('Error cargando categorías: $e');

      // Si falla, usar datos de muestra
      return _getSampleCategories();
    }
  }

  static List<AchievementCategory> _getSampleCategories() {
    final sampleAchievements = [
      const Achievement(
        id: 1,
        title: "Primera Siembra",
        description: "Plantar tu primera semilla",
        category: "Cultivo",
        icon: "eco",
        color: "freshMint",
        points: 10,
        level: "Semilla",
        requirements: "plant_first_seed",
      ),
      const Achievement(
        id: 2,
        title: "Bienvenido al Huerto",
        description: "Completar registro en la app",
        category: "Hábitos",
        icon: "flag",
        color: "clearBlue",
        points: 5,
        level: "Semilla",
        requirements: "complete_registration",
      ),
      const Achievement(
        id: 3,
        title: "Explorador Novato",
        description: "Navegar por todas las secciones de la app",
        category: "Hábitos",
        icon: "explore",
        color: "clearBlue",
        points: 8,
        level: "Semilla",
        requirements: "explore_all_sections",
      ),
      const Achievement(
        id: 4,
        title: "Primer Riego",
        description: "Regar una planta por primera vez",
        category: "Cultivo",
        icon: "water_drop",
        color: "freshMint",
        points: 10,
        level: "Semilla",
        requirements: "water_first_plant",
      ),
    ];

    return [
      AchievementCategory(
        name: "Cultivo",
        emoji: "🌱",
        color: "freshMint",
        totalAchievements: 2,
        unlockedAchievements: 2,
        progressPercentage: 100.0,
        achievements:
            sampleAchievements.where((a) => a.category == "Cultivo").toList(),
      ),
      AchievementCategory(
        name: "Hábitos",
        emoji: "⚡",
        color: "clearBlue",
        totalAchievements: 2,
        unlockedAchievements: 2,
        progressPercentage: 100.0,
        achievements:
            sampleAchievements.where((a) => a.category == "Hábitos").toList(),
      ),
    ];
  }
}
