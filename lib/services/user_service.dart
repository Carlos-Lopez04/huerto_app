// services/user_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/activity_model.dart' hide UserGender;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // Instancia única de la clase (MiCuenta)
  static final UserService _instance = UserService._internal();
  // Factory constructor para obtener la instancia
  factory UserService() => _instance;
  // Constructor privado para evitar instanciación externa
  UserService._internal();

  /*
    CONSTANTES PARA PREFERENCIAS
  */

  // Clave para almacenar perfil de usuario en SharedPreferences
  static const String _userPrefsKey = 'user_profile';
  // Clave para almacenar actividades completadas
  static const String _completedActivitiesKey = 'completed_activities';

  /*
    VARIABLES DE INSTANCIA
  */

  // Usuario actual de la aplicación
  UserModel _currentUser = UserModel.defaultUser();

  // Getter para acceder al usuario actual
  UserModel get currentUser => _currentUser;

  /*
    SISTEMA DE NOTIFICACIÓN EN TIEMPO REAL
  */

  // Lista de listeners (observadores) para cambios en el usuario
  final List<Function(UserModel)> _listeners = [];

  // Método para agregar un listener
  void addListener(Function(UserModel) listener) {
    _listeners.add(listener);
  }

  // Método para remover un listener
  void removeListener(Function(UserModel) listener) {
    _listeners.remove(listener);
  }

  // Notificar a todos los listeners sobre cambios
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_currentUser); // Llamar a cada listener
    }
  }

  /*
    MÉTODO PRINCIPAL PARA ACTUALIZAR USUARIO
  */

  // Actualizar usuario y notificar a todos los listeners
  void updateUser(UserModel newUser) {
    _currentUser = newUser; // Actualizar usuario
    _notifyListeners(); // Notificar listeners
    _saveUserToPrefs(newUser); // Persistir en almacenamiento
  }

  /*
    CARGAR USUARIO DESDE PREFERENCIAS
  */

  // Cargar usuario desde SharedPreferences
  Future<void> loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance(); // Obtener instancia
      final userJson = prefs.getString(_userPrefsKey); // Leer JSON almacenado

      if (userJson != null) {
        final userMap =
            jsonDecode(userJson) as Map<String, dynamic>; // Decodificar
        final loadedUser =
            UserModel.fromJson(userMap); // Crear objeto UserModel
        _currentUser = loadedUser; // Actualizar usuario actual
        _notifyListeners(); // Notificar listeners
      }
    } catch (e) {
      print('Error al cargar usuario: $e'); // Manejar error
    }
  }

  /*
    GUARDAR USUARIO EN PREFERENCIAS
  */

  // Guardar usuario en SharedPreferences (método privado)
  Future<void> _saveUserToPrefs(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance(); // Obtener instancia
      final userJson = jsonEncode(user.toJson()); // Convertir a JSON
      await prefs.setString(
          _userPrefsKey, userJson); // Guardar en almacenamiento
    } catch (e) {
      print('Error al guardar usuario: $e'); // Manejar error
    }
  }

  /*
    MÉTODOS PARA MANEJO DE AVATAR
  */

  // Actualizar género del avatar del usuario
  Future<void> updateUserGender(UserGender gender) async {
    final updatedUser =
        _currentUser.copyWith(gender: gender); // Crear copia actualizada
    updateUser(updatedUser); // Actualizar usuario
  }

  // Cambiar estilo del avatar
  Future<void> updateAvatarStyle(String style) async {
    final updatedUser = _currentUser.changeAvatarStyle(style); // Cambiar estilo
    updateUser(updatedUser); // Actualizar usuario
  }

  // Personalizar avatar con opciones específicas
  Future<void> customizeAvatar({
    Color? skinColor, // Color de piel
    Color? hairColor, // Color de cabello
    Color? eyeColor, // Color de ojos
    bool? hasGlasses, // Usa lentes
    String? accessory, // Accesorio
  }) async {
    final updatedUser = _currentUser.customizeAvatar(
      skinColor: skinColor,
      hairColor: hairColor,
      eyeColor: eyeColor,
      hasGlasses: hasGlasses,
      accessory: accessory,
    );
    updateUser(updatedUser); // Actualizar usuario
  }

  /*
    MÉTODOS PARA ACTIVIDADES
  */

  // Completar una actividad y otorgar puntos
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
      print('Error al completar actividad: $e'); // Manejar error
    }
  }

  // Alternar actividad como favorita
  Future<void> toggleFavoriteActivity(String activityId) async {
    final updatedUser =
        _currentUser.toggleFavorite(activityId); // Cambiar estado favorito
    updateUser(updatedUser); // Actualizar usuario
  }

  // Verificar si actividad está completada
  bool isActivityCompleted(String activityId) {
    return _currentUser.completedActivityIds.contains(activityId);
  }

  // Verificar si actividad es favorita
  bool isActivityFavorite(String activityId) {
    return _currentUser.favoriteActivityIds.contains(activityId);
  }

  /*
    GESTIÓN DEL HISTORIAL DE ACTIVIDADES
  */

  // Obtener lista de actividades completadas
  Future<List<CompletedActivity>> getCompletedActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activitiesJson = prefs.getStringList(_completedActivitiesKey) ?? [];

      // Convertir cada string JSON a objeto CompletedActivity
      return activitiesJson.map((json) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return CompletedActivity.fromJson(map);
      }).toList();
    } catch (e) {
      print('Error al obtener actividades completadas: $e');
      return []; // Retornar lista vacía en caso de error
    }
  }

  // Guardar actividad completada en almacenamiento
  Future<void> _saveCompletedActivity(String activityId, int points) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentActivities = await getCompletedActivities();

      // Crear nueva actividad completada
      final newActivity = CompletedActivity(
        id: '${DateTime.now().millisecondsSinceEpoch}_$activityId', // ID único
        activityId: activityId,
        userId: _currentUser.id,
        completedAt: DateTime.now(), // Fecha actual
        pointsEarned: points, // Puntos obtenidos
      );

      // Agregar nueva actividad a la lista
      final updatedActivities = [...currentActivities, newActivity];
      // Convertir a JSON strings
      final activitiesJson =
          updatedActivities.map((a) => jsonEncode(a.toJson())).toList();

      // Guardar en SharedPreferences
      await prefs.setStringList(_completedActivitiesKey, activitiesJson);
    } catch (e) {
      print('Error al guardar actividad completada: $e');
    }
  }

  /*
    OBTENER ESTADÍSTICAS DEL USUARIO
  */

  // Obtener estadísticas detalladas del usuario
  Future<ActivityStats> getUserStats() async {
    try {
      final completedActivities = await getCompletedActivities();

      if (completedActivities.isEmpty) {
        return _getDefaultStats(); // Estadísticas por defecto si no hay actividades
      }

      return _calculateStats(completedActivities); // Calcular estadísticas
    } catch (e) {
      print('Error al obtener estadísticas: $e');
      return _getDefaultStats(); // Estadísticas por defecto en caso de error
    }
  }

  // Retornar estadísticas por defecto
  ActivityStats _getDefaultStats() {
    return ActivityStats(
      userId: _currentUser.id,
      totalActivities: 0,
      totalPoints: _currentUser.totalPoints,
      activitiesByCategory: {},
      activitiesByDay: {},
      mostActiveCategory: 'Cultivo', // Valor por defecto
      mostActiveDay: 'Hoy', // Valor por defecto
      averageTimeSpent: const Duration(minutes: 10),
      currentStreak: 0,
      longestStreak: 0,
      activitiesByDifficulty: {},
    );
  }

  // Calcular estadísticas basadas en actividades completadas
  ActivityStats _calculateStats(List<CompletedActivity> completedActivities) {
    // Mapas para agrupar actividades
    final activitiesByCategory = <String, int>{};
    final activitiesByDay = <String, int>{};
    final activitiesByDifficulty = <ActivityDifficulty, int>{};

    // Obtener todas las actividades disponibles
    final allActivities = ActivityUtils.getSampleActivities();

    // Procesar cada actividad completada
    for (final activity in completedActivities) {
      // Buscar detalles de la actividad
      final activityDetails = allActivities.firstWhere(
        (a) => a.id == activity.activityId,
        orElse: () =>
            allActivities.first, // Usar primera actividad como respaldo
      );

      // Contar por categoría
      final category = activityDetails.displayCategory;
      activitiesByCategory[category] =
          (activitiesByCategory[category] ?? 0) + 1;

      // Contar por día (formato YYYY-MM-DD)
      final day = activity.completedAt.toIso8601String().split('T').first;
      activitiesByDay[day] = (activitiesByDay[day] ?? 0) + 1;

      // Contar por dificultad
      activitiesByDifficulty[activityDetails.difficulty] =
          (activitiesByDifficulty[activityDetails.difficulty] ?? 0) + 1;
    }

    /*
      CALCULAR CATEGORÍA MÁS ACTIVA
    */

    String mostActiveCategory = '';
    int maxCount = 0;
    activitiesByCategory.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostActiveCategory = category;
      }
    });

    /*
      CALCULAR RACHAS DE ACTIVIDAD
    */

    final dates = activitiesByDay.keys.map(DateTime.parse).toList();
    dates.sort(); // Ordenar fechas cronológicamente

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? lastDate;

    for (final date in dates) {
      if (lastDate == null || date.difference(lastDate).inDays == 1) {
        tempStreak++; // Incrementar racha si es día consecutivo
      } else {
        tempStreak = 1; // Reiniciar racha si no es consecutivo
      }

      if (tempStreak > longestStreak) {
        longestStreak = tempStreak; // Actualizar racha más larga
      }

      lastDate = date; // Actualizar última fecha procesada
    }

    currentStreak = tempStreak; // Racha actual

    // Retornar objeto con todas las estadísticas
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

  /*
    LIMPIAR DATOS DE USUARIO
  */

  // Borrar todos los datos del usuario (para reset o pruebas)
  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userPrefsKey); // Eliminar perfil
      await prefs.remove(_completedActivitiesKey); // Eliminar historial

      // Restablecer usuario predeterminado
      _currentUser = UserModel.defaultUser();
      _notifyListeners(); // Notificar cambio
    } catch (e) {
      print('Error al limpiar datos de usuario: $e');
    }
  }

  /*
    MÉTODOS PARA COPIAR AVATARES PREDETERMINADOS
  */

  // Copiar avatar desde assets al almacenamiento local del dispositivo
  Future<String> copyAssetAvatarToLocal(String assetPath) async {
    try {
      final directory =
          await getApplicationDocumentsDirectory(); // Obtener directorio
      final fileName = assetPath.split('/').last; // Extraer nombre de archivo
      final localPath = '${directory.path}/avatars/$fileName'; // Ruta local

      // Crear directorio de avatares si no existe
      final avatarDir = Directory('${directory.path}/avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true); // Crear con subdirectorios
      }

      // Copiar archivo desde assets
      final byteData = await rootBundle.load(assetPath); // Cargar desde assets
      final bytes = byteData.buffer.asUint8List(); // Convertir a bytes

      final file = File(localPath); // Crear archivo local
      await file.writeAsBytes(bytes); // Escribir bytes al archivo

      return localPath; // Retornar ruta local del archivo copiado
    } catch (e) {
      print('Error al copiar avatar: $e');
      return assetPath; // Devolver path original si falla
    }
  }
}
