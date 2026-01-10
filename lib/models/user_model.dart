// models/user_model.dart
import 'dart:convert';
import 'package:flutter/material.dart';

// Enumeración para género del usuario
enum UserGender {
  masculino,
  femenino,
  otro,
}

// Enumeración para rango/outfit
enum UserRank {
  semilla, // Nivel 1-5
  brote, // Nivel 6-10
  arbol, // Nivel 11-15
  bosque, // Nivel 16+
}

// Modelo principal de usuario
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserGender gender;
  final DateTime createdAt;
  final int totalPoints;
  final int level;
  final Map<String, dynamic>? preferences;
  final List<String> completedActivityIds;
  final List<String> favoriteActivityIds;

  // NUEVAS PROPIEDADES PARA EL SISTEMA DE LOGROS
  final List<String> completedAchievementIds;
  final Map<String, int> activityCounts;
  final int consecutiveDays;
  final DateTime? lastActivityDate;
  final String? selectedTitle; // Título equipado

  // Propiedades de avatar
  final Color skinColor;
  final Color hairColor;
  final Color eyeColor;
  final bool hasGlasses;
  final String? accessory;
  final String avatarStyle; // 'simple', 'detailed', o 'custom'

  // Colores por defecto para comparación
  static const Color defaultSkinColor = Color(0xFFF7D7B2);
  static const Color defaultHairColor = Color(0xFF4A3128);
  static const Color defaultEyeColor = Color(0xFF2E7D32);
  static const bool defaultHasGlasses = false;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.createdAt,
    this.totalPoints = 0,
    this.level = 1,
    this.preferences,
    this.completedActivityIds = const [],
    this.favoriteActivityIds = const [],

    // Nuevas propiedades con valores por defecto
    this.completedAchievementIds = const [],
    this.activityCounts = const {},
    this.consecutiveDays = 0,
    this.lastActivityDate,
    this.selectedTitle,

    // Propiedades de avatar con valores por defecto
    this.skinColor = defaultSkinColor,
    this.hairColor = defaultHairColor,
    this.eyeColor = defaultEyeColor,
    this.hasGlasses = defaultHasGlasses,
    this.accessory,
    this.avatarStyle = 'simple',
  });

  // Factory para crear usuario por defecto
  factory UserModel.defaultUser({
    String? name,
    String? email,
    UserGender gender = UserGender.femenino,
  }) {
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Usuario Huerto',
      email: email ?? 'usuario@huerto.com',
      gender: gender,
      createdAt: DateTime.now(),
      totalPoints: 100,
      level: 2,
      preferences: {
        'notifications': true,
        'darkMode': false,
        'language': 'es',
        'avatarStyle': 'simple',
      },
      // Datos de ejemplo para pruebas
      completedActivityIds: ['plant_seed', 'daily_login'],
      completedAchievementIds: ['first_seed', 'daily_streak_3'],
      activityCounts: {
        'plant_seed': 3,
        'daily_login': 5,
      },
      consecutiveDays: 3,
      lastActivityDate: DateTime.now(),
      selectedTitle: 'Primera Semilla',
    );
  }

  // Getters para verificar personalización
  bool get hasCustomSkinColor => skinColor != defaultSkinColor;
  bool get hasCustomHairColor => hairColor != defaultHairColor;
  bool get hasCustomEyeColor => eyeColor != defaultEyeColor;
  bool get hasCustomGlasses => hasGlasses != defaultHasGlasses;
  bool get hasAccessory => accessory != null && accessory!.isNotEmpty;

  // Getter para opacidades de overlay (valores sutiles)
  double get skinColorOpacity => hasCustomSkinColor ? 0.15 : 0.0;
  double get hairColorOpacity => hasCustomHairColor ? 0.25 : 0.0;
  double get eyeColorOpacity => hasCustomEyeColor ? 0.4 : 0.0;

  // Colores de overlay ya con opacidad
  Color get skinOverlayColor => skinColor.withOpacity(skinColorOpacity);
  Color get hairOverlayColor => hairColor.withOpacity(hairColorOpacity);
  Color get eyeOverlayColor => eyeColor.withOpacity(eyeColorOpacity);

  // Getter para rango basado en nivel
  UserRank get rank {
    if (level <= 5) return UserRank.semilla;
    if (level <= 10) return UserRank.brote;
    if (level <= 15) return UserRank.arbol;
    return UserRank.bosque;
  }

  // Getter para título equipado o rango por defecto
  String get title => selectedTitle ?? displayRank;

  // Getter para nombre del rango
  String get displayRank {
    switch (rank) {
      case UserRank.semilla:
        return 'Semilla';
      case UserRank.brote:
        return 'Brote';
      case UserRank.arbol:
        return 'Árbol';
      case UserRank.bosque:
        return 'Bosque';
    }
  }

  // Getter para nombre de género
  String get displayGender {
    switch (gender) {
      case UserGender.masculino:
        return 'Masculino';
      case UserGender.femenino:
        return 'Femenino';
      case UserGender.otro:
        return 'Otro';
    }
  }

  // Getter para ruta del avatar basado en género y estilo
  String get avatarImagePath {
    if (avatarStyle == 'custom') {
      // Si usa avatar personalizado, no necesita imagen
      return '';
    } else if (avatarStyle == 'detailed') {
      // Si usa avatar detallado con capas
      return 'assets/avatars/bases/base_${gender == UserGender.femenino ? 'female' : 'male'}.png';
    } else {
      // Avatar simple por género (estilo 'simple')
      return gender == UserGender.femenino
          ? 'lib/images/avatar_femenino.png'
          : 'lib/images/avatar_masculino.png';
    }
  }

  // Getter para verificar si usa avatar personalizado
  bool get usesCustomAvatar => avatarStyle == 'custom';

  // Getter para verificar si el avatar está personalizado
  bool get isAvatarCustomized {
    return hasCustomSkinColor ||
        hasCustomHairColor ||
        hasCustomEyeColor ||
        hasCustomGlasses ||
        hasAccessory ||
        usesCustomAvatar;
  }

  // Getter para datos del avatar
  Map<String, dynamic> get avatarData => {
        'skinColor': skinColor,
        'hairColor': hairColor,
        'eyeColor': eyeColor,
        'hasGlasses': hasGlasses,
        'hasCustomSkinColor': hasCustomSkinColor,
        'hasCustomHairColor': hasCustomHairColor,
        'hasCustomEyeColor': hasCustomEyeColor,
        'skinOverlayColor': skinOverlayColor.value,
        'hairOverlayColor': hairOverlayColor.value,
        'eyeOverlayColor': eyeOverlayColor.value,
        'skinOpacity': skinColorOpacity,
        'hairOpacity': hairColorOpacity,
        'eyeOpacity': eyeColorOpacity,
        'outfit': displayRank,
        'accessory': accessory,
        'gender': gender,
        'usesCustomAvatar': usesCustomAvatar,
        'isAvatarCustomized': isAvatarCustomized,
      };

  // Calcular nivel basado en puntos
  static int calculateLevel(int points) {
    // Cada 100 puntos sube un nivel
    return (points / 100).floor() + 1;
  }

  // Obtener progreso hacia el siguiente nivel
  double get levelProgress {
    final pointsForCurrentLevel = (level - 1) * 100;
    final pointsForNextLevel = level * 100;
    final pointsInLevel = totalPoints - pointsForCurrentLevel;
    final pointsNeeded = pointsForNextLevel - pointsForCurrentLevel;

    return pointsInLevel / pointsNeeded;
  }

  // Puntos necesarios para el siguiente nivel
  int get pointsToNextLevel {
    final pointsForNextLevel = level * 100;
    return pointsForNextLevel - totalPoints;
  }

  // Contar logros desbloqueados
  int get unlockedAchievementsCount => completedAchievementIds.length;

  // Calcular actividades totales
  int get totalActivitiesCompleted {
    return activityCounts.values.fold(0, (sum, count) => sum + count);
  }

  // Factory para crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parsear activityCounts
    final Map<String, int> parsedActivityCounts = {};
    if (json['activityCounts'] != null) {
      final Map<String, dynamic> activityMap =
          Map<String, dynamic>.from(json['activityCounts']);
      activityMap.forEach((key, value) {
        parsedActivityCounts[key] =
            value is int ? value : int.tryParse(value.toString()) ?? 0;
      });
    }

    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: _parseGender(json['gender'] ?? 'femenino'),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? 1,
      preferences: json['preferences'] != null
          ? Map<String, dynamic>.from(json['preferences'])
          : null,
      completedActivityIds:
          List<String>.from(json['completedActivityIds'] ?? []),
      favoriteActivityIds: List<String>.from(json['favoriteActivityIds'] ?? []),

      // Nuevas propiedades
      completedAchievementIds:
          List<String>.from(json['completedAchievementIds'] ?? []),
      activityCounts: parsedActivityCounts,
      consecutiveDays: json['consecutiveDays'] ?? 0,
      lastActivityDate: json['lastActivityDate'] != null
          ? DateTime.parse(json['lastActivityDate'])
          : null,
      selectedTitle: json['selectedTitle'],

      skinColor: _parseColor(json['skinColor'] ?? '0xFFF7D7B2'),
      hairColor: _parseColor(json['hairColor'] ?? '0xFF4A3128'),
      eyeColor: _parseColor(json['eyeColor'] ?? '0xFF2E7D32'),
      hasGlasses: json['hasGlasses'] ?? false,
      accessory: json['accessory'],
      avatarStyle: json['avatarStyle'] ?? 'simple',
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': _getGenderString(gender),
      'createdAt': createdAt.toIso8601String(),
      'totalPoints': totalPoints,
      'level': level,
      'preferences': preferences,
      'completedActivityIds': completedActivityIds,
      'favoriteActivityIds': favoriteActivityIds,

      // Nuevas propiedades
      'completedAchievementIds': completedAchievementIds,
      'activityCounts': activityCounts,
      'consecutiveDays': consecutiveDays,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'selectedTitle': selectedTitle,

      'skinColor': _getColorString(skinColor),
      'hairColor': _getColorString(hairColor),
      'eyeColor': _getColorString(eyeColor),
      'hasGlasses': hasGlasses,
      'accessory': accessory,
      'avatarStyle': avatarStyle,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserGender? gender,
    DateTime? createdAt,
    int? totalPoints,
    int? level,
    Map<String, dynamic>? preferences,
    List<String>? completedActivityIds,
    List<String>? favoriteActivityIds,

    // Nuevas propiedades
    List<String>? completedAchievementIds,
    Map<String, int>? activityCounts,
    int? consecutiveDays,
    DateTime? lastActivityDate,
    String? selectedTitle,
    Color? skinColor,
    Color? hairColor,
    Color? eyeColor,
    bool? hasGlasses,
    String? accessory,
    String? avatarStyle,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      preferences: preferences ?? this.preferences,
      completedActivityIds: completedActivityIds ?? this.completedActivityIds,
      favoriteActivityIds: favoriteActivityIds ?? this.favoriteActivityIds,

      // Nuevas propiedades
      completedAchievementIds:
          completedAchievementIds ?? this.completedAchievementIds,
      activityCounts: activityCounts ?? this.activityCounts,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      selectedTitle: selectedTitle ?? this.selectedTitle,

      skinColor: skinColor ?? this.skinColor,
      hairColor: hairColor ?? this.hairColor,
      eyeColor: eyeColor ?? this.eyeColor,
      hasGlasses: hasGlasses ?? this.hasGlasses,
      accessory: accessory ?? this.accessory,
      avatarStyle: avatarStyle ?? this.avatarStyle,
    );
  }

  // Métodos de parsing
  static UserGender _parseGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'masculino':
      case 'male':
        return UserGender.masculino;
      case 'femenino':
      case 'female':
        return UserGender.femenino;
      case 'otro':
      case 'other':
        return UserGender.otro;
      default:
        return UserGender.femenino;
    }
  }

  static String _getGenderString(UserGender gender) {
    switch (gender) {
      case UserGender.masculino:
        return 'masculino';
      case UserGender.femenino:
        return 'femenino';
      case UserGender.otro:
        return 'otro';
    }
  }

  static Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('0x') || colorString.startsWith('#')) {
        // Extraer solo el valor hexadecimal
        String hex = colorString.replaceFirst('#', '').replaceFirst('0x', '');
        // Si es de 6 caracteres, agregar opacidad FF al inicio
        if (hex.length == 6) {
          hex = 'FF$hex';
        }
        // Si es de 8 caracteres, está bien
        if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      }
      return defaultSkinColor; // Valor por defecto
    } catch (e) {
      print('Error parsing color $colorString: $e');
      return defaultSkinColor;
    }
  }

  static String _getColorString(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  // Métodos de utilidad
  UserModel addPoints(int points) {
    final newTotalPoints = totalPoints + points;
    final newLevel = calculateLevel(newTotalPoints);

    return copyWith(
      totalPoints: newTotalPoints,
      level: newLevel,
    );
  }

  UserModel completeActivity(String activityId) {
    final newCompletedIds = List<String>.from(completedActivityIds);
    if (!newCompletedIds.contains(activityId)) {
      newCompletedIds.add(activityId);
    }

    return copyWith(
      completedActivityIds: newCompletedIds,
    );
  }

  UserModel toggleFavorite(String activityId) {
    final newFavoriteIds = List<String>.from(favoriteActivityIds);
    if (newFavoriteIds.contains(activityId)) {
      newFavoriteIds.remove(activityId);
    } else {
      newFavoriteIds.add(activityId);
    }

    return copyWith(
      favoriteActivityIds: newFavoriteIds,
    );
  }

  // Método para cambiar estilo de avatar
  UserModel changeAvatarStyle(String newStyle) {
    return copyWith(
      avatarStyle: newStyle,
    );
  }

  // Método para personalizar avatar
  UserModel customizeAvatar({
    Color? skinColor,
    Color? hairColor,
    Color? eyeColor,
    bool? hasGlasses,
    String? accessory,
  }) {
    return copyWith(
      skinColor: skinColor,
      hairColor: hairColor,
      eyeColor: eyeColor,
      hasGlasses: hasGlasses,
      accessory: accessory,
      avatarStyle: 'custom', // Siempre cambiar a custom cuando se personaliza
    );
  }

  // Método para actualizar género
  UserModel updateGender(UserGender newGender) {
    return copyWith(
      gender: newGender,
    );
  }

  // Método para actualizar contadores de actividades
  UserModel updateActivityCount(String activityId, int increment) {
    final updatedCounts = Map<String, int>.from(activityCounts);
    updatedCounts[activityId] = (updatedCounts[activityId] ?? 0) + increment;

    // Actualizar fecha de última actividad y verificar días consecutivos
    final now = DateTime.now();
    final updatedLastActivityDate = now;

    int updatedConsecutiveDays = consecutiveDays;
    if (lastActivityDate != null) {
      final daysDifference = now.difference(lastActivityDate!).inDays;
      if (daysDifference == 1) {
        updatedConsecutiveDays = consecutiveDays + 1;
      } else if (daysDifference > 1) {
        updatedConsecutiveDays = 1; // Rompió la racha
      }
    } else {
      updatedConsecutiveDays = 1;
    }

    return copyWith(
      activityCounts: updatedCounts,
      lastActivityDate: updatedLastActivityDate,
      consecutiveDays: updatedConsecutiveDays,
    );
  }

  // Método para agregar logro completado
  UserModel addAchievement(String achievementId) {
    final newCompletedAchievements = List<String>.from(completedAchievementIds);
    if (!newCompletedAchievements.contains(achievementId)) {
      newCompletedAchievements.add(achievementId);
    }

    return copyWith(
      completedAchievementIds: newCompletedAchievements,
    );
  }

  // Método para equipar título
  UserModel equipTitle(String title) {
    return copyWith(
      selectedTitle: title,
    );
  }

  // Verificar si tiene un logro
  bool hasAchievement(String achievementId) {
    return completedAchievementIds.contains(achievementId);
  }

  // Obtener conteo de actividad específica
  int getActivityCount(String activityId) {
    return activityCounts[activityId] ?? 0;
  }

  // Método para obtener descripción del avatar
  String get avatarDescription {
    final genderText = gender == UserGender.femenino ? 'Femenino' : 'Masculino';
    final glassesText = hasGlasses ? 'con lentes' : 'sin lentes';
    final accessoryText = hasAccessory ? 'con $accessory' : '';
    final skinText = hasCustomSkinColor ? 'tono personalizado' : '';
    final hairText = hasCustomHairColor ? 'cabello personalizado' : '';
    final eyeText = hasCustomEyeColor ? 'ojos personalizados' : '';

    return 'Avatar $genderText $glassesText $accessoryText $skinText $hairText $eyeText';
  }

  // Método para restablecer avatar a valores por defecto
  UserModel resetAvatar() {
    return copyWith(
      skinColor: defaultSkinColor,
      hairColor: defaultHairColor,
      eyeColor: defaultEyeColor,
      hasGlasses: defaultHasGlasses,
      accessory: null,
      avatarStyle: 'simple',
    );
  }

  // Método para obtener información de colores del avatar
  Map<String, String> get avatarColorInfo {
    return {
      'skin': _getColorName(skinColor),
      'hair': _getColorName(hairColor),
      'eyes': _getColorName(eyeColor),
    };
  }

  // Método para obtener resumen de personalización
  Map<String, dynamic> get avatarCustomizationSummary {
    return {
      'isCustomized': isAvatarCustomized,
      'skin': {
        'color': skinColor.value,
        'isCustom': hasCustomSkinColor,
        'name': _getColorName(skinColor),
      },
      'hair': {
        'color': hairColor.value,
        'isCustom': hasCustomHairColor,
        'name': _getColorName(hairColor),
      },
      'eyes': {
        'color': eyeColor.value,
        'isCustom': hasCustomEyeColor,
        'name': _getColorName(eyeColor),
      },
      'glasses': {
        'hasGlasses': hasGlasses,
        'isCustom': hasCustomGlasses,
      },
      'accessory': accessory,
      'style': avatarStyle,
    };
  }

  // Método auxiliar para obtener nombre del color
  String _getColorName(Color color) {
    if (color == defaultSkinColor) return 'Piel Claro';
    if (color == defaultHairColor) return 'Castaño Oscuro';
    if (color == defaultEyeColor) return 'Verde';
    if (color == Colors.black) return 'Negro';
    if (color == Colors.brown) return 'Marrón';
    if (color == Colors.blue) return 'Azul';
    if (color == Colors.green) return 'Verde';
    if (color == Colors.grey) return 'Gris';
    if (color == const Color(0xFFFFDBAC)) return 'Claro';
    if (color == const Color(0xFFD8A871)) return 'Medio';
    if (color == const Color(0xFFA1663C)) return 'Oscuro';
    if (color == const Color(0xFF8D5524)) return 'Muy Oscuro';
    if (color == const Color(0xFF8B4513)) return 'Castaño';
    if (color == const Color(0xFFD2691E)) return 'Castaño Claro';
    if (color == const Color(0xFFCD853F)) return 'Rubio Oscuro';
    if (color == const Color(0xFFDAA520)) return 'Rubio';
    if (color == const Color(0xFFB8860B)) return 'Cobrizo';
    return 'Personalizado';
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, level: $level, points: $totalPoints, avatarStyle: $avatarStyle, isCustomized: $isAvatarCustomized)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
