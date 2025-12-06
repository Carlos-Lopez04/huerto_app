import 'package:flutter/material.dart';

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
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      icon: (json['icon'] ?? 'help') as String,
      color: (json['color'] ?? 'stoneGray') as String,
      points: (json['points'] ?? 0) as int,
      level: (json['level'] ?? 'Semilla') as String,
      requirements: (json['requirements'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'icon': icon,
      'color': color,
      'points': points,
      'level': level,
      'requirements': requirements,
    };
  }

  // Convertir string de icono a IconData - CORREGIDO
  IconData get iconData {
    switch (icon) {
      case 'eco':
        return Icons.eco;
      case 'flag':
        return Icons.flag;
      case 'explore':
        return Icons.explore;
      case 'water_drop':
        return Icons.water_drop;
      case 'remove_red_eye':
        return Icons.remove_red_eye;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'agriculture':
        return Icons.agriculture;
      case 'menu_book':
        return Icons.menu_book;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'person':
        return Icons.person;
      case 'people':
        return Icons.people;
      case 'share':
        return Icons.share;
      case 'help':
        return Icons.help;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'thumb_up':
        return Icons.thumb_up;
      case 'park':
        return Icons.park;
      case 'grid_view':
        return Icons.grid_view;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'notifications':
        return Icons.notifications;
      case 'star':
        return Icons.star;
      case 'forest':
        return Icons.forest;
      case 'psychology':
        return Icons.psychology;
      case 'grass':
        return Icons.grass;
      case 'diversity_3':
        return Icons.diversity_3;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'trending_up':
        return Icons.trending_up;
      case 'check_circle':
        return Icons.check_circle;
      case 'lock':
        return Icons.lock;
      case 'today':
        return Icons.today;
      case 'spa':
        return Icons.spa;
      case 'yard':
        return Icons.yard;
      case 'local_florist':
        return Icons.local_florist;
      case 'forum':
        return Icons.forum;
      case 'person_add':
        return Icons.person_add;
      case 'collections':
        return Icons.collections;
      case 'science':
        return Icons.science;
      case 'article':
        return Icons.article;
      case 'healing':
        return Icons.healing;
      case 'assignment':
        return Icons.assignment;
      case 'strategy':
        return Icons.auto_awesome;
      case 'smartphone':
        return Icons.smartphone;
      case 'analytics':
        return Icons.analytics;
      case 'new_releases':
        return Icons.new_releases;
      case 'feedback':
        return Icons.feedback;
      case 'local_library':
        return Icons.local_library;
      case 'school':
        return Icons.school;
      case 'create':
        return Icons.create;
      case 'admin_panel_settings':
        return Icons.admin_panel_settings;
      case 'bug_report':
        return Icons.bug_report;
      case 'filter_vintage':
        return Icons.filter_vintage;
      case 'recycling':
        return Icons.recycling;
      case 'compost':
        return Icons.compost;
      case 'emoji_nature':
        return Icons.emoji_nature;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      case 'favorite':
        return Icons.favorite;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'color_lens':
        return Icons.color_lens;
      case 'straighten':
        return Icons.straighten;
      case 'zoom_out_map':
        return Icons.zoom_out_map;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'palette':
        return Icons.palette;
      case 'nights_stay':
        return Icons.nights_stay;
      case 'wb_twilight':
        return Icons.wb_twilight;
      case 'beach_access':
        return Icons.beach_access;
      case 'shield':
        return Icons.shield;
      case 'autorenew':
        return Icons.autorenew;
      case 'search':
        return Icons.search;
      case 'collections_bookmark':
        return Icons.collections_bookmark;
      case 'done_all':
        return Icons.done_all;
      case 'military_tech':
        return Icons.military_tech;
      case 'nature':
        return Icons.nature;
      case 'sprout':
        return Icons.spa;
      case 'water':
        return Icons.water_drop;
      case 'sunny':
        return Icons.wb_sunny;
      case 'garden':
        return Icons.yard;
      case 'plant':
        return Icons.local_florist;
      case 'seed':
        return Icons.eco;
      case 'tree':
        return Icons.park;
      case 'flower':
        return Icons.filter_vintage;
      case 'vegetable':
        return Icons.grass;
      case 'fruit':
        return Icons.local_dining;
      case 'herb':
        return Icons.spa;
      case 'compost_icon':
        return Icons.recycling;
      case 'rain':
        return Icons.beach_access;
      case 'soil':
        return Icons.landscape;
      case 'tools':
        return Icons.handyman;
      case 'harvest':
        return Icons.agriculture;
      case 'growth':
        return Icons.trending_up;
      case 'quality':
        return Icons.workspace_premium;
      case 'community':
        return Icons.people;
      case 'knowledge':
        return Icons.menu_book;
      case 'habit':
        return Icons.calendar_today;
      case 'special':
        return Icons.star;
      case 'seasonal':
        return Icons.ac_unit;
      case 'rare':
        return Icons.auto_awesome;
      case 'resistance':
        return Icons.shield;
      case 'secret':
        return Icons.lock;
      default:
        return Icons.help;
    }
  }

  // Convertir string de color a Color
  Color get colorValue {
    switch (color) {
      case 'freshMint':
        return const Color(0xFF98FB98);
      case 'clearBlue':
        return const Color(0xFF87CEEB);
      case 'goldenSun':
        return const Color(0xFFFFD700);
      case 'emeraldLeaf':
        return const Color(0xFF50C878);
      case 'stoneGray':
        return const Color(0xFF808080);
      case 'forestDepth':
        return const Color(0xFF228B22);
      case 'blancoHueso':
        return const Color(0xFFF5F5DC);
      case 'cloudWhite':
        return const Color(0xFFF8F8FF);
      case 'verdeGelido':
        return const Color(0xFFE0F8E0);
      case 'warmOrange':
        return const Color(0xFFFFA500);
      case 'violetBloom':
        return const Color(0xFFEE82EE);
      case 'earthBrown':
        return const Color(0xFF8B4513);
      case 'skyBlue':
        return const Color(0xFF87CEEB);
      case 'sunsetRed':
        return const Color(0xFFFF6347);
      case 'springGreen':
        return const Color(0xFF00FF7F);
      case 'autumnOrange':
        return const Color(0xFFFF8C00);
      case 'winterBlue':
        return const Color(0xFF4682B4);
      case 'summerYellow':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF000000);
    }
  }

  // Obtener color de fondo basado en el estado (desbloqueado/bloqueado)
  Color getBackgroundColor(bool isUnlocked) {
    if (isUnlocked) {
      return colorValue.withOpacity(0.2); // ✅ CORRECTO
    } else {
      return Colors.grey.withOpacity(0.1);
    }
  }

  // Obtener color de texto basado en el estado
  Color getTextColor(bool isUnlocked) {
    if (isUnlocked) {
      return Colors.black87;
    } else {
      return Colors.grey;
    }
  }

  // Obtener color del icono basado en el estado
  Color getIconColor(bool isUnlocked) {
    if (isUnlocked) {
      return colorValue;
    } else {
      return Colors.grey;
    }
  }

  // Obtener descripción corta (primeras palabras)
  String get shortDescription {
    final words = description.split(' ');
    return words.length > 5 ? '${words.take(5).join(' ')}...' : description;
  }

  // Verificar si es un logro especial
  bool get isSpecial {
    return category == 'Especial' ||
        category == 'Secreto' ||
        category == 'Rareza' ||
        points >= 100;
  }

  // Verificar si es un logro de temporada
  bool get isSeasonal {
    return category == 'Temporada';
  }

  // Obtener dificultad basada en puntos y nivel
  String get difficulty {
    if (points >= 200) return 'Muy Difícil';
    if (points >= 100) return 'Difícil';
    if (points >= 50) return 'Intermedio';
    if (points >= 20) return 'Fácil';
    return 'Muy Fácil';
  }

  // Obtener color de dificultad
  Color get difficultyColor {
    switch (difficulty) {
      case 'Muy Difícil':
        return Colors.red;
      case 'Difícil':
        return Colors.orange;
      case 'Intermedio':
        return Colors.yellow[700]!;
      case 'Fácil':
        return Colors.green;
      case 'Muy Fácil':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Obtener emoji representativo basado en categoría
  String get categoryEmoji {
    switch (category) {
      case 'Cultivo':
        return '🌱';
      case 'Conocimiento':
        return '📚';
      case 'Comunidad':
        return '👥';
      case 'Hábitos':
        return '⚡';
      case 'Especial':
        return '🎯';
      case 'Temporada':
        return '🎄';
      case 'Rareza':
        return '🔮';
      case 'Resistencia':
        return '🛡️';
      case 'Secreto':
        return '🗝️';
      default:
        return '🏆';
    }
  }

  // Obtener emoji de nivel
  String get levelEmoji {
    switch (level) {
      case 'Semilla':
        return '🌱';
      case 'Brote':
        return '🌿';
      case 'Árbol':
        return '🌳';
      case 'Bosque':
        return '🌲';
      case 'Especial':
        return '⭐';
      case 'Secreto':
        return '🔒';
      default:
        return '🎯';
    }
  }

  // Método para copiar el logro con nuevos valores
  Achievement copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? icon,
    String? color,
    int? points,
    String? level,
    String? requirements,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      points: points ?? this.points,
      level: level ?? this.level,
      requirements: requirements ?? this.requirements,
    );
  }

  @override
  String toString() {
    return 'Achievement{id: $id, title: $title, category: $category, points: $points, level: $level}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Método para comparar logros por puntos
  int compareByPoints(Achievement other) {
    return points.compareTo(other.points);
  }

  // Verificar si el logro es reciente
  bool get isRecent {
    return id <= 10;
  }

  // Obtener badge de rareza
  String get rarityBadge {
    if (points >= 300) return 'Legendario';
    if (points >= 200) return 'Épico';
    if (points >= 100) return 'Raro';
    if (points >= 50) return 'Poco Común';
    return 'Común';
  }

  // Color del badge de rareza
  Color get rarityColor {
    switch (rarityBadge) {
      case 'Legendario':
        return Colors.orange;
      case 'Épico':
        return Colors.purple;
      case 'Raro':
        return Colors.blue;
      case 'Poco Común':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// Clase para agrupar logros por categoría - OPCIÓN 1
class AchievementCategory {
  final String name;
  final String emoji;
  final String color;
  final int totalAchievements;
  final int unlockedAchievements;
  final double progressPercentage;
  final List<Achievement> achievements;

  const AchievementCategory({
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
    final achievements = achievementsJson
        .map((achievementJson) => Achievement.fromJson(achievementJson))
        .cast<Achievement>()
        .toList();

    return AchievementCategory(
      name: (json['name'] ?? '') as String,
      emoji: (json['emoji'] ?? '🏆') as String,
      color: (json['color'] ?? 'stoneGray') as String,
      totalAchievements: (json['totalAchievements'] ?? 0) as int,
      unlockedAchievements: (json['unlockedAchievements'] ?? 0) as int,
      progressPercentage: (json['progressPercentage'] ?? 0.0) as double,
      achievements: achievements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'color': color,
      'totalAchievements': totalAchievements,
      'unlockedAchievements': unlockedAchievements,
      'progressPercentage': progressPercentage,
      'achievements': achievements.map((a) => a.toJson()).toList(),
    };
  }

  Color get colorValue {
    switch (color) {
      case 'freshMint':
        return const Color(0xFF98FB98);
      case 'clearBlue':
        return const Color(0xFF87CEEB);
      case 'goldenSun':
        return const Color(0xFFFFD700);
      case 'emeraldLeaf':
        return const Color(0xFF50C878);
      case 'stoneGray':
        return const Color(0xFF808080);
      case 'forestDepth':
        return const Color(0xFF228B22);
      case 'blancoHueso':
        return const Color(0xFFF5F5DC);
      case 'cloudWhite':
        return const Color(0xFFF8F8FF);
      case 'verdeGelido':
        return const Color(0xFFE0F8E0);
      case 'warmOrange':
        return const Color(0xFFFFA500);
      case 'violetBloom':
        return const Color(0xFFEE82EE);
      case 'earthBrown':
        return const Color(0xFF8B4513);
      case 'skyBlue':
        return const Color(0xFF87CEEB);
      case 'sunsetRed':
        return const Color(0xFFFF6347);
      case 'springGreen':
        return const Color(0xFF00FF7F);
      case 'autumnOrange':
        return const Color(0xFFFF8C00);
      case 'winterBlue':
        return const Color(0xFF4682B4);
      case 'summerYellow':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF808080);
    }
  }
}

// Clase para estadísticas de logros
class AchievementStats {
  final int totalAchievements;
  final int unlockedAchievements;
  final int totalPoints;
  final String currentLevel;
  final Map<String, int> achievementsByCategory;
  final Map<String, int> achievementsByLevel;

  const AchievementStats({
    required this.totalAchievements,
    required this.unlockedAchievements,
    required this.totalPoints,
    required this.currentLevel,
    required this.achievementsByCategory,
    required this.achievementsByLevel,
  });

  double get progressPercentage {
    if (totalAchievements == 0) return 0.0;
    return unlockedAchievements / totalAchievements * 100;
  }

  int get lockedAchievements => totalAchievements - unlockedAchievements;

  factory AchievementStats.fromJson(Map<String, dynamic> json) {
    return AchievementStats(
      totalAchievements: (json['totalAchievements'] ?? 0) as int,
      unlockedAchievements: (json['unlockedAchievements'] ?? 0) as int,
      totalPoints: (json['totalPoints'] ?? 0) as int,
      currentLevel: (json['currentLevel'] ?? 'Semilla') as String,
      achievementsByCategory:
          Map<String, int>.from(json['achievementsByCategory'] as Map? ?? {}),
      achievementsByLevel:
          Map<String, int>.from(json['achievementsByLevel'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAchievements': totalAchievements,
      'unlockedAchievements': unlockedAchievements,
      'totalPoints': totalPoints,
      'currentLevel': currentLevel,
      'achievementsByCategory': achievementsByCategory,
      'achievementsByLevel': achievementsByLevel,
    };
  }
}
