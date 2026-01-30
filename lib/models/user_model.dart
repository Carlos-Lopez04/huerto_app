// models/user_model.dart
import 'package:flutter/material.dart'; // Importar framework Flutter

// Enumeración para género del usuario
enum UserGender {
  masculino, // Género masculino
  femenino, // Género femenino
  otro, // Otro género
}

// Enumeración para rango/outfit del usuario
enum UserRank {
  semilla, // Nivel 1-5
  brote, // Nivel 6-10
  arbol, // Nivel 11-15
  bosque, // Nivel 16+
}

/*
    Modelo principal de usuario
*/
class UserModel {
  final String id; // ID único del usuario
  final String name; // Nombre del usuario
  final String email; // Email del usuario
  final UserGender gender; // Género del usuario
  final DateTime createdAt; // Fecha de creación del usuario
  final int totalPoints; // Puntos totales acumulados
  final int level; // Nivel actual del usuario
  final Map<String, dynamic>?
      preferences; // Preferencias del usuario (opcional)
  final List<String> completedActivityIds; // IDs de actividades completadas
  final List<String> favoriteActivityIds; // IDs de actividades favoritas

  // NUEVAS PROPIEDADES PARA EL SISTEMA DE LOGROS
  final List<String> completedAchievementIds; // IDs de logros completados
  final Map<String, int> activityCounts; // Conteo de actividades realizadas
  final int consecutiveDays; // Días consecutivos de actividad
  final DateTime? lastActivityDate; // Fecha de última actividad (opcional)
  final String? selectedTitle; // Título equipado (opcional)

  // Propiedades de avatar
  final Color skinColor; // Color de piel del avatar
  final Color hairColor; // Color de cabello del avatar
  final Color eyeColor; // Color de ojos del avatar
  final bool hasGlasses; // Si el avatar usa lentes
  final String? accessory; // Accesorio del avatar (opcional)
  final String
      avatarStyle; // Estilo del avatar: 'simple', 'detailed', o 'custom'

  // Colores por defecto para comparación
  static const Color defaultSkinColor =
      Color(0xFFF7D7B2); // Color de piel por defecto
  static const Color defaultHairColor =
      Color(0xFF4A3128); // Color de cabello por defecto
  static const Color defaultEyeColor =
      Color(0xFF2E7D32); // Color de ojos por defecto
  static const bool defaultHasGlasses = false; // Valor por defecto para lentes

  // Constructor de UserModel
  const UserModel({
    required this.id, // Requerido: ID
    required this.name, // Requerido: nombre
    required this.email, // Requerido: email
    required this.gender, // Requerido: género
    required this.createdAt, // Requerido: fecha de creación
    this.totalPoints = 0, // Opcional: puntos totales (0 por defecto)
    this.level = 1, // Opcional: nivel (1 por defecto)
    this.preferences, // Opcional: preferencias
    this.completedActivityIds =
        const [], // Opcional: IDs de actividades completadas (lista vacía)
    this.favoriteActivityIds =
        const [], // Opcional: IDs de actividades favoritas (lista vacía)

    // Nuevas propiedades con valores por defecto
    this.completedAchievementIds =
        const [], // Opcional: IDs de logros completados (lista vacía)
    this.activityCounts =
        const {}, // Opcional: conteo de actividades (mapa vacío)
    this.consecutiveDays = 0, // Opcional: días consecutivos (0 por defecto)
    this.lastActivityDate, // Opcional: fecha de última actividad
    this.selectedTitle, // Opcional: título equipado

    // Propiedades de avatar con valores por defecto
    this.skinColor = defaultSkinColor, // Opcional: color de piel (por defecto)
    this.hairColor =
        defaultHairColor, // Opcional: color de cabello (por defecto)
    this.eyeColor = defaultEyeColor, // Opcional: color de ojos (por defecto)
    this.hasGlasses = defaultHasGlasses, // Opcional: lentes (false por defecto)
    this.accessory, // Opcional: accesorio
    this.avatarStyle =
        'simple', // Opcional: estilo de avatar ('simple' por defecto)
  });

  /*
    Constructor factory para crear usuario por defecto
  */
  factory UserModel.defaultUser({
    String? name, // Nombre opcional
    String? email, // Email opcional
    UserGender gender = UserGender.femenino, // Género (femenino por defecto)
  }) {
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}', // ID único basado en timestamp
      name: name ?? 'Usuario Huerto', // Nombre o 'Usuario Huerto' por defecto
      email: email ??
          'usuario@huerto.com', // Email o 'usuario@huerto.com' por defecto
      gender: gender, // Género proporcionado
      createdAt: DateTime.now(), // Fecha actual
      totalPoints: 100, // 100 puntos por defecto
      level: 2, // Nivel 2 por defecto
      preferences: {
        // Preferencias por defecto
        'notifications': true, // Notificaciones activadas
        'darkMode': false, // Modo oscuro desactivado
        'language': 'es', // Idioma español
        'avatarStyle': 'simple', // Estilo de avatar simple
      },
      // Datos de ejemplo para pruebas
      completedActivityIds: [
        'plant_seed',
        'daily_login'
      ], // Actividades completadas de ejemplo
      completedAchievementIds: [
        'first_seed',
        'daily_streak_3'
      ], // Logros completados de ejemplo
      activityCounts: {
        // Conteos de ejemplo
        'plant_seed': 3,
        'daily_login': 5,
      },
      consecutiveDays: 3, // 3 días consecutivos de ejemplo
      lastActivityDate: DateTime.now(), // Última actividad ahora
      selectedTitle: 'Primera Semilla', // Título de ejemplo
    );
  }

  /*
    Verifica si el color de piel es personalizado
  */
  bool get hasCustomSkinColor =>
      skinColor != defaultSkinColor; // Compara con valor por defecto

  /*
    Verifica si el color de cabello es personalizado
  */
  bool get hasCustomHairColor =>
      hairColor != defaultHairColor; // Compara con valor por defecto

  /*
    Verifica si el color de ojos es personalizado
  */
  bool get hasCustomEyeColor =>
      eyeColor != defaultEyeColor; // Compara con valor por defecto

  /*
    Verifica si los lentes son personalizados
  */
  bool get hasCustomGlasses =>
      hasGlasses != defaultHasGlasses; // Compara con valor por defecto

  /*
    Verifica si tiene accesorio
  */
  bool get hasAccessory =>
      accessory != null && accessory!.isNotEmpty; // No nulo y no vacío

  /*
    Obtiene opacidad para overlay de color de piel
  */
  double get skinColorOpacity =>
      hasCustomSkinColor ? 0.15 : 0.0; // 15% de opacidad si es personalizado

  /*
    Obtiene opacidad para overlay de color de cabello
  */
  double get hairColorOpacity =>
      hasCustomHairColor ? 0.25 : 0.0; // 25% de opacidad si es personalizado

  /*
    Obtiene opacidad para overlay de color de ojos
  */
  double get eyeColorOpacity =>
      hasCustomEyeColor ? 0.4 : 0.0; // 40% de opacidad si es personalizado

  /*
    Obtiene color de overlay para piel (con opacidad aplicada)
  */
  Color get skinOverlayColor => skinColor.withOpacity(skinColorOpacity);

  /*
    Obtiene color de overlay para cabello (con opacidad aplicada)
  */
  Color get hairOverlayColor => hairColor.withOpacity(hairColorOpacity);

  /*
    Obtiene color de overlay para ojos (con opacidad aplicada)
  */
  Color get eyeOverlayColor => eyeColor.withOpacity(eyeColorOpacity);

  /*
    Determina el rango del usuario basado en su nivel
  */
  UserRank get rank {
    if (level <= 5) return UserRank.semilla; // Niveles 1-5: semilla
    if (level <= 10) return UserRank.brote; // Niveles 6-10: brote
    if (level <= 15) return UserRank.arbol; // Niveles 11-15: árbol
    return UserRank.bosque; // Nivel 16+: bosque
  }

  /*
    Obtiene el título equipado o el rango por defecto
  */
  String get title =>
      selectedTitle ?? displayRank; // Título personalizado o nombre del rango

  /*
    Obtiene el nombre del rango en español
  */
  String get displayRank {
    switch (rank) {
      case UserRank.semilla:
        return 'Semilla'; // Nombre en español
      case UserRank.brote:
        return 'Brote'; // Nombre en español
      case UserRank.arbol:
        return 'Árbol'; // Nombre en español
      case UserRank.bosque:
        return 'Bosque'; // Nombre en español
    }
  }

  /*
    Obtiene el nombre del género en español
  */
  String get displayGender {
    switch (gender) {
      case UserGender.masculino:
        return 'Masculino'; // Nombre en español
      case UserGender.femenino:
        return 'Femenino'; // Nombre en español
      case UserGender.otro:
        return 'Otro'; // Nombre en español
    }
  }

  /*
    Obtiene la ruta de la imagen del avatar basado en género y estilo
  */
  String get avatarImagePath {
    if (avatarStyle == 'custom') {
      // Si usa avatar personalizado, no necesita imagen base
      return '';
    } else if (avatarStyle == 'detailed') {
      // Si usa avatar detallado con capas
      return 'assets/avatars/bases/base_${gender == UserGender.femenino ? 'female' : 'male'}.png'; // Ruta según género
    } else {
      // Avatar simple por género (estilo 'simple')
      return gender == UserGender.femenino
          ? 'lib/images/avatar_femenino.png' // Avatar femenino simple
          : 'lib/images/avatar_masculino.png'; // Avatar masculino simple
    }
  }

  /*
    Verifica si usa avatar personalizado
  */
  bool get usesCustomAvatar =>
      avatarStyle == 'custom'; // True si estilo es 'custom'

  /*
    Verifica si el avatar está personalizado (cualquier atributo personalizado)
  */
  bool get isAvatarCustomized {
    return hasCustomSkinColor || // Color de piel personalizado
        hasCustomHairColor || // Color de cabello personalizado
        hasCustomEyeColor || // Color de ojos personalizado
        hasCustomGlasses || // Lentes personalizados
        hasAccessory || // Tiene accesorio
        usesCustomAvatar; // Usa avatar personalizado
  }

  /*
    Obtiene mapa con datos del avatar
  */
  Map<String, dynamic> get avatarData => {
        'skinColor': skinColor, // Color de piel
        'hairColor': hairColor, // Color de cabello
        'eyeColor': eyeColor, // Color de ojos
        'hasGlasses': hasGlasses, // Si tiene lentes
        'hasCustomSkinColor': hasCustomSkinColor, // Si piel es personalizada
        'hasCustomHairColor': hasCustomHairColor, // Si cabello es personalizado
        'hasCustomEyeColor': hasCustomEyeColor, // Si ojos son personalizados
        'skinOverlayColor':
            skinOverlayColor.value, // Valor hex de overlay de piel
        'hairOverlayColor':
            hairOverlayColor.value, // Valor hex de overlay de cabello
        'eyeOverlayColor':
            eyeOverlayColor.value, // Valor hex de overlay de ojos
        'skinOpacity': skinColorOpacity, // Opacidad de piel
        'hairOpacity': hairColorOpacity, // Opacidad de cabello
        'eyeOpacity': eyeColorOpacity, // Opacidad de ojos
        'outfit': displayRank, // Rango como outfit
        'accessory': accessory, // Accesorio
        'gender': gender, // Género
        'usesCustomAvatar': usesCustomAvatar, // Si usa avatar personalizado
        'isAvatarCustomized': isAvatarCustomized, // Si está personalizado
      };

  /*
    Calcula nivel basado en puntos (100 puntos por nivel)
  */
  static int calculateLevel(int points) {
    return (points / 100).floor() +
        1; // Divide puntos entre 100, redondea hacia abajo y suma 1
  }

  /*
    Obtiene progreso hacia el siguiente nivel (0.0 a 1.0)
  */
  double get levelProgress {
    final pointsForCurrentLevel =
        (level - 1) * 100; // Puntos necesarios para alcanzar nivel actual
    final pointsForNextLevel =
        level * 100; // Puntos necesarios para el siguiente nivel
    final pointsInLevel =
        totalPoints - pointsForCurrentLevel; // Puntos en el nivel actual
    final pointsNeeded = pointsForNextLevel -
        pointsForCurrentLevel; // Puntos necesarios para subir

    return pointsInLevel / pointsNeeded; // Proporción de progreso
  }

  /*
    Puntos necesarios para alcanzar el siguiente nivel
  */
  int get pointsToNextLevel {
    final pointsForNextLevel = level * 100; // Puntos del siguiente nivel
    return pointsForNextLevel - totalPoints; // Diferencia
  }

  /*
    Cuenta logros desbloqueados
  */
  int get unlockedAchievementsCount =>
      completedAchievementIds.length; // Longitud de la lista

  /*
    Calcula actividades totales completadas
  */
  int get totalActivitiesCompleted {
    return activityCounts.values.fold(
        0, (sum, count) => sum + count); // Suma todos los valores del mapa
  }

  /*
    Constructor factory para crear UserModel desde JSON
  */
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parsear activityCounts
    final Map<String, int> parsedActivityCounts =
        {}; // Mapa para conteos de actividades
    if (json['activityCounts'] != null) {
      final Map<String, dynamic> activityMap =
          Map<String, dynamic>.from(json['activityCounts']); // Convierte a mapa
      activityMap.forEach((key, value) {
        parsedActivityCounts[key] = value is int
            ? value
            : int.tryParse(value.toString()) ?? 0; // Convierte a int o usa 0
      });
    }

    return UserModel(
      id: json['id'] ?? '', // ID o string vacío
      name: json['name'] ?? '', // Nombre o string vacío
      email: json['email'] ?? '', // Email o string vacío
      gender: _parseGender(json['gender'] ?? 'femenino'), // Parsea género
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']) // Parsea fecha
          : DateTime.now(), // O fecha actual
      totalPoints: json['totalPoints'] ?? 0, // Puntos o 0
      level: json['level'] ?? 1, // Nivel o 1
      preferences: json['preferences'] != null
          ? Map<String, dynamic>.from(
              json['preferences']) // Convierte preferencias
          : null, // O null
      completedActivityIds: List<String>.from(
          json['completedActivityIds'] ?? []), // Lista de IDs completados
      favoriteActivityIds: List<String>.from(
          json['favoriteActivityIds'] ?? []), // Lista de favoritos

      // Nuevas propiedades
      completedAchievementIds: List<String>.from(
          json['completedAchievementIds'] ?? []), // Lista de logros completados
      activityCounts: parsedActivityCounts, // Mapa de conteos parseado
      consecutiveDays: json['consecutiveDays'] ?? 0, // Días consecutivos o 0
      lastActivityDate: json['lastActivityDate'] != null
          ? DateTime.parse(
              json['lastActivityDate']) // Parsea fecha de última actividad
          : null, // O null
      selectedTitle: json['selectedTitle'], // Título equipado (puede ser null)

      skinColor: _parseColor(
          json['skinColor'] ?? '0xFFF7D7B2'), // Parsea color de piel
      hairColor: _parseColor(
          json['hairColor'] ?? '0xFF4A3128'), // Parsea color de cabello
      eyeColor:
          _parseColor(json['eyeColor'] ?? '0xFF2E7D32'), // Parsea color de ojos
      hasGlasses: json['hasGlasses'] ?? false, // Lentes o false
      accessory: json['accessory'], // Accesorio (puede ser null)
      avatarStyle:
          json['avatarStyle'] ?? 'simple', // Estilo de avatar o 'simple'
    );
  }

  /*
    Convierte UserModel a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': _getGenderString(gender), // Convierte género a string
      'createdAt': createdAt.toIso8601String(), // Convierte fecha a string ISO
      'totalPoints': totalPoints,
      'level': level,
      'preferences': preferences,
      'completedActivityIds': completedActivityIds,
      'favoriteActivityIds': favoriteActivityIds,

      // Nuevas propiedades
      'completedAchievementIds': completedAchievementIds,
      'activityCounts': activityCounts,
      'consecutiveDays': consecutiveDays,
      'lastActivityDate':
          lastActivityDate?.toIso8601String(), // Fecha a string ISO
      'selectedTitle': selectedTitle,

      'skinColor': _getColorString(skinColor), // Convierte color a string
      'hairColor': _getColorString(hairColor), // Convierte color a string
      'eyeColor': _getColorString(eyeColor), // Convierte color a string
      'hasGlasses': hasGlasses,
      'accessory': accessory,
      'avatarStyle': avatarStyle,
    };
  }

  /*
    Crea una copia del UserModel con algunos valores actualizados
  */
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
      id: id ?? this.id, // Usa nuevo valor o el actual
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

  /*
    Métodos de parsing estáticos
  */

  // Convierte string a UserGender
  static UserGender _parseGender(String gender) {
    switch (gender.toLowerCase()) {
      // Convierte a minúsculas
      case 'masculino':
      case 'male':
        return UserGender.masculino; // Género masculino
      case 'femenino':
      case 'female':
        return UserGender.femenino; // Género femenino
      case 'otro':
      case 'other':
        return UserGender.otro; // Otro género
      default:
        return UserGender.femenino; // Por defecto femenino
    }
  }

  // Convierte UserGender a string
  static String _getGenderString(UserGender gender) {
    switch (gender) {
      case UserGender.masculino:
        return 'masculino'; // String en español
      case UserGender.femenino:
        return 'femenino'; // String en español
      case UserGender.otro:
        return 'otro'; // String en español
    }
  }

  // Parsea string hexadecimal a Color
  static Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('0x') || colorString.startsWith('#')) {
        // Extraer solo el valor hexadecimal
        String hex = colorString
            .replaceFirst('#', '')
            .replaceFirst('0x', ''); // Elimina prefijos
        // Si es de 6 caracteres, agregar opacidad FF al inicio
        if (hex.length == 6) {
          hex = 'FF$hex'; // Agrega alpha channel (FF = opaco)
        }
        // Si es de 8 caracteres, está bien
        if (hex.length == 8) {
          return Color(
              int.parse(hex, radix: 16)); // Convierte hex a int y crea Color
        }
      }
      return defaultSkinColor; // Valor por defecto si hay error
    } catch (e) {
      print('Error parsing color $colorString: $e'); // Log de error
      return defaultSkinColor; // Valor por defecto
    }
  }

  // Convierte Color a string hexadecimal
  static String _getColorString(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0')}'; // Valor hex con padding de 8 caracteres
  }

  /*
    Métodos de utilidad
  */

  // Agrega puntos al usuario
  UserModel addPoints(int points) {
    final newTotalPoints = totalPoints + points; // Suma puntos
    final newLevel = calculateLevel(newTotalPoints); // Calcula nuevo nivel

    return copyWith(
      totalPoints: newTotalPoints, // Actualiza puntos
      level: newLevel, // Actualiza nivel
    );
  }

  // Marca actividad como completada
  UserModel completeActivity(String activityId) {
    final newCompletedIds =
        List<String>.from(completedActivityIds); // Copia lista
    if (!newCompletedIds.contains(activityId)) {
      newCompletedIds.add(activityId); // Agrega ID si no existe
    }

    return copyWith(
      completedActivityIds: newCompletedIds, // Actualiza lista
    );
  }

  // Alterna actividad entre favorita y no favorita
  UserModel toggleFavorite(String activityId) {
    final newFavoriteIds =
        List<String>.from(favoriteActivityIds); // Copia lista
    if (newFavoriteIds.contains(activityId)) {
      newFavoriteIds.remove(activityId); // Si ya es favorita, la quita
    } else {
      newFavoriteIds.add(activityId); // Si no es favorita, la agrega
    }

    return copyWith(
      favoriteActivityIds: newFavoriteIds, // Actualiza lista
    );
  }

  // Cambia estilo de avatar
  UserModel changeAvatarStyle(String newStyle) {
    return copyWith(
      avatarStyle: newStyle, // Actualiza estilo
    );
  }

  // Personaliza avatar
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

  // Actualiza género
  UserModel updateGender(UserGender newGender) {
    return copyWith(
      gender: newGender, // Actualiza género
    );
  }

  // Actualiza contadores de actividades
  UserModel updateActivityCount(String activityId, int increment) {
    final updatedCounts = Map<String, int>.from(activityCounts); // Copia mapa
    updatedCounts[activityId] =
        (updatedCounts[activityId] ?? 0) + increment; // Incrementa conteo

    // Actualizar fecha de última actividad y verificar días consecutivos
    final now = DateTime.now(); // Fecha actual
    final updatedLastActivityDate = now; // Última actividad ahora

    int updatedConsecutiveDays = consecutiveDays; // Inicia con valor actual
    if (lastActivityDate != null) {
      final daysDifference =
          now.difference(lastActivityDate!).inDays; // Diferencia en días
      if (daysDifference == 1) {
        updatedConsecutiveDays =
            consecutiveDays + 1; // Si fue ayer, incrementa racha
      } else if (daysDifference > 1) {
        updatedConsecutiveDays = 1; // Si pasó más de un día, reinicia racha
      }
    } else {
      updatedConsecutiveDays = 1; // Si no había fecha previa, empieza racha
    }

    return copyWith(
      activityCounts: updatedCounts, // Actualiza conteos
      lastActivityDate:
          updatedLastActivityDate, // Actualiza fecha de última actividad
      consecutiveDays: updatedConsecutiveDays, // Actualiza días consecutivos
    );
  }

  // Agrega logro completado
  UserModel addAchievement(String achievementId) {
    final newCompletedAchievements =
        List<String>.from(completedAchievementIds); // Copia lista
    if (!newCompletedAchievements.contains(achievementId)) {
      newCompletedAchievements.add(achievementId); // Agrega ID si no existe
    }

    return copyWith(
      completedAchievementIds: newCompletedAchievements, // Actualiza lista
    );
  }

  // Equipa título
  UserModel equipTitle(String title) {
    return copyWith(
      selectedTitle: title, // Actualiza título equipado
    );
  }

  // Verifica si tiene un logro específico
  bool hasAchievement(String achievementId) {
    return completedAchievementIds.contains(achievementId); // Busca en lista
  }

  // Obtiene conteo de una actividad específica
  int getActivityCount(String activityId) {
    return activityCounts[activityId] ?? 0; // Retorna conteo o 0
  }

  // Obtiene descripción del avatar
  String get avatarDescription {
    final genderText = gender == UserGender.femenino
        ? 'Femenino'
        : 'Masculino'; // Texto de género
    final glassesText =
        hasGlasses ? 'con lentes' : 'sin lentes'; // Texto de lentes
    final accessoryText =
        hasAccessory ? 'con $accessory' : ''; // Texto de accesorio
    final skinText =
        hasCustomSkinColor ? 'tono personalizado' : ''; // Texto de piel
    final hairText =
        hasCustomHairColor ? 'cabello personalizado' : ''; // Texto de cabello
    final eyeText =
        hasCustomEyeColor ? 'ojos personalizados' : ''; // Texto de ojos

    return 'Avatar $genderText $glassesText $accessoryText $skinText $hairText $eyeText'; // Descripción completa
  }

  // Restablece avatar a valores por defecto
  UserModel resetAvatar() {
    return copyWith(
      skinColor: defaultSkinColor, // Color de piel por defecto
      hairColor: defaultHairColor, // Color de cabello por defecto
      eyeColor: defaultEyeColor, // Color de ojos por defecto
      hasGlasses: defaultHasGlasses, // Lentes por defecto (false)
      accessory: null, // Sin accesorio
      avatarStyle: 'simple', // Estilo simple
    );
  }

  // Obtiene información de colores del avatar
  Map<String, String> get avatarColorInfo {
    return {
      'skin': _getColorName(skinColor), // Nombre del color de piel
      'hair': _getColorName(hairColor), // Nombre del color de cabello
      'eyes': _getColorName(eyeColor), // Nombre del color de ojos
    };
  }

  // Obtiene resumen de personalización del avatar
  Map<String, dynamic> get avatarCustomizationSummary {
    return {
      'isCustomized': isAvatarCustomized, // Si está personalizado
      'skin': {
        'color': skinColor.value, // Valor hex del color
        'isCustom': hasCustomSkinColor, // Si es personalizado
        'name': _getColorName(skinColor), // Nombre del color
      },
      'hair': {
        'color': hairColor.value, // Valor hex del color
        'isCustom': hasCustomHairColor, // Si es personalizado
        'name': _getColorName(hairColor), // Nombre del color
      },
      'eyes': {
        'color': eyeColor.value, // Valor hex del color
        'isCustom': hasCustomEyeColor, // Si es personalizado
        'name': _getColorName(eyeColor), // Nombre del color
      },
      'glasses': {
        'hasGlasses': hasGlasses, // Si tiene lentes
        'isCustom': hasCustomGlasses, // Si son personalizados
      },
      'accessory': accessory, // Accesorio
      'style': avatarStyle, // Estilo de avatar
    };
  }

  // Método auxiliar para obtener nombre del color
  String _getColorName(Color color) {
    if (color == defaultSkinColor)
      return 'Piel Claro'; // Nombre para color por defecto
    if (color == defaultHairColor)
      return 'Castaño Oscuro'; // Nombre para color por defecto
    if (color == defaultEyeColor)
      return 'Verde'; // Nombre para color por defecto
    if (color == Colors.black) return 'Negro'; // Negro
    if (color == Colors.brown) return 'Marrón'; // Marrón
    if (color == Colors.blue) return 'Azul'; // Azul
    if (color == Colors.green) return 'Verde'; // Verde
    if (color == Colors.grey) return 'Gris'; // Gris
    if (color == const Color(0xFFFFDBAC)) return 'Claro'; // Color claro
    if (color == const Color(0xFFD8A871)) return 'Medio'; // Color medio
    if (color == const Color(0xFFA1663C)) return 'Oscuro'; // Color oscuro
    if (color == const Color(0xFF8D5524))
      return 'Muy Oscuro'; // Color muy oscuro
    if (color == const Color(0xFF8B4513)) return 'Castaño'; // Castaño
    if (color == const Color(0xFFD2691E))
      return 'Castaño Claro'; // Castaño claro
    if (color == const Color(0xFFCD853F)) return 'Rubio Oscuro'; // Rubio oscuro
    if (color == const Color(0xFFDAA520)) return 'Rubio'; // Rubio
    if (color == const Color(0xFFB8860B)) return 'Cobrizo'; // Cobrizo
    return 'Personalizado'; // Color no reconocido
  }

  /*
    Representación en string del UserModel (para debugging)
  */
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, level: $level, points: $totalPoints, avatarStyle: $avatarStyle, isCustomized: $isAvatarCustomized)';
  }

  /*
    Compara si dos UserModel son iguales (operador ==)
  */
  @override
  bool operator ==(Object other) =>
      identical(this, other) || // Misma referencia
      other is UserModel && // Mismo tipo
          runtimeType == other.runtimeType && // Misma clase
          id == other.id && // Mismo ID
          name == other.name; // Mismo nombre

  /*
    Genera código hash para UserModel
  */
  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode; // Hash combinado de ID y nombre
}
