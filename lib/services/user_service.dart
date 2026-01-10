// services/user_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/activity_model.dart' hide UserGender;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static const String _userPrefsKey = 'user_profile';
  static const String _completedActivitiesKey = 'completed_activities';

  UserModel _currentUser = UserModel.defaultUser();

  UserModel get currentUser => _currentUser;

  // Sistema de notificación para actualizaciones en tiempo real
  final List<Function(UserModel)> _listeners = [];

  void addListener(Function(UserModel) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(UserModel) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_currentUser);
    }
  }

  // Método principal para actualizar usuario
  void updateUser(UserModel newUser) {
    _currentUser = newUser;
    _notifyListeners();
    _saveUserToPrefs(newUser);
  }

  // Cargar usuario desde preferencias
  Future<void> loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userPrefsKey);

      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final loadedUser = UserModel.fromJson(userMap);
        _currentUser = loadedUser;
        _notifyListeners();
      }
    } catch (e) {
      print('Error al cargar usuario: $e');
    }
  }

  // Guardar usuario en preferencias
  Future<void> _saveUserToPrefs(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userPrefsKey, userJson);
    } catch (e) {
      print('Error al guardar usuario: $e');
    }
  }

  // Métodos específicos para manejar el avatar
  Future<void> updateUserGender(UserGender gender) async {
    final updatedUser = _currentUser.copyWith(gender: gender);
    updateUser(updatedUser);
  }

  Future<void> updateAvatarStyle(String style) async {
    final updatedUser = _currentUser.changeAvatarStyle(style);
    updateUser(updatedUser);
  }

  Future<void> customizeAvatar({
    Color? skinColor,
    Color? hairColor,
    Color? eyeColor,
    bool? hasGlasses,
    String? accessory,
  }) async {
    final updatedUser = _currentUser.customizeAvatar(
      skinColor: skinColor,
      hairColor: hairColor,
      eyeColor: eyeColor,
      hasGlasses: hasGlasses,
      accessory: accessory,
    );
    updateUser(updatedUser);
  }

  // Métodos para actividades
  Future<void> completeActivity(String activityId, int points) async {
    try {
      // Agregar puntos y marcar como completada
      final userWithPoints = _currentUser.addPoints(points);
      final updatedUser = userWithPoints.completeActivity(activityId);

      // Actualizar usuario
      updateUser(updatedUser);

      // Guardar actividad completada en historial
      await _saveCompletedActivity(activityId, points);
    } catch (e) {
      print('Error al completar actividad: $e');
    }
  }

  Future<void> toggleFavoriteActivity(String activityId) async {
    final updatedUser = _currentUser.toggleFavorite(activityId);
    updateUser(updatedUser);
  }

  bool isActivityCompleted(String activityId) {
    return _currentUser.completedActivityIds.contains(activityId);
  }

  bool isActivityFavorite(String activityId) {
    return _currentUser.favoriteActivityIds.contains(activityId);
  }

  // Gestión del historial de actividades
  Future<List<CompletedActivity>> getCompletedActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activitiesJson = prefs.getStringList(_completedActivitiesKey) ?? [];

      return activitiesJson.map((json) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return CompletedActivity.fromJson(map);
      }).toList();
    } catch (e) {
      print('Error al obtener actividades completadas: $e');
      return [];
    }
  }

  Future<void> _saveCompletedActivity(String activityId, int points) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentActivities = await getCompletedActivities();

      final newActivity = CompletedActivity(
        id: '${DateTime.now().millisecondsSinceEpoch}_$activityId',
        activityId: activityId,
        userId: _currentUser.id,
        completedAt: DateTime.now(),
        pointsEarned: points,
      );

      final updatedActivities = [...currentActivities, newActivity];
      final activitiesJson =
          updatedActivities.map((a) => jsonEncode(a.toJson())).toList();

      await prefs.setStringList(_completedActivitiesKey, activitiesJson);
    } catch (e) {
      print('Error al guardar actividad completada: $e');
    }
  }

  // Obtener estadísticas del usuario
  Future<ActivityStats> getUserStats() async {
    try {
      final completedActivities = await getCompletedActivities();

      if (completedActivities.isEmpty) {
        return _getDefaultStats();
      }

      return _calculateStats(completedActivities);
    } catch (e) {
      print('Error al obtener estadísticas: $e');
      return _getDefaultStats();
    }
  }

  ActivityStats _getDefaultStats() {
    return ActivityStats(
      userId: _currentUser.id,
      totalActivities: 0,
      totalPoints: _currentUser.totalPoints,
      activitiesByCategory: {},
      activitiesByDay: {},
      mostActiveCategory: 'Cultivo',
      mostActiveDay: 'Hoy',
      averageTimeSpent: const Duration(minutes: 10),
      currentStreak: 0,
      longestStreak: 0,
      activitiesByDifficulty: {},
    );
  }

  ActivityStats _calculateStats(List<CompletedActivity> completedActivities) {
    final activitiesByCategory = <String, int>{};
    final activitiesByDay = <String, int>{};
    final activitiesByDifficulty = <ActivityDifficulty, int>{};

    // Obtener todas las actividades disponibles
    final allActivities = ActivityUtils.getSampleActivities();

    for (final activity in completedActivities) {
      // Buscar detalles de la actividad
      final activityDetails = allActivities.firstWhere(
        (a) => a.id == activity.activityId,
        orElse: () => allActivities.first,
      );

      // Contar por categoría
      final category = activityDetails.displayCategory;
      activitiesByCategory[category] =
          (activitiesByCategory[category] ?? 0) + 1;

      // Contar por día
      final day = activity.completedAt.toIso8601String().split('T').first;
      activitiesByDay[day] = (activitiesByDay[day] ?? 0) + 1;

      // Contar por dificultad
      activitiesByDifficulty[activityDetails.difficulty] =
          (activitiesByDifficulty[activityDetails.difficulty] ?? 0) + 1;
    }

    // Calcular categoría más activa
    String mostActiveCategory = '';
    int maxCount = 0;
    activitiesByCategory.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostActiveCategory = category;
      }
    });

    // Calcular rachas
    final dates = activitiesByDay.keys.map(DateTime.parse).toList();
    dates.sort();

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? lastDate;

    for (final date in dates) {
      if (lastDate == null || date.difference(lastDate).inDays == 1) {
        tempStreak++;
      } else {
        tempStreak = 1;
      }

      if (tempStreak > longestStreak) {
        longestStreak = tempStreak;
      }

      lastDate = date;
    }

    currentStreak = tempStreak;

    return ActivityStats(
      userId: _currentUser.id,
      totalActivities: completedActivities.length,
      totalPoints: _currentUser.totalPoints,
      activitiesByCategory: activitiesByCategory,
      activitiesByDay: activitiesByDay,
      mostActiveCategory:
          mostActiveCategory.isNotEmpty ? mostActiveCategory : 'Cultivo',
      mostActiveDay:
          activitiesByDay.isNotEmpty ? activitiesByDay.keys.last : 'Hoy',
      averageTimeSpent: const Duration(minutes: 12),
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      activitiesByDifficulty: activitiesByDifficulty,
    );
  }

  // Limpiar datos de usuario
  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userPrefsKey);
      await prefs.remove(_completedActivitiesKey);

      // Restablecer usuario predeterminado
      _currentUser = UserModel.defaultUser();
      _notifyListeners();
    } catch (e) {
      print('Error al limpiar datos de usuario: $e');
    }
  }

  // Métodos para copiar avatares predeterminados
  Future<String> copyAssetAvatarToLocal(String assetPath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = assetPath.split('/').last;
      final localPath = '${directory.path}/avatars/$fileName';

      // Crear directorio si no existe
      final avatarDir = Directory('${directory.path}/avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }

      // Copiar archivo desde assets
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();

      final file = File(localPath);
      await file.writeAsBytes(bytes);

      return localPath;
    } catch (e) {
      print('Error al copiar avatar: $e');
      return assetPath; // Devolver path original si falla
    }
  }
}
