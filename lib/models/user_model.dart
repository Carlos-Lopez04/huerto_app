import 'package:flutter/material.dart';
import 'package:huerto_app/models/avatar_model.dart';
import 'package:huerto_app/models/achievement_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String title; // Logro seleccionado
  final String rank;
  final String? imageUrl;
  final List<UserAchievement> achievements; // Logros desbloqueados con datos
  final DateTime createdAt;
  final DateTime updatedAt;
  final AvatarModel avatar;

  // NUEVOS CAMPOS PARA SISTEMA DE PUNTUACIÓN
  final int totalPoints;
  final int level;
  final int experiencePoints;
  final DateTime lastActivityDate;
  final int consecutiveDays;
  final Map<String, int> activityCounts;
  final List<DailyActivity> dailyActivities;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.title,
    required this.rank,
    this.imageUrl,
    required this.achievements,
    required this.createdAt,
    required this.updatedAt,
    required this.avatar,
    // NUEVOS PARÁMETROS
    this.totalPoints = 0,
    this.level = 1,
    this.experiencePoints = 0,
    required this.lastActivityDate,
    this.consecutiveDays = 1,
    this.activityCounts = const {},
    this.dailyActivities = const [],
  });

  // Constructor desde Map (para JSON o Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final achievementsList = map['achievements'] as List? ?? [];

    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      title: map['title'] ?? 'Novato Verde',
      rank: map['rank'] ?? 'Semilla',
      imageUrl: map['imageUrl'],
      achievements: achievementsList
          .map((item) =>
              UserAchievement.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'].toString())
          : DateTime.now(),
      avatar: map['avatar'] != null
          ? AvatarModel.fromMap(Map<String, dynamic>.from(map['avatar']))
          : const AvatarModel(),
      // NUEVOS CAMPOS
      totalPoints: map['totalPoints'] ?? 0,
      level: map['level'] ?? 1,
      experiencePoints: map['experiencePoints'] ?? 0,
      lastActivityDate: map['lastActivityDate'] != null
          ? DateTime.parse(map['lastActivityDate'].toString())
          : DateTime.now(),
      consecutiveDays: map['consecutiveDays'] ?? 1,
      activityCounts: Map<String, int>.from(map['activityCounts'] ?? {}),
      dailyActivities: (map['dailyActivities'] as List? ?? [])
          .map((item) => DailyActivity.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  // Constructor para crear usuario por defecto
  factory UserModel.defaultUser({
    String? id,
    String? name,
    String? email,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id ?? 'default_user_${now.millisecondsSinceEpoch}',
      name: name ?? 'Usuario',
      email: email ?? 'usuario@ejemplo.com',
      title: 'Novato Verde',
      rank: 'Semilla',
      imageUrl: null,
      achievements: UserAchievement.defaultAchievements,
      createdAt: now,
      updatedAt: now,
      avatar: const AvatarModel(),
      // NUEVOS CAMPOS CON VALORES POR DEFECTO
      totalPoints: 150,
      level: 1,
      experiencePoints: 150,
      lastActivityDate: now,
      consecutiveDays: 3,
      activityCounts: {
        'plant_seed': 2,
        'water_plant': 8,
        'daily_login': 3,
        'share_garden': 1,
      },
      dailyActivities: [
        DailyActivity(
          date: now.subtract(const Duration(days: 2)),
          activities: ['daily_login', 'water_plant'],
          totalPoints: 15,
        ),
        DailyActivity(
          date: now.subtract(const Duration(days: 1)),
          activities: ['daily_login', 'plant_seed', 'water_plant'],
          totalPoints: 40,
        ),
        DailyActivity(
          date: now,
          activities: ['daily_login'],
          totalPoints: 5,
        ),
      ],
    );
  }

  // Convertir a mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'title': title,
      'rank': rank,
      'imageUrl': imageUrl,
      'achievements': achievements.map((a) => a.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'avatar': avatar.toMap(),
      // NUEVOS CAMPOS
      'totalPoints': totalPoints,
      'level': level,
      'experiencePoints': experiencePoints,
      'lastActivityDate': lastActivityDate.toIso8601String(),
      'consecutiveDays': consecutiveDays,
      'activityCounts': activityCounts,
      'dailyActivities': dailyActivities.map((a) => a.toMap()).toList(),
    };
  }

  // Método copyWith para actualizar campos
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? title,
    String? rank,
    String? imageUrl,
    List<UserAchievement>? achievements,
    DateTime? createdAt,
    DateTime? updatedAt,
    AvatarModel? avatar,
    // NUEVOS CAMPOS
    int? totalPoints,
    int? level,
    int? experiencePoints,
    DateTime? lastActivityDate,
    int? consecutiveDays,
    Map<String, int>? activityCounts,
    List<DailyActivity>? dailyActivities,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      title: title ?? this.title,
      rank: rank ?? this.rank,
      imageUrl: imageUrl ?? this.imageUrl,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      avatar: avatar ?? this.avatar,
      // NUEVOS CAMPOS
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      activityCounts: activityCounts ?? this.activityCounts,
      dailyActivities: dailyActivities ?? this.dailyActivities,
    );
  }

  // MÉTODOS DEL SISTEMA DE PUNTUACIÓN

  // Calcular nivel basado en puntos (100 puntos por nivel)
  int get calculatedLevel {
    const int pointsPerLevel = 100;
    return (totalPoints / pointsPerLevel).floor() + 1;
  }

  // Calcular progreso hacia siguiente nivel (0.0 a 1.0)
  double get levelProgress {
    const int pointsPerLevel = 100;
    return (totalPoints % pointsPerLevel) / pointsPerLevel;
  }

  // Puntos necesarios para siguiente nivel
  int get pointsToNextLevel {
    const int pointsPerLevel = 100;
    return (calculatedLevel * pointsPerLevel) - totalPoints;
  }

  // Verificar si el usuario ha iniciado sesión hoy
  bool get hasLoggedInToday {
    final now = DateTime.now();
    return now.year == lastActivityDate.year &&
        now.month == lastActivityDate.month &&
        now.day == lastActivityDate.day;
  }

  // Obtener logros equipados
  List<UserAchievement> get equippedAchievements {
    return achievements.where((achievement) => achievement.isEquipped).toList();
  }

  // Obtener logros por categoría
  Map<String, List<UserAchievement>> get achievementsByCategory {
    final Map<String, List<UserAchievement>> categorized = {};

    for (final achievement in achievements) {
      final categoryName = achievement.category.name;
      if (!categorized.containsKey(categoryName)) {
        categorized[categoryName] = [];
      }
      categorized[categoryName]!.add(achievement);
    }

    return categorized;
  }

  // NUEVOS GETTERS PARA CONSISTENCIA

  // Obtener logros desbloqueados (completados)
  List<UserAchievement> get unlockedAchievements {
    return achievements
        .where((achievement) => achievement.isCompleted)
        .toList();
  }

  // Obtener logros en progreso
  List<UserAchievement> get inProgressAchievements {
    return achievements
        .where((achievement) => achievement.isInProgress)
        .toList();
  }

  // Obtener logros secretos
  List<UserAchievement> get secretAchievements {
    return achievements.where((achievement) => achievement.isSecret).toList();
  }

  // Contador de logros desbloqueados
  int get unlockedAchievementsCount {
    return unlockedAchievements.length;
  }

  // Contador de logros en progreso
  int get inProgressAchievementsCount {
    return inProgressAchievements.length;
  }

  // Porcentaje de completado general
  double get overallAchievementProgress {
    if (achievements.isEmpty) return 0.0;
    final completed = unlockedAchievements.length;
    return completed / achievements.length;
  }

  // Método para añadir puntos
  UserModel addPoints(int points) {
    return copyWith(
      totalPoints: totalPoints + points,
      experiencePoints: experiencePoints + points,
    );
  }

  // Método para registrar actividad
  UserModel registerActivity(String activityType, int points) {
    final newCounts = Map<String, int>.from(activityCounts);
    newCounts[activityType] = (newCounts[activityType] ?? 0) + 1;

    // Actualizar días consecutivos
    final now = DateTime.now();
    final lastDate = lastActivityDate;
    final isSameDay = now.year == lastDate.year &&
        now.month == lastDate.month &&
        now.day == lastDate.day;

    int newConsecutiveDays = consecutiveDays;
    if (!isSameDay) {
      // Verificar si fue ayer
      final yesterday = now.subtract(const Duration(days: 1));
      final wasYesterday = yesterday.year == lastDate.year &&
          yesterday.month == lastDate.month &&
          yesterday.day == lastDate.day;

      newConsecutiveDays = wasYesterday ? consecutiveDays + 1 : 1;
    }

    // Actualizar actividades diarias
    final todayActivities = List<String>.from(
      dailyActivities
          .firstWhere(
            (day) => day.isToday,
            orElse: () =>
                DailyActivity(date: now, activities: [], totalPoints: 0),
          )
          .activities,
    );

    todayActivities.add(activityType);
    final todayPoints = (dailyActivities
            .firstWhere(
              (day) => day.isToday,
              orElse: () =>
                  DailyActivity(date: now, activities: [], totalPoints: 0),
            )
            .totalPoints) +
        points;

    final newDailyActivities = List<DailyActivity>.from(dailyActivities);
    newDailyActivities.removeWhere((day) => day.isToday);
    newDailyActivities.add(DailyActivity(
      date: now,
      activities: todayActivities,
      totalPoints: todayPoints,
    ));

    return copyWith(
      totalPoints: totalPoints + points,
      activityCounts: newCounts,
      lastActivityDate: now,
      consecutiveDays: newConsecutiveDays,
      dailyActivities: newDailyActivities,
    );
  }

  // Método para añadir logro
  UserModel addAchievement(Achievement achievement) {
    final newAchievements = List<UserAchievement>.from(achievements);
    final userAchievement = UserAchievement.fromAchievement(achievement);

    if (!newAchievements.any((a) => a.id == userAchievement.id)) {
      newAchievements.add(userAchievement);
    }

    return copyWith(
      achievements: newAchievements,
      totalPoints: totalPoints + achievement.requiredPoints,
    );
  }

  // Método para equipar título
  UserModel equipTitle(String title) {
    return copyWith(title: title);
  }

  // Método para equipar logro
  UserModel equipAchievement(String achievementId) {
    final newAchievements = achievements.map((achievement) {
      if (achievement.id == achievementId) {
        return achievement.copyWith(isEquipped: true);
      }
      return achievement.copyWith(isEquipped: false);
    }).toList();

    final equipped = newAchievements.firstWhere((a) => a.id == achievementId);

    return copyWith(
      achievements: newAchievements,
      title: equipped.title,
    );
  }

  // Método para verificar si un logro está desbloqueado
  bool hasAchievement(String achievementId) {
    return achievements.any((achievement) =>
        achievement.id == achievementId && achievement.isCompleted);
  }

  // Método para obtener estadísticas
  Map<String, dynamic> get stats {
    final totalActivities =
        activityCounts.values.fold(0, (sum, count) => sum + count);

    return {
      'totalPoints': totalPoints,
      'level': calculatedLevel,
      'levelProgress': levelProgress,
      'consecutiveDays': consecutiveDays,
      'totalActivities': totalActivities,
      'achievementsCount': achievements.length,
      'unlockedAchievementsCount': unlockedAchievementsCount,
      'inProgressAchievementsCount': inProgressAchievementsCount,
      'equippedAchievements': equippedAchievements.length,
      'overallAchievementProgress': overallAchievementProgress,
      'lastActivity': lastActivityDate,
      'hasLoggedInToday': hasLoggedInToday,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, points: $totalPoints, level: $calculatedLevel, achievements: ${achievements.length})';
  }
}

// Modelo para logros desbloqueados del usuario
class UserAchievement {
  final String id;
  final String title;
  final String description;
  final DateTime unlockedAt;
  final int pointsEarned;
  final bool isEquipped;
  final AchievementCategory category;
  final String icon;
  final Color color;
  final AchievementLevel level;
  final int currentProgress;
  final int totalRequired;
  final bool isSecret;

  UserAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.unlockedAt,
    required this.pointsEarned,
    required this.isEquipped,
    required this.category,
    required this.icon,
    required this.color,
    required this.level,
    this.currentProgress = 0,
    this.totalRequired = 1,
    this.isSecret = false,
  });

  // Getters útiles
  bool get isCompleted => currentProgress >= totalRequired;
  bool get isInProgress => currentProgress > 0 && !isCompleted;
  double get progressPercentage => totalRequired > 0
      ? (currentProgress / totalRequired).clamp(0.0, 1.0)
      : 0.0;

  factory UserAchievement.fromAchievement(Achievement achievement) {
    return UserAchievement(
      id: achievement.id,
      title: achievement.title,
      description: achievement.description,
      unlockedAt: DateTime.now(),
      pointsEarned: achievement.requiredPoints,
      isEquipped: false,
      category: achievement.category,
      icon: achievement.icon,
      color: _getColor(achievement.color),
      level: achievement.level,
      currentProgress: achievement.currentProgress,
      totalRequired: achievement.totalRequired,
      isSecret: achievement.isSecret,
    );
  }

  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'].toString())
          : DateTime.now(),
      pointsEarned: map['pointsEarned'] ?? 0,
      isEquipped: map['isEquipped'] ?? false,
      category: _parseCategory(map['category'] ?? ''),
      icon: map['icon'] ?? '🏆',
      color: _getColor(map['color'] ?? 'freshMint'),
      level: _parseLevel(map['level'] ?? 'bronze'),
      currentProgress: map['currentProgress'] ?? 0,
      totalRequired: map['totalRequired'] ?? 1,
      isSecret: map['isSecret'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'unlockedAt': unlockedAt.toIso8601String(),
      'pointsEarned': pointsEarned,
      'isEquipped': isEquipped,
      'category': category.name,
      'icon': icon,
      'color': _getColorName(color),
      'level': level.name,
      'currentProgress': currentProgress,
      'totalRequired': totalRequired,
      'isSecret': isSecret,
    };
  }

  UserAchievement copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? unlockedAt,
    int? pointsEarned,
    bool? isEquipped,
    AchievementCategory? category,
    String? icon,
    Color? color,
    AchievementLevel? level,
    int? currentProgress,
    int? totalRequired,
    bool? isSecret,
  }) {
    return UserAchievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      isEquipped: isEquipped ?? this.isEquipped,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      level: level ?? this.level,
      currentProgress: currentProgress ?? this.currentProgress,
      totalRequired: totalRequired ?? this.totalRequired,
      isSecret: isSecret ?? this.isSecret,
    );
  }

  static List<UserAchievement> defaultAchievements = [
    UserAchievement(
      id: 'beginner',
      title: 'Novato Verde',
      description: 'Completa tu primera planta',
      unlockedAt: DateTime.now(),
      pointsEarned: 50,
      isEquipped: true,
      category: AchievementCategory.habitos,
      icon: '🌱',
      color: const Color(0xFF4CAF50),
      level: AchievementLevel.bronze,
      currentProgress: 1,
      totalRequired: 1,
    ),
    UserAchievement(
      id: 'first_seed',
      title: 'Primera Semilla',
      description: 'Planta tu primera semilla',
      unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
      pointsEarned: 25,
      isEquipped: false,
      category: AchievementCategory.cultivo,
      icon: '🌱',
      color: const Color(0xFF4CAF50),
      level: AchievementLevel.bronze,
      currentProgress: 1,
      totalRequired: 1,
    ),
  ];

  static Color _getColor(String colorName) {
    switch (colorName) {
      case 'freshMint':
        return const Color(0xFF4CAF50);
      case 'clearBlue':
        return const Color(0xFF2196F3);
      case 'sunflower':
        return const Color(0xFFFFC107);
      case 'goldenSun':
        return const Color(0xFFFFB300);
      case 'berryPink':
        return const Color(0xFFEC407A);
      case 'emeraldLeaf':
        return const Color(0xFF2E7D32);
      case 'forestDepth':
        return const Color(0xFF1B5E20);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  static String _getColorName(Color color) {
    if (color == const Color(0xFF4CAF50)) return 'freshMint';
    if (color == const Color(0xFF2196F3)) return 'clearBlue';
    if (color == const Color(0xFFFFC107)) return 'sunflower';
    if (color == const Color(0xFFFFB300)) return 'goldenSun';
    if (color == const Color(0xFFEC407A)) return 'berryPink';
    if (color == const Color(0xFF2E7D32)) return 'emeraldLeaf';
    if (color == const Color(0xFF1B5E20)) return 'forestDepth';
    return 'freshMint';
  }

  static AchievementCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cultivo':
        return AchievementCategory.cultivo;
      case 'hábitos':
      case 'habitos':
        return AchievementCategory.habitos;
      case 'dedicación':
      case 'dedicacion':
        return AchievementCategory.dedicacion;
      case 'habilidad':
        return AchievementCategory.habilidad;
      case 'social':
        return AchievementCategory.social;
      case 'colección':
      case 'coleccion':
        return AchievementCategory.coleccion;
      default:
        return AchievementCategory.cultivo;
    }
  }

  static AchievementLevel _parseLevel(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return AchievementLevel.bronze;
      case 'silver':
        return AchievementLevel.silver;
      case 'gold':
        return AchievementLevel.gold;
      case 'platinum':
        return AchievementLevel.platinum;
      case 'diamond':
        return AchievementLevel.diamond;
      default:
        return AchievementLevel.bronze;
    }
  }
}

// Modelo para actividades diarias
class DailyActivity {
  final DateTime date;
  final List<String> activities;
  final int totalPoints;

  DailyActivity({
    required this.date,
    required this.activities,
    required this.totalPoints,
  });

  bool get isToday {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.year == date.year &&
        yesterday.month == date.month &&
        yesterday.day == date.day;
  }

  factory DailyActivity.fromMap(Map<String, dynamic> map) {
    return DailyActivity(
      date: DateTime.parse(map['date']),
      activities: List<String>.from(map['activities'] ?? []),
      totalPoints: map['totalPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'activities': activities,
      'totalPoints': totalPoints,
    };
  }
}
