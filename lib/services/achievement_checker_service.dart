// services/achievement_checker_service.dart
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/achievement_model.dart';

class AchievementCheckerService {
  static List<Achievement> checkAchievements(UserModel user) {
    final List<Achievement> newAchievements = [];
    final sampleAchievements = AchievementUtils.getSampleAchievements();

    // Verificar cada logro de muestra
    for (final achievement in sampleAchievements) {
      // Si el usuario no tiene este logro
      if (!user.hasAchievement(achievement.id)) {
        // Verificar si cumple los requisitos
        switch (achievement.id) {
          case 'first_seed':
            if (user.getActivityCount('plant_seed') >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'daily_streak_3':
            if (user.consecutiveDays >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'total_activities_10':
            if (user.totalActivitiesCompleted >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'water_master_beginner':
            if (user.getActivityCount('water_plant') >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'level_2':
            if (user.level >= 2) {
              newAchievements.add(achievement);
            }
            break;
          case 'social_beginner':
            if (user.getActivityCount('share_garden') >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'first_harvest':
            if (user.getActivityCount('harvest_plant') >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'plant_collector':
            if (user.getActivityCount('plant_seed') >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'daily_streak_7':
            if (user.consecutiveDays >= 7) {
              newAchievements.add(achievement);
            }
            break;
          case 'level_5':
            if (user.level >= 5) {
              newAchievements.add(achievement);
            }
            break;
          case 'water_master_intermediate':
            if (user.getActivityCount('water_plant') >= 50) {
              newAchievements.add(achievement);
            }
            break;
          case 'social_expert':
            if (user.getActivityCount('share_garden') >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'harvest_master':
            if (user.getActivityCount('harvest_plant') >= 5) {
              newAchievements.add(achievement);
            }
            break;
          case 'plant_expert':
            if (user.getActivityCount('plant_seed') >= 10) {
              newAchievements.add(achievement);
            }
            break;
        }
      }
    }

    return newAchievements;
  }

  // Verificar logro específico
  static bool checkSingleAchievement(UserModel user, String achievementId) {
    if (user.hasAchievement(achievementId)) return false;

    final sampleAchievements = AchievementUtils.getSampleAchievements();
    final achievement = sampleAchievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => sampleAchievements.first,
    );

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
        return false;
    }
  }
}
