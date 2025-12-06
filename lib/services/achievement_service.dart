import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/achievement_model.dart';

class AchievementService {
  static Future<Map<String, dynamic>> loadAchievementsData() async {
    try {
      // Para usar el archivo JSON actual en lib/data/
      final String jsonString = await rootBundle.loadString(
        'lib/data/achievements_data.json',
      );
      final data = json.decode(jsonString);
      
      // Verificar si tiene la estructura correcta
      if (data['categories'] != null && data['stats'] != null) {
        return data;
      } else {
        // Si no tiene la estructura correcta, usar datos de ejemplo
        return _getSampleData();
      }
    } catch (e) {
      print('Error loading achievements data: $e');
      // Retornar datos de ejemplo en caso de error
      return _getSampleData();
    }
  }

  static Future<List<AchievementCategory>> getCategories() async {
    try {
      final data = await loadAchievementsData();
      final categoriesJson = data['categories'] as List? ?? [];
      
      return categoriesJson
          .map((categoryJson) => AchievementCategory.fromJson(categoryJson))
          .cast<AchievementCategory>()
          .toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  static Future<AchievementStats> getStats() async {
    try {
      final data = await loadAchievementsData();
      final statsJson = data['stats'] as Map<String, dynamic>? ?? {};
      
      return AchievementStats.fromJson(statsJson);
    } catch (e) {
      print('Error getting stats: $e');
      return const AchievementStats(
        totalAchievements: 0,
        unlockedAchievements: 0,
        totalPoints: 0,
        currentLevel: 'Semilla',
        achievementsByCategory: {},
        achievementsByLevel: {},
      );
    }
  }

  static Future<List<Achievement>> getAllAchievements() async {
    try {
      final categories = await getCategories();
      final allAchievements = <Achievement>[];
      
      for (final category in categories) {
        allAchievements.addAll(category.achievements);
      }
      
      return allAchievements;
    } catch (e) {
      print('Error getting all achievements: $e');
      return [];
    }
  }

  // Datos de ejemplo para probar si hay problemas con el JSON
  static Map<String, dynamic> _getSampleData() {
    return {
      "categories": [
        {
          "name": "Cultivo",
          "emoji": "🌱",
          "color": "freshMint",
          "totalAchievements": 8,
          "unlockedAchievements": 3,
          "progressPercentage": 37.5,
          "achievements": [
            {
              "id": 1,
              "title": "Primera Siembra",
              "description": "Plantar tu primera semilla",
              "category": "Cultivo",
              "icon": "eco",
              "color": "freshMint",
              "points": 10,
              "level": "Semilla",
              "requirements": "plant_first_seed"
            },
            {
              "id": 4,
              "title": "Primer Riego",
              "description": "Regar una planta por primera vez",
              "category": "Cultivo",
              "icon": "water_drop",
              "color": "freshMint",
              "points": 10,
              "level": "Semilla",
              "requirements": "water_first_plant"
            },
            {
              "id": 7,
              "title": "Primera Cosecha",
              "description": "Cosechar tu primera planta",
              "category": "Cultivo",
              "icon": "agriculture",
              "color": "freshMint",
              "points": 20,
              "level": "Semilla",
              "requirements": "harvest_first_plant"
            }
          ]
        },
        {
          "name": "Hábitos",
          "emoji": "⚡",
          "color": "clearBlue",
          "totalAchievements": 6,
          "unlockedAchievements": 2,
          "progressPercentage": 33.3,
          "achievements": [
            {
              "id": 2,
              "title": "Bienvenido al Huerto",
              "description": "Completar registro en la app",
              "category": "Hábitos",
              "icon": "flag",
              "color": "clearBlue",
              "points": 5,
              "level": "Semilla",
              "requirements": "complete_registration"
            },
            {
              "id": 3,
              "title": "Explorador Novato",
              "description": "Navegar por todas las secciones de la app",
              "category": "Hábitos",
              "icon": "explore",
              "color": "clearBlue",
              "points": 8,
              "level": "Semilla",
              "requirements": "explore_all_sections"
            }
          ]
        }
      ],
      "stats": {
        "totalAchievements": 14,
        "unlockedAchievements": 5,
        "totalPoints": 53,
        "currentLevel": "Semilla",
        "achievementsByCategory": {
          "Cultivo": 3,
          "Hábitos": 2
        },
        "achievementsByLevel": {
          "Semilla": 5,
          "Brote": 0,
          "Árbol": 0,
          "Bosque": 0
        }
      }
    };
  }
}