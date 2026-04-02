import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/login_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';
  
  // Configuración del backend - CAMBIAR SEGÚN TU SERVIDOR
  static const String _baseUrl = 'https://tu-backend.com/api'; // ← Cambiar por tu URL real
  static const int _timeoutSeconds = 30;
  
  SharedPreferences? _prefs;
  
  // Inicializar SharedPreferences
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  // ========== MÉTODOS DE AUTENTICACIÓN ==========
  
  // Login con email y contraseña
  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    await _initPrefs();
    
    try {
      if (kDebugMode) {
        print('🔐 Intentando login para: ${loginData.email}');
      }
      
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(loginData.toJson()),
      ).timeout(Duration(seconds: _timeoutSeconds));
      
      if (kDebugMode) {
        print('📡 Respuesta código: ${response.statusCode}');
      }
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['success'] == true || data['status'] == 'success') {
          final user = UserModel.fromJson(data['user'] ?? data['data']['user']);
          final token = data['token'] ?? data['data']['token'];
          
          // Guardar sesión
          await _saveSession(token, user, loginData.rememberMe);
          
          if (kDebugMode) {
            print('✅ Login exitoso para: ${user.name}');
          }
          
          return {
            'success': true,
            'user': user,
            'token': token,
            'message': data['message'] ?? 'Login exitoso',
          };
        } else {
          return {
            'success': false,
            'error': data['message'] ?? 'Credenciales incorrectas',
          };
        }
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Email o contraseña incorrectos',
        };
      } else {
        return {
          'success': false,
          'error': 'Error del servidor (${response.statusCode})',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error de conexión: $e');
      }
      return {
        'success': false,
        'error': 'Error de conexión. Verifica tu internet.',
      };
    }
  }
  
  // Registrar nuevo usuario
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserGender gender,
  }) async {
    await _initPrefs();
    
    try {
      if (kDebugMode) {
        print('📝 Registrando usuario: $email');
      }
      
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'gender': gender == UserGender.masculino ? 'masculino' : 'femenino',
        }),
      ).timeout(Duration(seconds: _timeoutSeconds));
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['success'] == true || data['status'] == 'success') {
          final user = UserModel.fromJson(data['user'] ?? data['data']['user']);
          final token = data['token'] ?? data['data']['token'];
          
          // Guardar sesión automáticamente después del registro
          await _saveSession(token, user, false);
          
          if (kDebugMode) {
            print('✅ Usuario registrado: ${user.name}');
          }
          
          return {
            'success': true,
            'user': user,
            'token': token,
            'message': data['message'] ?? 'Registro exitoso',
          };
        } else {
          return {
            'success': false,
            'error': data['message'] ?? 'Error en el registro',
            'errors': data['errors'],
          };
        }
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final errors = data['errors'];
        String errorMessage = '';
        
        if (errors != null) {
          if (errors['email'] != null) {
            errorMessage = errors['email'][0];
          } else if (errors['password'] != null) {
            errorMessage = errors['password'][0];
          } else if (errors['name'] != null) {
            errorMessage = errors['name'][0];
          }
        }
        
        return {
          'success': false,
          'error': errorMessage.isEmpty ? 'Datos inválidos' : errorMessage,
          'errors': errors,
        };
      } else {
        return {
          'success': false,
          'error': 'Error en el registro (${response.statusCode})',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error de conexión: $e');
      }
      return {
        'success': false,
        'error': 'Error de conexión. Verifica tu internet.',
      };
    }
  }
  
  // Cerrar sesión
  Future<Map<String, dynamic>> logout() async {
    await _initPrefs();
    
    final token = _prefs?.getString(_tokenKey);
    
    if (token != null && token.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));
        
        if (kDebugMode) {
          print('📡 Logout código: ${response.statusCode}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error en logout remoto: $e');
        }
      }
    }
    
    // Limpiar sesión local
    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_userKey);
    await _prefs?.remove(_rememberMeKey);
    
    return {
      'success': true,
      'message': 'Sesión cerrada correctamente',
    };
  }
  
  // ========== MÉTODOS DE SESIÓN ==========
  
  // Guardar sesión
  Future<void> _saveSession(String token, UserModel user, bool rememberMe) async {
    await _prefs?.setString(_tokenKey, token);
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs?.setBool(_rememberMeKey, rememberMe);
  }
  
  // Verificar si hay sesión activa
  Future<bool> isLoggedIn() async {
    await _initPrefs();
    final token = _prefs?.getString(_tokenKey);
    final rememberMe = _prefs?.getBool(_rememberMeKey) ?? false;
    
    // Si no hay token, no hay sesión
    if (token == null || token.isEmpty) {
      return false;
    }
    
    // Si no está marcado "Recordarme", validar con el servidor
    if (!rememberMe) {
      return await _validateToken(token);
    }
    
    return true;
  }
  
  // Validar token con el servidor
  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/validate-token'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error validando token: $e');
      }
      return false;
    }
  }
  
  // Obtener usuario actual
  Future<UserModel?> getCurrentUser() async {
    await _initPrefs();
    final userJson = _prefs?.getString(_userKey);
    
    if (userJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(userJson);
        return UserModel.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  // Actualizar usuario en sesión local
  Future<void> updateLocalUser(UserModel user) async {
    await _initPrefs();
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
  }
  
  // Obtener token actual
  Future<String?> getToken() async {
    await _initPrefs();
    return _prefs?.getString(_tokenKey);
  }
  
  // ========== MÉTODOS DE PERFIL ==========
  
  // Obtener perfil del usuario desde el servidor
  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    
    if (token == null) {
      return {
        'success': false,
        'error': 'No hay sesión activa',
      };
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: _timeoutSeconds));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final user = UserModel.fromJson(data['user'] ?? data['data']);
        
        // Actualizar usuario local
        await updateLocalUser(user);
        
        return {
          'success': true,
          'user': user,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al obtener perfil',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión',
      };
    }
  }
  
  // Actualizar perfil
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required UserGender gender,
  }) async {
    final token = await getToken();
    
    if (token == null) {
      return {
        'success': false,
        'error': 'No hay sesión activa',
      };
    }
    
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'gender': gender == UserGender.masculino ? 'masculino' : 'femenino',
        }),
      ).timeout(Duration(seconds: _timeoutSeconds));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final user = UserModel.fromJson(data['user'] ?? data['data']);
        
        // Actualizar usuario local
        await updateLocalUser(user);
        
        return {
          'success': true,
          'user': user,
          'message': 'Perfil actualizado',
        };
      } else {
        return {
          'success': false,
          'error': 'Error al actualizar perfil',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión',
      };
    }
  }
  
  // Cambiar contraseña
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await getToken();
    
    if (token == null) {
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
        'error': 'La contraseña debe tener al menos 6 caracteres',
      };
    }
    
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        }),
      ).timeout(Duration(seconds: _timeoutSeconds));
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Contraseña actualizada',
        };
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          'success': false,
          'error': data['message'] ?? 'Error en la validación',
        };
      } else {
        return {
          'success': false,
          'error': 'Error al cambiar contraseña',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión',
      };
    }
  }
  
  // ========== MÉTODOS DE RECUPERACIÓN ==========
  
  // Recuperar contraseña (enviar email)
  Future<Map<String, dynamic>> resetPassword(String email) async {
    if (!_isValidEmail(email)) {
      return {
        'success': false,
        'error': 'Email inválido',
      };
    }
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      ).timeout(Duration(seconds: _timeoutSeconds));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Se enviaron instrucciones a tu email',
        };
      } else {
        return {
          'success': false,
          'error': 'No se encontró una cuenta con ese email',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión',
      };
    }
  }
  
  // ========== MÉTODOS AUXILIARES ==========
  
  // Validar email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}