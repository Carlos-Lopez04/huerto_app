import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/login_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';
  static const String _usersKey = 'registered_users';
  
  SharedPreferences? _prefs;
  
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  // ========== MÉTODOS DE AUTENTICACIÓN ==========
  
  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    await _initPrefs();
    
    if (kDebugMode) {
      print('🔐 Intentando login para: ${loginData.email}');
    }
    
    final users = await _getRegisteredUsers();
    
    if (users.isEmpty) {
      users['test@test.com'] = {
        'password': '123456',
        'name': 'Usuario Test',
        'gender': 'masculino',
      };
      await _saveRegisteredUsers(users);
    }
    
    final userData = users[loginData.email];
    
    if (userData != null && userData['password'] == loginData.password) {
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: userData['name'] ?? loginData.email.split('@')[0],
        email: loginData.email,
        gender: userData['gender'] == 'femenino' 
            ? UserGender.femenino 
            : UserGender.masculino,
        totalPoints: userData['totalPoints'] ?? 0,
        level: userData['level'] ?? 1,
        completedActivityIds: userData['completedActivities'] != null 
            ? List<String>.from(userData['completedActivities']) 
            : [],
        favoriteActivityIds: userData['favoriteActivities'] != null 
            ? List<String>.from(userData['favoriteActivities']) 
            : [],
        createdAt: DateTime.now(), // ← Agregar createdAt
      );
      
      final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
      await _saveSession(token, user, loginData.rememberMe);
      
      if (kDebugMode) {
        print('✅ Login exitoso para: ${user.name}');
      }
      
      return {
        'success': true,
        'user': user,
        'token': token,
        'message': 'Login exitoso',
      };
    }
    
    return {
      'success': false,
      'error': 'Email o contraseña incorrectos',
    };
  }
  
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserGender gender,
  }) async {
    await _initPrefs();
    
    if (kDebugMode) {
      print('📝 Registrando usuario: $email');
    }
    
    if (name.isEmpty) {
      return {'success': false, 'error': 'El nombre es requerido'};
    }
    
    if (email.isEmpty || !_isValidEmail(email)) {
      return {'success': false, 'error': 'Email inválido'};
    }
    
    if (password.length < 6) {
      return {'success': false, 'error': 'La contraseña debe tener al menos 6 caracteres'};
    }
    
    final users = await _getRegisteredUsers();
    
    if (users.containsKey(email)) {
      return {
        'success': false,
        'error': 'Este email ya está registrado',
      };
    }
    
    users[email] = {
      'password': password,
      'name': name,
      'gender': gender == UserGender.femenino ? 'femenino' : 'masculino',
      'totalPoints': 0,
      'level': 1,
      'completedActivities': [],
      'favoriteActivities': [],
      'registeredAt': DateTime.now().toIso8601String(),
    };
    
    await _saveRegisteredUsers(users);
    
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      gender: gender,
      totalPoints: 0,
      level: 1,
      completedActivityIds: [],
      favoriteActivityIds: [],
      createdAt: DateTime.now(), // ← Agregar createdAt
    );
    
    final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
    await _saveSession(token, user, false);
    
    if (kDebugMode) {
      print('✅ Usuario registrado: $name ($email)');
    }
    
    return {
      'success': true,
      'user': user,
      'token': token,
      'message': 'Registro exitoso. ¡Bienvenido!',
    };
  }
  
  Future<Map<String, dynamic>> logout() async {
    await _initPrefs();
    
    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_userKey);
    await _prefs?.remove(_rememberMeKey);
    
    return {
      'success': true,
      'message': 'Sesión cerrada correctamente',
    };
  }
  
  // ========== MÉTODOS DE GESTIÓN DE USUARIOS ==========
  
  Future<Map<String, Map<String, dynamic>>> _getRegisteredUsers() async {
    await _initPrefs();
    final usersJson = _prefs?.getString(_usersKey);
    
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(usersJson);
        final Map<String, Map<String, dynamic>> result = {};
        
        decoded.forEach((key, value) {
          result[key] = Map<String, dynamic>.from(value);
        });
        
        return result;
      } catch (e) {
        return {};
      }
    }
    
    return {};
  }
  
  Future<void> _saveRegisteredUsers(Map<String, Map<String, dynamic>> users) async {
    await _initPrefs();
    await _prefs?.setString(_usersKey, jsonEncode(users));
  }
  
  Future<bool> updateUserPoints(String email, int pointsToAdd) async {
    await _initPrefs();
    
    final users = await _getRegisteredUsers();
    
    if (users.containsKey(email)) {
      final currentPoints = users[email]?['totalPoints'] ?? 0;
      final currentLevel = users[email]?['level'] ?? 1;
      
      users[email]?['totalPoints'] = currentPoints + pointsToAdd;
      
      final newLevel = ((currentPoints + pointsToAdd) / 100).floor() + 1;
      if (newLevel > currentLevel) {
        users[email]?['level'] = newLevel;
      }
      
      await _saveRegisteredUsers(users);
      
      final currentUser = await getCurrentUser();
      if (currentUser != null && currentUser.email == email) {
        final updatedUser = UserModel(
          id: currentUser.id,
          name: currentUser.name,
          email: currentUser.email,
          gender: currentUser.gender,
          totalPoints: currentPoints + pointsToAdd,
          level: newLevel,
          completedActivityIds: currentUser.completedActivityIds,
          favoriteActivityIds: currentUser.favoriteActivityIds,
          createdAt: currentUser.createdAt, // ← Agregar createdAt
        );
        
        final token = await getToken();
        if (token != null) {
          await _saveSession(token, updatedUser, true);
        }
      }
      
      return true;
    }
    
    return false;
  }
  
  Future<bool> addCompletedActivity(String email, String activityId) async {
    await _initPrefs();
    
    final users = await _getRegisteredUsers();
    
    if (users.containsKey(email)) {
      List<String> completedActivities = [];
      if (users[email]?.containsKey('completedActivities') == true) {
        completedActivities = List<String>.from(users[email]?['completedActivities'] ?? []);
      }
      
      if (!completedActivities.contains(activityId)) {
        completedActivities.add(activityId);
        users[email]?['completedActivities'] = completedActivities;
        await _saveRegisteredUsers(users);
      }
      
      return true;
    }
    
    return false;
  }
  
  // ========== MÉTODOS DE SESIÓN ==========
  
  Future<void> _saveSession(String token, UserModel user, bool rememberMe) async {
    await _initPrefs();
    await _prefs?.setString(_tokenKey, token);
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs?.setBool(_rememberMeKey, rememberMe);
  }
  
  Future<bool> isLoggedIn() async {
    await _initPrefs();
    final token = _prefs?.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }
  
  Future<UserModel?> getCurrentUser() async {
    await _initPrefs();
    final userJson = _prefs?.getString(_userKey);
    
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(userJson);
        return UserModel.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  Future<void> updateLocalUser(UserModel user) async {
    await _initPrefs();
    final token = await getToken();
    if (token != null) {
      await _saveSession(token, user, true);
    }
  }
  
  Future<String?> getToken() async {
    await _initPrefs();
    return _prefs?.getString(_tokenKey);
  }
  
  // ========== MÉTODOS DE PERFIL ==========
  
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required UserGender gender,
  }) async {
    await _initPrefs();
    
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      return {
        'success': false,
        'error': 'No hay sesión activa',
      };
    }
    
    final users = await _getRegisteredUsers();
    if (users.containsKey(currentUser.email)) {
      users[currentUser.email]?['name'] = name;
      users[currentUser.email]?['gender'] = gender == UserGender.femenino ? 'femenino' : 'masculino';
      await _saveRegisteredUsers(users);
    }
    
    final updatedUser = UserModel(
      id: currentUser.id,
      name: name,
      email: currentUser.email,
      gender: gender,
      totalPoints: currentUser.totalPoints,
      level: currentUser.level,
      completedActivityIds: currentUser.completedActivityIds,
      favoriteActivityIds: currentUser.favoriteActivityIds,
      createdAt: currentUser.createdAt, // ← Agregar createdAt
    );
    
    final token = await getToken();
    if (token != null) {
      await _saveSession(token, updatedUser, true);
    }
    
    return {
      'success': true,
      'user': updatedUser,
      'message': 'Perfil actualizado',
    };
  }
  
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _initPrefs();
    
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      return {
        'success': false,
        'error': 'No hay sesión activa',
      };
    }
    
    if (newPassword != confirmPassword) {
      return {
        'success': false,
        'error': 'Las contraseñas no coinciden',
      };
    }
    
    if (newPassword.length < 6) {
      return {
        'success': false,
        'error': 'La nueva contraseña debe tener al menos 6 caracteres',
      };
    }
    
    final users = await _getRegisteredUsers();
    final userData = users[currentUser.email];
    
    if (userData == null || userData['password'] != currentPassword) {
      return {
        'success': false,
        'error': 'Contraseña actual incorrecta',
      };
    }
    
    users[currentUser.email]?['password'] = newPassword;
    await _saveRegisteredUsers(users);
    
    return {
      'success': true,
      'message': 'Contraseña actualizada correctamente',
    };
  }
  
  Future<Map<String, dynamic>> resetPassword(String email) async {
    await _initPrefs();
    
    if (!_isValidEmail(email)) {
      return {
        'success': false,
        'error': 'Email inválido',
      };
    }
    
    final users = await _getRegisteredUsers();
    
    if (users.containsKey(email)) {
      return {
        'success': true,
        'message': 'Se enviaron instrucciones de recuperación a $email',
      };
    }
    
    return {
      'success': false,
      'error': 'No se encontró una cuenta con ese email',
    };
  }
  
  Future<Map<String, dynamic>> getUserStats() async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      return {
        'success': false,
        'error': 'No hay sesión activa',
      };
    }
    
    return {
      'success': true,
      'stats': {
        'totalPoints': currentUser.totalPoints,
        'level': currentUser.level,
        'completedActivities': currentUser.completedActivityIds.length,
        'favoriteActivities': currentUser.favoriteActivityIds.length,
        'pointsToNextLevel': 100 - (currentUser.totalPoints % 100),
      },
    };
  }
  
  // ========== MÉTODOS AUXILIARES ==========
  
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}