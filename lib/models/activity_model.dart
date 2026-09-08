// models/activity_model.dart
import 'package:flutter/material.dart'; // Importar framework Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Importar tema de la aplicación

// Enumeración para categorías de actividades
enum ActivityCategory {
  cultivo, // Actividades de cultivo
  habitos, // Actividades de hábitos
  social, // Actividades sociales
  habilidad, // Actividades de habilidad
  misiones, // Misiones especiales
  riego, // Actividades de riego
  cosecha, // Actividades de cosecha
  mantenimiento, // Actividades de mantenimiento
}

// Enumeración para frecuencia de actividades
enum ActivityFrequency {
  diaria, // Actividad diaria
  semanal, // Actividad semanal
  mensual, // Actividad mensual
  unica, // Actividad única
  personalizada, // Frecuencia personalizada
}

// Enumeración para dificultad de actividades
enum ActivityDifficulty {
  facil, // Dificultad fácil
  medio, // Dificultad media
  dificil, // Dificultad difícil
  experto, // Dificultad experto
}

// Enumeración para género del usuario
enum UserGender {
  masculino, // Género masculino
  femenino, // Género femenino
  otro, // Otro género
}

/*
    Modelo para perfil de usuario
*/
class UserProfile {
  final String id; // ID único del usuario
  final String name; // Nombre del usuario
  final String email; // Email del usuario
  final UserGender gender; // Género del usuario
  final String? avatarPath; // Ruta del avatar personalizado (opcional)
  final DateTime createdAt; // Fecha de creación del perfil
  final int totalPoints; // Puntos totales acumulados
  final int level; // Nivel actual del usuario
  final Map<String, dynamic>?
      preferences; // Preferencias del usuario (opcional)
  final List<String> completedActivityIds; // IDs de actividades completadas
  final List<String> favoriteActivityIds; // IDs de actividades favoritas

  // Constructor de UserProfile
  const UserProfile({
    required this.id, // Requerido: ID
    required this.name, // Requerido: nombre
    required this.email, // Requerido: email
    required this.gender, // Requerido: género
    this.avatarPath, // Opcional: ruta de avatar
    required this.createdAt, // Requerido: fecha de creación
    this.totalPoints = 0, // Opcional: puntos totales (0 por defecto)
    this.level = 1, // Opcional: nivel (1 por defecto)
    this.preferences, // Opcional: preferencias
    this.completedActivityIds =
        const [], // Opcional: actividades completadas (lista vacía)
    this.favoriteActivityIds =
        const [], // Opcional: actividades favoritas (lista vacía)
  });

  /*
    Obtiene la ruta del avatar basado en el género
  */
  String get avatarImagePath {
    if (avatarPath != null && avatarPath!.isNotEmpty) {
      return avatarPath!; // Si hay avatar personalizado, usar esa ruta
    }

    // Si no hay avatar personalizado, usar el predeterminado por género
    switch (gender) {
      case UserGender.masculino:
        return 'lib/images/avatar_masculino.png'; // Avatar masculino por defecto
      case UserGender.femenino:
        return 'lib/images/avatar_femenino.png'; // Avatar femenino por defecto
      case UserGender.otro:
        return 'lib/images/avatar_masculino.png'; // Avatar predeterminado para "otro"
    }
  }

  /*
    Obtiene el avatar predeterminado según género
  */
  static String getDefaultAvatar(UserGender gender) {
    switch (gender) {
      case UserGender.masculino:
        return 'lib/images/avatar_masculino.png'; // Avatar masculino
      case UserGender.femenino:
        return 'lib/images/avatar_femenino.png'; // Avatar femenino
      case UserGender.otro:
        return 'lib/images/avatar_masculino.png'; // Avatar predeterminado
    }
  }

  /*
    Obtiene el nombre del género para mostrar
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
    Constructor factory para crear UserProfile desde JSON
  */
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '', // ID o string vacío
      name: json['name'] ?? '', // Nombre o string vacío
      email: json['email'] ?? '', // Email o string vacío
      gender: _parseGender(json['gender'] ?? ''), // Parsea género
      avatarPath: json['avatarPath'], // Ruta de avatar (puede ser null)
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']) // Parsea fecha
          : DateTime.now(), // O usa fecha actual
      totalPoints: json['totalPoints'] ?? 0, // Puntos o 0
      level: json['level'] ?? 1, // Nivel o 1
      preferences: json['preferences'] != null
          ? Map<String, dynamic>.from(
              json['preferences']) // Convierte mapa de preferencias
          : null, // O null
      completedActivityIds: List<String>.from(
          json['completedActivityIds'] ?? []), // Lista de IDs completados
      favoriteActivityIds: List<String>.from(
          json['favoriteActivityIds'] ?? []), // Lista de favoritos
    );
  }

  /*
    Convierte UserProfile a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': _getGenderString(gender), // Convierte género a string
      'avatarPath': avatarPath,
      'createdAt': createdAt.toIso8601String(), // Convierte fecha a string ISO
      'totalPoints': totalPoints,
      'level': level,
      'preferences': preferences,
      'completedActivityIds': completedActivityIds,
      'favoriteActivityIds': favoriteActivityIds,
    };
  }

  /*
    Crea una copia del UserProfile con algunos valores actualizados
  */
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    UserGender? gender,
    String? avatarPath,
    DateTime? createdAt,
    int? totalPoints,
    int? level,
    Map<String, dynamic>? preferences,
    List<String>? completedActivityIds,
    List<String>? favoriteActivityIds,
  }) {
    return UserProfile(
      id: id ?? this.id, // Usa nuevo valor o el actual
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      preferences: preferences ?? this.preferences,
      completedActivityIds: completedActivityIds ?? this.completedActivityIds,
      favoriteActivityIds: favoriteActivityIds ?? this.favoriteActivityIds,
    );
  }

  /*
    Convierte string de género a enum UserGender
  */
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
        return UserGender.masculino; // Por defecto masculino
    }
  }

  /*
    Convierte enum UserGender a string
  */
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

  /*
    Agrega puntos al perfil del usuario
  */
  UserProfile addPoints(int points) {
    final newTotalPoints = totalPoints + points; // Suma puntos
    final newLevel = calculateLevel(newTotalPoints); // Calcula nuevo nivel

    return copyWith(
      totalPoints: newTotalPoints, // Actualiza puntos
      level: newLevel, // Actualiza nivel
    );
  }

  /*
    Marca una actividad como completada
  */
  UserProfile completeActivity(String activityId) {
    final newCompletedIds =
        List<String>.from(completedActivityIds); // Copia lista
    if (!newCompletedIds.contains(activityId)) {
      newCompletedIds.add(activityId); // Agrega ID si no existe
    }

    return copyWith(
      completedActivityIds: newCompletedIds, // Actualiza lista
    );
  }

  /*
    Alterna una actividad entre favorita y no favorita
  */
  UserProfile toggleFavorite(String activityId) {
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

  /*
    Calcula nivel basado en puntos (100 puntos por nivel)
  */
  static int calculateLevel(int points) {
    return (points / 100).floor() +
        1; // Divide puntos entre 100 y redondea hacia abajo + 1
  }

  /*
    Obtiene progreso hacia el siguiente nivel (0.0 a 1.0)
  */
  double get levelProgress {
    final pointsForCurrentLevel =
        (level - 1) * 100; // Puntos necesarios para el nivel actual
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
}

/*
    Modelo principal de actividad
*/
class Activity {
  final String id; // ID único de la actividad
  final String name; // Nombre de la actividad
  final String description; // Descripción de la actividad
  final int points; // Puntos que otorga al completarse
  final ActivityCategory category; // Categoría de la actividad
  final String icon; // Icono de la actividad (emoji)
  final Color color; // Color de la actividad
  final int maxDaily; // Máximo de veces por día que se puede realizar
  final ActivityFrequency frequency; // Frecuencia de la actividad
  final ActivityDifficulty difficulty; // Dificultad de la actividad
  final Duration? estimatedDuration; // Duración estimada (opcional)
  final List<String> tags; // Etiquetas de la actividad
  final String? tutorialUrl; // URL de tutorial (opcional)
  final Map<String, dynamic>? metadata; // Datos adicionales (opcional)
  final bool isActive; // Si la actividad está activa
  final DateTime?
      availableFrom; // Fecha desde la que está disponible (opcional)
  final DateTime?
      availableUntil; // Fecha hasta la que está disponible (opcional)

  // Constructor de Activity
  const Activity({
    required this.id, // Requerido: ID
    required this.name, // Requerido: nombre
    required this.description, // Requerido: descripción
    required this.points, // Requerido: puntos
    required this.category, // Requerido: categoría
    required this.icon, // Requerido: icono
    required this.color, // Requerido: color
    this.maxDaily = 1, // Opcional: máximo diario (1 por defecto)
    this.frequency =
        ActivityFrequency.diaria, // Opcional: frecuencia (diaria por defecto)
    this.difficulty =
        ActivityDifficulty.facil, // Opcional: dificultad (fácil por defecto)
    this.estimatedDuration, // Opcional: duración estimada
    this.tags = const [], // Opcional: etiquetas (lista vacía)
    this.tutorialUrl, // Opcional: URL de tutorial
    this.metadata, // Opcional: metadatos
    this.isActive = true, // Opcional: activa (true por defecto)
    this.availableFrom, // Opcional: disponible desde
    this.availableUntil, // Opcional: disponible hasta
  });

  /*
    Verifica si la actividad está disponible actualmente
  */
  bool get isAvailable {
    final now = DateTime.now(); // Obtiene fecha actual
    if (availableFrom != null && now.isBefore(availableFrom!)) {
      return false; // Si es antes de la fecha de inicio
    }
    if (availableUntil != null && now.isAfter(availableUntil!)) {
      return false; // Si es después de la fecha de fin
    }
    return isActive; // Retorna si está activa
  }

  /*
    Obtiene el nombre de la categoría para mostrar
  */
  String get displayCategory => _getCategoryName(category);

  /*
    Obtiene el nombre de la dificultad para mostrar
  */
  String get displayDifficulty => _getDifficultyName(difficulty);

  /*
    Obtiene el nombre de la frecuencia para mostrar
  */
  String get displayFrequency => _getFrequencyName(frequency);

  /*
    Constructor factory para crear Activity desde JSON
  */
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '', // ID o string vacío
      name: json['name'] ?? '', // Nombre o string vacío
      description: json['description'] ?? '', // Descripción o string vacío
      points: json['points'] ?? 0, // Puntos o 0
      category: _parseCategory(json['category'] ?? ''), // Parsea categoría
      icon: json['icon'] ?? '🌱', // Icono o emoji de brote por defecto
      color: ActivityUtils.parseColor(json['color'] ?? ''), // Parsea color
      maxDaily: json['maxDaily'] ?? 1, // Máximo diario o 1
      frequency: _parseFrequency(json['frequency'] ?? ''), // Parsea frecuencia
      difficulty:
          _parseDifficulty(json['difficulty'] ?? ''), // Parsea dificultad
      estimatedDuration: json['estimatedDuration'] != null
          ? Duration(
              minutes: json['estimatedDuration']) // Crea Duration desde minutos
          : null, // O null
      tags: List<String>.from(json['tags'] ?? []), // Lista de etiquetas
      tutorialUrl: json['tutorialUrl'], // URL de tutorial (puede ser null)
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata']) // Convierte metadatos
          : null, // O null
      isActive: json['isActive'] ?? true, // Activa o true por defecto
      availableFrom: json['availableFrom'] != null
          ? DateTime.parse(json['availableFrom']) // Parsea fecha de inicio
          : null, // O null
      availableUntil: json['availableUntil'] != null
          ? DateTime.parse(json['availableUntil']) // Parsea fecha de fin
          : null, // O null
    );
  }

  /*
    Convierte Activity a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'points': points,
      'category': _getCategoryString(category), // Convierte categoría a string
      'icon': icon,
      'color': ActivityUtils.getColorString(color), // Convierte color a string
      'maxDaily': maxDaily,
      'frequency':
          _getFrequencyString(frequency), // Convierte frecuencia a string
      'difficulty':
          _getDifficultyString(difficulty), // Convierte dificultad a string
      'estimatedDuration': estimatedDuration?.inMinutes, // Duración en minutos
      'tags': tags,
      'tutorialUrl': tutorialUrl,
      'metadata': metadata,
      'isActive': isActive,
      'availableFrom': availableFrom?.toIso8601String(), // Fecha a string ISO
      'availableUntil': availableUntil?.toIso8601String(), // Fecha a string ISO
    };
  }

  /*
    Crea una copia de Activity con algunos valores actualizados
  */
  Activity copyWith({
    String? id,
    String? name,
    String? description,
    int? points,
    ActivityCategory? category,
    String? icon,
    Color? color,
    int? maxDaily,
    ActivityFrequency? frequency,
    ActivityDifficulty? difficulty,
    Duration? estimatedDuration,
    List<String>? tags,
    String? tutorialUrl,
    Map<String, dynamic>? metadata,
    bool? isActive,
    DateTime? availableFrom,
    DateTime? availableUntil,
  }) {
    return Activity(
      id: id ?? this.id, // Usa nuevo valor o el actual
      name: name ?? this.name,
      description: description ?? this.description,
      points: points ?? this.points,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      maxDaily: maxDaily ?? this.maxDaily,
      frequency: frequency ?? this.frequency,
      difficulty: difficulty ?? this.difficulty,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      tags: tags ?? this.tags,
      tutorialUrl: tutorialUrl ?? this.tutorialUrl,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
    );
  }

  /*
    Métodos estáticos para parsing de strings a enums
  */

  // Parsea string a ActivityCategory
  static ActivityCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      // Convierte a minúsculas
      case 'cultivo':
        return ActivityCategory.cultivo; // Categoría cultivo
      case 'hábitos':
      case 'habitos':
        return ActivityCategory.habitos; // Categoría hábitos
      case 'social':
        return ActivityCategory.social; // Categoría social
      case 'habilidad':
        return ActivityCategory.habilidad; // Categoría habilidad
      case 'misiones':
        return ActivityCategory.misiones; // Categoría misiones
      case 'riego':
        return ActivityCategory.riego; // Categoría riego
      case 'cosecha':
        return ActivityCategory.cosecha; // Categoría cosecha
      case 'mantenimiento':
        return ActivityCategory.mantenimiento; // Categoría mantenimiento
      default:
        return ActivityCategory.cultivo; // Por defecto: cultivo
    }
  }

  // Parsea string a ActivityFrequency
  static ActivityFrequency _parseFrequency(String frequency) {
    switch (frequency.toLowerCase()) {
      // Convierte a minúsculas
      case 'diaria':
        return ActivityFrequency.diaria; // Frecuencia diaria
      case 'semanal':
        return ActivityFrequency.semanal; // Frecuencia semanal
      case 'mensual':
        return ActivityFrequency.mensual; // Frecuencia mensual
      case 'única':
      case 'unica':
        return ActivityFrequency.unica; // Frecuencia única
      case 'personalizada':
        return ActivityFrequency.personalizada; // Frecuencia personalizada
      default:
        return ActivityFrequency.diaria; // Por defecto: diaria
    }
  }

  // Parsea string a ActivityDifficulty
  static ActivityDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      // Convierte a minúsculas
      case 'fácil':
      case 'facil':
        return ActivityDifficulty.facil; // Dificultad fácil
      case 'medio':
        return ActivityDifficulty.medio; // Dificultad media
      case 'difícil':
      case 'dificil':
        return ActivityDifficulty.dificil; // Dificultad difícil
      case 'experto':
        return ActivityDifficulty.experto; // Dificultad experto
      default:
        return ActivityDifficulty.facil; // Por defecto: fácil
    }
  }

  /*
    Métodos estáticos para convertir enums a strings
  */

  // Convierte ActivityCategory a string
  static String _getCategoryString(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return 'cultivo'; // String en minúsculas
      case ActivityCategory.habitos:
        return 'hábitos'; // String con tilde
      case ActivityCategory.social:
        return 'social'; // String en minúsculas
      case ActivityCategory.habilidad:
        return 'habilidad'; // String en minúsculas
      case ActivityCategory.misiones:
        return 'misiones'; // String en minúsculas
      case ActivityCategory.riego:
        return 'riego'; // String en minúsculas
      case ActivityCategory.cosecha:
        return 'cosecha'; // String en minúsculas
      case ActivityCategory.mantenimiento:
        return 'mantenimiento'; // String en minúsculas
    }
  }

  // Convierte ActivityFrequency a string
  static String _getFrequencyString(ActivityFrequency frequency) {
    switch (frequency) {
      case ActivityFrequency.diaria:
        return 'diaria'; // String en minúsculas
      case ActivityFrequency.semanal:
        return 'semanal'; // String en minúsculas
      case ActivityFrequency.mensual:
        return 'mensual'; // String en minúsculas
      case ActivityFrequency.unica:
        return 'única'; // String con tilde
      case ActivityFrequency.personalizada:
        return 'personalizada'; // String en minúsculas
    }
  }

  // Convierte ActivityDifficulty a string
  static String _getDifficultyString(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 'fácil'; // String con tilde
      case ActivityDifficulty.medio:
        return 'medio'; // String en minúsculas
      case ActivityDifficulty.dificil:
        return 'difícil'; // String con tilde
      case ActivityDifficulty.experto:
        return 'experto'; // String en minúsculas
    }
  }

  /*
    Métodos para obtener nombres en español para mostrar
  */

  // Obtiene nombre de categoría en español
  String _getCategoryName(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return 'Cultivo'; // Nombre en español
      case ActivityCategory.habitos:
        return 'Hábitos'; // Nombre en español
      case ActivityCategory.social:
        return 'Social'; // Nombre en español
      case ActivityCategory.habilidad:
        return 'Habilidad'; // Nombre en español
      case ActivityCategory.misiones:
        return 'Misiones'; // Nombre en español
      case ActivityCategory.riego:
        return 'Riego'; // Nombre en español
      case ActivityCategory.cosecha:
        return 'Cosecha'; // Nombre en español
      case ActivityCategory.mantenimiento:
        return 'Mantenimiento'; // Nombre en español
    }
  }

  // Obtiene nombre de dificultad en español
  String _getDifficultyName(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 'Fácil'; // Nombre en español
      case ActivityDifficulty.medio:
        return 'Medio'; // Nombre en español
      case ActivityDifficulty.dificil:
        return 'Difícil'; // Nombre en español
      case ActivityDifficulty.experto:
        return 'Experto'; // Nombre en español
    }
  }

  // Obtiene nombre de frecuencia en español
  String _getFrequencyName(ActivityFrequency frequency) {
    switch (frequency) {
      case ActivityFrequency.diaria:
        return 'Diaria'; // Nombre en español
      case ActivityFrequency.semanal:
        return 'Semanal'; // Nombre en español
      case ActivityFrequency.mensual:
        return 'Mensual'; // Nombre en español
      case ActivityFrequency.unica:
        return 'Única'; // Nombre en español
      case ActivityFrequency.personalizada:
        return 'Personalizada'; // Nombre en español
    }
  }
}

/*
    Modelo para registrar una actividad completada por el usuario
*/
class CompletedActivity {
  final String id; // ID único del registro
  final String activityId; // ID de la actividad completada
  final String userId; // ID del usuario que completó la actividad
  final DateTime completedAt; // Fecha y hora de completado
  final int pointsEarned; // Puntos ganados
  final Map<String, dynamic>? metadata; // Metadatos adicionales (opcional)
  final Duration? timeSpent; // Tiempo dedicado (opcional)
  final String? notes; // Notas del usuario (opcional)
  final bool isVerified; // Si fue verificada automática o manualmente

  // Constructor de CompletedActivity
  const CompletedActivity({
    required this.id, // Requerido: ID
    required this.activityId, // Requerido: ID de actividad
    required this.userId, // Requerido: ID de usuario
    required this.completedAt, // Requerido: fecha de completado
    required this.pointsEarned, // Requerido: puntos ganados
    this.metadata, // Opcional: metadatos
    this.timeSpent, // Opcional: tiempo dedicado
    this.notes, // Opcional: notas
    this.isVerified = true, // Opcional: verificado (true por defecto)
  });

  /*
    Constructor factory para crear desde JSON
  */
  factory CompletedActivity.fromJson(Map<String, dynamic> json) {
    return CompletedActivity(
      id: json['id'] ?? '', // ID o string vacío
      activityId: json['activityId'] ?? '', // ID de actividad o string vacío
      userId: json['userId'] ?? '', // ID de usuario o string vacío
      completedAt:
          DateTime.parse(json['completedAt']), // Parsea fecha (requerido)
      pointsEarned: json['pointsEarned'] ?? 0, // Puntos o 0
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata']) // Convierte metadatos
          : null, // O null
      timeSpent: json['timeSpent'] != null
          ? Duration(seconds: json['timeSpent']) // Crea Duration desde segundos
          : null, // O null
      notes: json['notes'], // Notas (puede ser null)
      isVerified: json['isVerified'] ?? true, // Verificado o true
    );
  }

  /*
    Convierte CompletedActivity a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'userId': userId,
      'completedAt': completedAt.toIso8601String(), // Fecha a string ISO
      'pointsEarned': pointsEarned,
      'metadata': metadata,
      'timeSpent': timeSpent?.inSeconds, // Tiempo en segundos
      'notes': notes,
      'isVerified': isVerified,
    };
  }

  /*
    Crea una copia de CompletedActivity con algunos valores actualizados
  */
  CompletedActivity copyWith({
    String? id,
    String? activityId,
    String? userId,
    DateTime? completedAt,
    int? pointsEarned,
    Map<String, dynamic>? metadata,
    Duration? timeSpent,
    String? notes,
    bool? isVerified,
  }) {
    return CompletedActivity(
      id: id ?? this.id, // Usa nuevo valor o el actual
      activityId: activityId ?? this.activityId,
      userId: userId ?? this.userId,
      completedAt: completedAt ?? this.completedAt,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      metadata: metadata ?? this.metadata,
      timeSpent: timeSpent ?? this.timeSpent,
      notes: notes ?? this.notes,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

/*
    Modelo para estadísticas de actividad del usuario
*/
class ActivityStats {
  final String userId; // ID del usuario
  final int totalActivities; // Total de actividades completadas
  final int totalPoints; // Puntos totales ganados
  final Map<String, int>
      activitiesByCategory; // Conteo de actividades por categoría
  final Map<String, int> activitiesByDay; // Conteo de actividades por día
  final String mostActiveCategory; // Categoría más activa
  final String mostActiveDay; // Día más activo
  final Duration averageTimeSpent; // Tiempo promedio dedicado
  final int currentStreak; // Racha actual de días consecutivos
  final int longestStreak; // Racha más larga de días consecutivos
  final Map<ActivityDifficulty, int>
      activitiesByDifficulty; // Conteo por dificultad

  // Constructor de ActivityStats
  const ActivityStats({
    required this.userId, // Requerido: ID de usuario
    required this.totalActivities, // Requerido: total de actividades
    required this.totalPoints, // Requerido: puntos totales
    required this.activitiesByCategory, // Requerido: actividades por categoría
    required this.activitiesByDay, // Requerido: actividades por día
    required this.mostActiveCategory, // Requerido: categoría más activa
    required this.mostActiveDay, // Requerido: día más activo
    required this.averageTimeSpent, // Requerido: tiempo promedio
    required this.currentStreak, // Requerido: racha actual
    required this.longestStreak, // Requerido: racha más larga
    required this.activitiesByDifficulty, // Requerido: actividades por dificultad
  });

  /*
    Constructor factory para crear desde JSON
  */
  factory ActivityStats.fromJson(Map<String, dynamic> json) {
    return ActivityStats(
      userId: json['userId'] ?? '', // ID de usuario o string vacío
      totalActivities: json['totalActivities'] ?? 0, // Total o 0
      totalPoints: json['totalPoints'] ?? 0, // Puntos o 0
      activitiesByCategory: Map<String, int>.from(
          json['activitiesByCategory'] ??
              {}), // Mapa de actividades por categoría
      activitiesByDay: Map<String, int>.from(
          json['activitiesByDay'] ?? {}), // Mapa de actividades por día
      mostActiveCategory:
          json['mostActiveCategory'] ?? '', // Categoría o string vacío
      mostActiveDay: json['mostActiveDay'] ?? '', // Día o string vacío
      averageTimeSpent: Duration(
          seconds: json['averageTimeSpent'] ?? 0), // Duración desde segundos
      currentStreak: json['currentStreak'] ?? 0, // Racha actual o 0
      longestStreak: json['longestStreak'] ?? 0, // Racha más larga o 0
      activitiesByDifficulty:
          (json['activitiesByDifficulty'] as Map<String, dynamic>? ?? {}).map(
              // Mapa de dificultades
              (key, value) => MapEntry(_parseDifficulty(key),
                  value as int)), // Convierte keys a enums
    );
  }

  /*
    Convierte ActivityStats a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalActivities': totalActivities,
      'totalPoints': totalPoints,
      'activitiesByCategory': activitiesByCategory,
      'activitiesByDay': activitiesByDay,
      'mostActiveCategory': mostActiveCategory,
      'mostActiveDay': mostActiveDay,
      'averageTimeSpent': averageTimeSpent.inSeconds, // Tiempo en segundos
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'activitiesByDifficulty': activitiesByDifficulty.map((key, value) =>
          MapEntry(
              _getDifficultyString(key), value)), // Convierte enums a strings
    };
  }

  /*
    Calcula el promedio de puntos por actividad
  */
  double get averagePointsPerActivity {
    return totalActivities > 0
        ? totalPoints / totalActivities
        : 0; // División segura
  }

  /*
    Calcula el número de actividades realizadas esta semana
  */
  int get activitiesThisWeek {
    final now = DateTime.now(); // Fecha actual
    final weekStart = now
        .subtract(Duration(days: now.weekday - 1)); // Inicio de semana (lunes)
    return activitiesByDay.entries
        .where((entry) {
          final date = DateTime.parse(entry.key); // Parsea fecha del string
          return date.isAfter(weekStart.subtract(const Duration(
              days: 1))); // Si es después del inicio de semana -1 día
        })
        .map((entry) => entry.value) // Obtiene el valor (conteo)
        .fold(0, (sum, count) => sum + count); // Suma todos los conteos
  }

  /*
    Convierte string de dificultad a enum ActivityDifficulty
  */
  static ActivityDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      // Convierte a minúsculas
      case 'fácil':
      case 'facil':
        return ActivityDifficulty.facil; // Dificultad fácil
      case 'medio':
        return ActivityDifficulty.medio; // Dificultad media
      case 'difícil':
      case 'dificil':
        return ActivityDifficulty.dificil; // Dificultad difícil
      case 'experto':
        return ActivityDifficulty.experto; // Dificultad experto
      default:
        return ActivityDifficulty.facil; // Por defecto: fácil
    }
  }

  /*
    Convierte enum ActivityDifficulty a string
  */
  static String _getDifficultyString(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 'fácil'; // String con tilde
      case ActivityDifficulty.medio:
        return 'medio'; // String en minúsculas
      case ActivityDifficulty.dificil:
        return 'difícil'; // String con tilde
      case ActivityDifficulty.experto:
        return 'experto'; // String en minúsculas
    }
  }
}

/*
    Clase de utilidad para operaciones comunes con actividades
*/
class ActivityUtils {
  /*
    Parsea un nombre de color a objeto Color
  */
  static Color parseColor(String colorName) {
    switch (colorName) {
      case 'freshMint':
        return freshMint; // Color del tema
      case 'clearBlue':
        return clearBlue; // Color del tema
      case 'sunflower':
        return sunflower; // Color del tema
      case 'goldenSun':
        return goldenSun; // Color del tema
      case 'berryPink':
        return berryPink; // Color del tema
      case 'emeraldLeaf':
        return emeraldLeaf; // Color del tema
      case 'forestDepth':
        return forestDepth; // Color del tema
      case 'tomatoRed':
        return tomatoRed; // Color del tema
      case 'oceanMist':
        return oceanMist; // Color del tema
      case 'lightSage':
        return lightSage; // Color del tema
      case 'springGrass':
        return springGrass; // Color del tema
      default:
        // Si es un código hexadecimal
        if (colorName.startsWith('0x') || colorName.startsWith('#')) {
          return Color(int.parse(
              colorName.replaceFirst('#', '0xff'))); // Convierte hex a Color
        }
        return freshMint; // Por defecto
    }
  }

  /*
    Convierte objeto Color a nombre de color del tema
  */
  static String getColorString(Color color) {
    if (color == freshMint) return 'freshMint'; // Compara con color del tema
    if (color == clearBlue) return 'clearBlue'; // Compara con color del tema
    if (color == sunflower) return 'sunflower'; // Compara con color del tema
    if (color == goldenSun) return 'goldenSun'; // Compara con color del tema
    if (color == berryPink) return 'berryPink'; // Compara con color del tema
    if (color == emeraldLeaf) {
      return 'emeraldLeaf'; // Compara con color del tema
    }
    if (color == forestDepth) {
      return 'forestDepth'; // Compara con color del tema
    }
    if (color == tomatoRed) return 'tomatoRed'; // Compara con color del tema
    if (color == oceanMist) return 'oceanMist'; // Compara con color del tema
    if (color == lightSage) return 'lightSage'; // Compara con color del tema
    if (color == springGrass) {
      return 'springGrass'; // Compara con color del tema
    }
    return 'freshMint'; // Por defecto
  }

  /*
    Obtiene todas las actividades de ejemplo para pruebas
  */
  static List<Activity> getSampleActivities() {
    return [
      const Activity(
        // Actividad de plantar semilla
        id: 'plant_seed',
        name: 'Plantar Semilla',
        description: 'Planta una nueva semilla en tu huerto',
        points: 25,
        category: ActivityCategory.cultivo,
        icon: '🌱',
        color: freshMint,
        maxDaily: 5,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: Duration(minutes: 10),
        tags: ['cultivo', 'inicio', 'básico'],
        tutorialUrl: 'https://ejemplo.com/tutorial/plantar',
        metadata: {
          'requiredTools': ['semillas', 'tierra', 'maceta'],
          'season': ['primavera', 'verano', 'otoño'],
          'waterNeeds': 'medio',
        },
      ),
      const Activity(
        // Actividad de regar plantas
        id: 'water_plant',
        name: 'Regar Plantas',
        description: 'Riega las plantas de tu huerto',
        points: 10,
        category: ActivityCategory.riego,
        icon: '💧',
        color: clearBlue,
        maxDaily: 10,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: Duration(minutes: 5),
        tags: ['riego', 'mantenimiento', 'diario'],
        metadata: {
          'waterAmount': 'moderado',
          'bestTime': 'mañana',
          'avoid': 'hojas mojadas por la noche',
        },
      ),
      const Activity(
        // Actividad de cosechar
        id: 'harvest_plant',
        name: 'Cosechar Planta',
        description: 'Recoge los frutos de tus plantas maduras',
        points: 50,
        category: ActivityCategory.cosecha,
        icon: '🌾',
        color: goldenSun,
        maxDaily: 3,
        frequency: ActivityFrequency.semanal,
        difficulty: ActivityDifficulty.medio,
        estimatedDuration: Duration(minutes: 15),
        tags: ['cosecha', 'recompensa', 'fructífero'],
        metadata: {
          'requires': 'planta madura',
          'bestTime': 'mañana temprano',
          'tools': ['tijeras', 'canasta'],
        },
      ),
      const Activity(
        // Actividad de login diario
        id: 'daily_login',
        name: 'Login Diario',
        description: 'Inicia sesión en la aplicación',
        points: 5,
        category: ActivityCategory.habitos,
        icon: '📅',
        color: sunflower,
        maxDaily: 1,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: Duration(seconds: 30),
        tags: ['hábito', 'consistencia', 'diario'],
        metadata: {
          'streakBonus': 'puntos extra por racha',
          'reminder': 'activar notificaciones',
        },
      ),
      const Activity(
        // Actividad social de compartir
        id: 'share_garden',
        name: 'Compartir Huerto',
        description: 'Comparte el progreso de tu huerto con amigos',
        points: 15,
        category: ActivityCategory.social,
        icon: '📤',
        color: berryPink,
        maxDaily: 3,
        frequency: ActivityFrequency.diaria,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: Duration(minutes: 2),
        tags: ['social', 'compartir', 'comunidad'],
        metadata: {
          'platforms': ['whatsapp', 'instagram', 'facebook'],
          'reward': 'puntos sociales extra',
        },
      ),
      const Activity(
        // Actividad de completar tutorial
        id: 'complete_tutorial',
        name: 'Completar Tutorial',
        description: 'Aprende sobre el cuidado de plantas',
        points: 30,
        category: ActivityCategory.habilidad,
        icon: '🎓',
        color: forestDepth,
        maxDaily: 1,
        frequency: ActivityFrequency.unica,
        difficulty: ActivityDifficulty.facil,
        estimatedDuration: Duration(minutes: 20),
        tags: ['aprendizaje', 'tutorial', 'habilidad'],
        tutorialUrl: 'https://ejemplo.com/tutorial/completo',
        metadata: {
          'chapters': 5,
          'quiz': 'disponible al final',
          'certificate': 'disponible',
        },
      ),
      const Activity(
        // Actividad de podar plantas
        id: 'prune_plant',
        name: 'Podar Planta',
        description: 'Poda las ramas y hojas secas de tus plantas',
        points: 20,
        category: ActivityCategory.mantenimiento,
        icon: '✂️',
        color: emeraldLeaf,
        maxDaily: 2,
        frequency: ActivityFrequency.semanal,
        difficulty: ActivityDifficulty.medio,
        estimatedDuration: Duration(minutes: 15),
        tags: ['mantenimiento', 'salud', 'poda'],
        metadata: {
          'tools': ['tijeras de podar', 'guantes'],
          'season': 'todo el año',
          'frequency': 'cada 2 semanas',
        },
      ),
      const Activity(
        // Actividad de añadir fertilizante
        id: 'add_fertilizer',
        name: 'Añadir Fertilizante',
        description: 'Nutre tus plantas con fertilizante natural',
        points: 35,
        category: ActivityCategory.cultivo,
        icon: '🧪',
        color: tomatoRed,
        maxDaily: 1,
        frequency: ActivityFrequency.mensual,
        difficulty: ActivityDifficulty.dificil,
        estimatedDuration: Duration(minutes: 25),
        tags: ['nutrición', 'crecimiento', 'avanzado'],
        metadata: {
          'fertilizerType': 'orgánico',
          'bestTime': 'temporada de crecimiento',
          'precautions': 'no exceder dosis',
        },
      ),
      const Activity(
        // Actividad de identificar plagas
        id: 'identify_pest',
        name: 'Identificar Plaga',
        description: 'Aprende a identificar y tratar plagas comunes',
        points: 40,
        category: ActivityCategory.habilidad,
        icon: '🐛',
        color: oceanMist,
        maxDaily: 1,
        frequency: ActivityFrequency.unica,
        difficulty: ActivityDifficulty.experto,
        estimatedDuration: Duration(minutes: 30),
        tags: ['diagnóstico', 'salud', 'experto'],
        tutorialUrl: 'https://ejemplo.com/tutorial/plagas',
        metadata: {
          'commonPests': ['pulgón', 'araña roja', 'cochinilla'],
          'treatment': 'orgánico recomendado',
          'prevention': 'control regular',
        },
      ),
      const Activity(
        // Actividad de planificar huerto
        id: 'garden_planning',
        name: 'Planificar Huerto',
        description: 'Planifica la distribución de tu huerto',
        points: 45,
        category: ActivityCategory.misiones,
        icon: '📝',
        color: lightSage,
        maxDaily: 1,
        frequency: ActivityFrequency.mensual,
        difficulty: ActivityDifficulty.medio,
        estimatedDuration: Duration(minutes: 40),
        tags: ['planificación', 'diseño', 'organización'],
        metadata: {
          'tools': ['papel', 'lápiz', 'regla'],
          'considerations': ['luz solar', 'espacio', 'compatibilidad'],
          'reward': 'huerto más productivo',
        },
      ),
    ];
  }

  /*
    Agrupa actividades por categoría
  */
  static Map<ActivityCategory, List<Activity>> getActivitiesByCategory() {
    final Map<ActivityCategory, List<Activity>> categorized = {}; // Mapa vacío
    final activities = getSampleActivities(); // Obtiene actividades de ejemplo

    for (final activity in activities) {
      categorized
          .putIfAbsent(activity.category, () => [])
          .add(activity); // Agrupa por categoría
    }

    return categorized; // Retorna mapa categorizado
  }

  /*
    Agrupa actividades por dificultad
  */
  static Map<ActivityDifficulty, List<Activity>> getActivitiesByDifficulty() {
    final Map<ActivityDifficulty, List<Activity>> byDifficulty =
        {}; // Mapa vacío
    final activities = getSampleActivities(); // Obtiene actividades de ejemplo

    for (final activity in activities) {
      byDifficulty
          .putIfAbsent(activity.difficulty, () => [])
          .add(activity); // Agrupa por dificultad
    }

    return byDifficulty; // Retorna mapa por dificultad
  }

  /*
    Obtiene el color asociado a cada categoría
  */
  static Color getCategoryColor(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return freshMint; // Color del tema
      case ActivityCategory.habitos:
        return sunflower; // Color del tema
      case ActivityCategory.social:
        return berryPink; // Color del tema
      case ActivityCategory.habilidad:
        return forestDepth; // Color del tema
      case ActivityCategory.misiones:
        return lightSage; // Color del tema
      case ActivityCategory.riego:
        return clearBlue; // Color del tema
      case ActivityCategory.cosecha:
        return goldenSun; // Color del tema
      case ActivityCategory.mantenimiento:
        return emeraldLeaf; // Color del tema
    }
  }

  /*
    Obtiene el icono asociado a cada categoría
  */
  static String getCategoryIcon(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return '🌱'; // Emoji de brote
      case ActivityCategory.habitos:
        return '📅'; // Emoji de calendario
      case ActivityCategory.social:
        return '👥'; // Emoji de personas
      case ActivityCategory.habilidad:
        return '🎓'; // Emoji de graduación
      case ActivityCategory.misiones:
        return '📝'; // Emoji de lista
      case ActivityCategory.riego:
        return '💧'; // Emoji de agua
      case ActivityCategory.cosecha:
        return '🌾'; // Emoji de cosecha
      case ActivityCategory.mantenimiento:
        return '🛠️'; // Emoji de herramientas
    }
  }

  /*
    Obtiene el nombre de categoría en español
  */
  static String getCategoryName(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.cultivo:
        return 'Cultivo'; // Nombre en español
      case ActivityCategory.habitos:
        return 'Hábitos'; // Nombre en español
      case ActivityCategory.social:
        return 'Social'; // Nombre en español
      case ActivityCategory.habilidad:
        return 'Habilidad'; // Nombre en español
      case ActivityCategory.misiones:
        return 'Misiones'; // Nombre en español
      case ActivityCategory.riego:
        return 'Riego'; // Nombre en español
      case ActivityCategory.cosecha:
        return 'Cosecha'; // Nombre en español
      case ActivityCategory.mantenimiento:
        return 'Mantenimiento'; // Nombre en español
    }
  }

  /*
    Obtiene el color asociado a cada dificultad
  */
  static Color getDifficultyColor(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return const Color(0xFF4CAF50); // Verde para fácil
      case ActivityDifficulty.medio:
        return const Color(0xFFFF9800); // Naranja para medio
      case ActivityDifficulty.dificil:
        return const Color(0xFFF44336); // Rojo para difícil
      case ActivityDifficulty.experto:
        return const Color(0xFF9C27B0); // Púrpura para experto
    }
  }

  /*
    Crea un perfil de usuario de ejemplo (masculino)
  */
  static UserProfile getSampleUserProfile() {
    return UserProfile(
      id: 'user_001',
      name: 'Juan Pérez',
      email: 'juan@example.com',
      gender: UserGender.masculino,
      createdAt:
          DateTime.now().subtract(const Duration(days: 30)), // Hace 30 días
      totalPoints: 875,
      level: 9,
      preferences: {
        'notifications': true,
        'darkMode': false,
        'language': 'es',
      },
      completedActivityIds: [
        // IDs de actividades completadas
        'plant_seed',
        'water_plant',
        'daily_login',
        'share_garden',
      ],
      favoriteActivityIds: [
        // IDs de actividades favoritas
        'plant_seed',
        'harvest_plant',
      ],
    );
  }

  /*
    Crea un perfil de usuario femenino de ejemplo
  */
  static UserProfile getSampleFemaleUserProfile() {
    return UserProfile(
      id: 'user_002',
      name: 'María García',
      email: 'maria@example.com',
      gender: UserGender.femenino,
      createdAt:
          DateTime.now().subtract(const Duration(days: 45)), // Hace 45 días
      totalPoints: 1200,
      level: 13,
      preferences: {
        'notifications': true,
        'darkMode': true, // Modo oscuro activado
        'language': 'es',
      },
      completedActivityIds: [
        // Más actividades completadas
        'plant_seed',
        'water_plant',
        'harvest_plant',
        'daily_login',
        'share_garden',
        'complete_tutorial',
      ],
      favoriteActivityIds: [
        'harvest_plant',
        'prune_plant',
      ],
    );
  }

  /*
    Crea estadísticas de actividad de ejemplo
  */
  static ActivityStats getSampleStats(String userId) {
    return ActivityStats(
      userId: userId,
      totalActivities: 42, // Total de actividades
      totalPoints: 875, // Puntos totales
      activitiesByCategory: {
        // Conteo por categoría
        'Cultivo': 15,
        'Riego': 12,
        'Cosecha': 5,
        'Hábitos': 8,
        'Social': 2,
      },
      activitiesByDay: {
        // Conteo por día
        '2024-01-15': 3,
        '2024-01-16': 2,
        '2024-01-17': 4,
        '2024-01-18': 1,
        '2024-01-19': 3,
      },
      mostActiveCategory: 'Cultivo', // Categoría más activa
      mostActiveDay: 'Miércoles', // Día más activo
      averageTimeSpent: const Duration(minutes: 12), // Tiempo promedio
      currentStreak: 5, // Racha actual
      longestStreak: 12, // Racha más larga
      activitiesByDifficulty: {
        // Conteo por dificultad
        ActivityDifficulty.facil: 25,
        ActivityDifficulty.medio: 12,
        ActivityDifficulty.dificil: 4,
        ActivityDifficulty.experto: 1,
      },
    );
  }

  /*
    Filtra actividades disponibles (no expiradas y activas)
  */
  static List<Activity> getAvailableActivities() {
    return getSampleActivities()
        .where((activity) => activity.isAvailable) // Filtra por disponibilidad
        .toList(); // Convierte a lista
  }

  /*
    Obtiene actividades recomendadas para un usuario
  */
  static List<Activity> getRecommendedActivities({
    required List<String>
        completedActivityIds, // IDs de actividades ya completadas
    required ActivityCategory?
        preferredCategory, // Categoría preferida (opcional)
    required ActivityDifficulty?
        userLevel, // Nivel de dificultad del usuario (opcional)
  }) {
    final allActivities =
        getAvailableActivities(); // Todas las actividades disponibles

    // Filtrar actividades no completadas
    var recommended = allActivities
        .where((activity) =>
            !completedActivityIds.contains(activity.id)) // Excluye completadas
        .toList();

    // Priorizar categoría preferida
    if (preferredCategory != null) {
      recommended.sort((a, b) {
        // Ordena la lista
        if (a.category == preferredCategory &&
            b.category != preferredCategory) {
          return -1; // a antes que b
        }
        if (a.category != preferredCategory &&
            b.category == preferredCategory) {
          return 1; // b antes que a
        }
        return 0; // igual prioridad
      });
    }

    // Ajustar dificultad según nivel del usuario
    if (userLevel != null) {
      recommended.sort((a, b) {
        final aDiff =
            _difficultyValue(a.difficulty); // Valor numérico de dificultad de a
        final bDiff =
            _difficultyValue(b.difficulty); // Valor numérico de dificultad de b
        final targetDiff =
            _difficultyValue(userLevel); // Valor numérico del nivel del usuario

        final aDistance =
            (aDiff - targetDiff).abs(); // Distancia absoluta de a al objetivo
        final bDistance =
            (bDiff - targetDiff).abs(); // Distancia absoluta de b al objetivo

        return aDistance
            .compareTo(bDistance); // Compara distancias (menor es mejor)
      });
    }

    // Limitar a 6 recomendaciones
    return recommended.take(6).toList(); // Toma primeros 6 elementos
  }

  /*
    Asigna valor numérico a cada nivel de dificultad
  */
  static int _difficultyValue(ActivityDifficulty difficulty) {
    switch (difficulty) {
      case ActivityDifficulty.facil:
        return 1; // Valor 1 para fácil
      case ActivityDifficulty.medio:
        return 2; // Valor 2 para medio
      case ActivityDifficulty.dificil:
        return 3; // Valor 3 para difícil
      case ActivityDifficulty.experto:
        return 4; // Valor 4 para experto
    }
  }
}

/*
    Modelo para misiones especiales (grupos de actividades)
*/
class Mission {
  final String id; // ID único de la misión
  final String name; // Nombre de la misión
  final String description; // Descripción de la misión
  final List<String> activityIds; // IDs de actividades que componen la misión
  final int rewardPoints; // Puntos de recompensa al completar la misión
  final String icon; // Icono de la misión
  final Color color; // Color de la misión
  final DateTime? startDate; // Fecha de inicio (opcional)
  final DateTime? endDate; // Fecha de fin (opcional)
  final bool isActive; // Si la misión está activa
  final Map<String, dynamic>? metadata; // Metadatos adicionales (opcional)

  // Constructor de Mission
  const Mission({
    required this.id, // Requerido: ID
    required this.name, // Requerido: nombre
    required this.description, // Requerido: descripción
    required this.activityIds, // Requerido: IDs de actividades
    required this.rewardPoints, // Requerido: puntos de recompensa
    required this.icon, // Requerido: icono
    required this.color, // Requerido: color
    this.startDate, // Opcional: fecha de inicio
    this.endDate, // Opcional: fecha de fin
    this.isActive = true, // Opcional: activa (true por defecto)
    this.metadata, // Opcional: metadatos
  });

  /*
    Verifica si la misión está disponible actualmente
  */
  bool get isAvailable {
    final now = DateTime.now(); // Fecha actual
    if (startDate != null && now.isBefore(startDate!)) {
      return false; // Si es antes del inicio
    }
    if (endDate != null && now.isAfter(endDate!)) {
      return false; // Si es después del fin
    }
    return isActive; // Retorna si está activa
  }

  /*
    Calcula el progreso de la misión basado en actividades completadas
  */
  double calculateProgress(List<String> completedActivityIds) {
    if (activityIds.isEmpty) return 0; // Si no hay actividades, 0%
    final completed = activityIds
        .where((id) => completedActivityIds.contains(id))
        .length; // Cuenta completadas
    return completed / activityIds.length; // Proporción completada
  }

  /*
    Constructor factory para crear desde JSON
  */
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] ?? '', // ID o string vacío
      name: json['name'] ?? '', // Nombre o string vacío
      description: json['description'] ?? '', // Descripción o string vacío
      activityIds: List<String>.from(
          json['activityIds'] ?? []), // Lista de IDs de actividades
      rewardPoints: json['rewardPoints'] ?? 0, // Puntos de recompensa o 0
      icon: json['icon'] ?? '🎯', // Icono o emoji de diana por defecto
      color: ActivityUtils.parseColor(json['color'] ?? ''), // Parsea color
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null, // Parsea fecha de inicio
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null, // Parsea fecha de fin
      isActive: json['isActive'] ?? true, // Activa o true por defecto
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata']) // Convierte metadatos
          : null, // O null
    );
  }

  /*
    Convierte Mission a mapa JSON
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'activityIds': activityIds,
      'rewardPoints': rewardPoints,
      'icon': icon,
      'color': ActivityUtils.getColorString(color), // Convierte color a string
      'startDate': startDate?.toIso8601String(), // Fecha a string ISO
      'endDate': endDate?.toIso8601String(), // Fecha a string ISO
      'isActive': isActive,
      'metadata': metadata,
    };
  }
}
