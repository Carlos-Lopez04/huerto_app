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
            if ((user.activityCounts['plant_seed'] ?? 0) >= 1) {
              newAchievements.add(achievement);
            }
            break;
          case 'daily_streak_3':
            if (user.consecutiveDays >= 3) {
              newAchievements.add(achievement);
            }
            break;
          case 'total_activities_10':
            final userActivityCount =
                user.activityCounts.values.fold(0, (sum, count) => sum + count);
            if (userActivityCount >= 10) {
              newAchievements.add(achievement);
            }
            break;
          case 'water_master_beginner':
            if ((user.activityCounts['water_plant'] ?? 0) >= 10) {
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
            if ((user.activityCounts['plant_seed'] ?? 0) >= 3) {
              newAchievements.add(achievement);
            }
            break;
        }
      }
    }

    return newAchievements;
  }

  // Método para añadir logros al usuario
  static UserModel addAchievementsToUser(
      UserModel user, List<Achievement> achievements) {
    UserModel updatedUser = user;

    for (final achievement in achievements) {
      updatedUser = updatedUser.addAchievement(achievement);
    }

    return updatedUser;
  }
}
