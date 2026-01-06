// models/achievement_model.dart
class Achievement {
  final int id;
  final String title;
  final String description;
  final String category;
  final String icon;
  final String color;
  final int points;
  final String level;
  final String requirements;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.points,
    required this.level,
    required this.requirements,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      points: json['points'] ?? 0,
      level: json['level'] ?? '',
      requirements: json['requirements'] ?? '',
    );
  }
}

class AchievementCategory {
  final String name;
  final String emoji;
  final String color;
  final int totalAchievements;
  final int unlockedAchievements;
  final double progressPercentage;
  final List<Achievement> achievements;

  AchievementCategory({
    required this.name,
    required this.emoji,
    required this.color,
    required this.totalAchievements,
    required this.unlockedAchievements,
    required this.progressPercentage,
    required this.achievements,
  });

  factory AchievementCategory.fromJson(Map<String, dynamic> json) {
    final achievementsJson = json['achievements'] as List? ?? [];
    return AchievementCategory(
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '',
      color: json['color'] ?? '',
      totalAchievements: json['totalAchievements'] ?? 0,
      unlockedAchievements: json['unlockedAchievements'] ?? 0,
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
      achievements: achievementsJson
          .map((achievementJson) => Achievement.fromJson(achievementJson))
          .toList(),
    );
  }
}
