import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_model.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';

  // Cuenta de administrador local para DESARROLLO (solo modo debug).
  // Funciona sin configuracion, pero puede sobrescribirse al compilar con:
  //   flutter run --dart-define=HUERTO_ADMIN_EMAIL=... \
  //               --dart-define=HUERTO_ADMIN_PASSWORD=...
  // En builds release (kDebugMode == false) esta cuenta NO existe.
  static const String _dartAdminEmail =
      String.fromEnvironment('HUERTO_ADMIN_EMAIL');
  static const String _dartAdminPassword =
      String.fromEnvironment('HUERTO_ADMIN_PASSWORD');
  static const String _defaultAdminEmail = 'admin@uabc.edu.mx';
  static const String _defaultAdminPassword = '141820';

  // Credenciales efectivas: dart-define si se definio, si no, el valor local.
  static String get _adminEmail =>
      _dartAdminEmail.isNotEmpty ? _dartAdminEmail : _defaultAdminEmail;
  static String get _adminPassword =>
      _dartAdminPassword.isNotEmpty ? _dartAdminPassword : _defaultAdminPassword;
  static const String _localAdminId = 'local_admin';

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    await _initPrefs();

    if (kDebugMode && _isLocalAdmin(loginData)) {
      return _loginLocalAdmin(loginData.rememberMe);
    }

    try {
      // La sesion solo se conserva entre arranques si se marco "Recordarme".
      await _auth.setPersistence(
        loginData.rememberMe ? Persistence.LOCAL : Persistence.NONE,
      );

      final cred = await _auth
          .signInWithEmailAndPassword(
            email: loginData.email,
            password: loginData.password,
          )
          .timeout(const Duration(seconds: 20));

      final user = cred.user;

      if (user == null) {
        return {'success': false, 'error': 'Usuario no encontrado'};
      }

      if (!user.emailVerified) {
        return {'success': false, 'error': 'Debes verificar tu correo'};
      }

      final doc = await _db
          .collection('usuarios')
          .doc(user.uid)
          .get()
          .timeout(const Duration(seconds: 20));
      final data = doc.data();

      // Carga el perfil completo (nuevo formato) o migra el formato antiguo.
      final userModel = _userFromFirestoreData(
        data,
        id: user.uid,
        email: user.email ?? loginData.email,
      );

      final token = user.uid;
      await _saveSession(token, userModel, loginData.rememberMe);

      // Sincroniza el estado global de la app con el perfil cargado.
      UserService().updateUser(userModel);

      return {
        'success': true,
        'user': userModel,
        'token': token,
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _mapFirebaseAuthError(e)};
    } on FirebaseException catch (e) {
      return {'success': false, 'error': _mapFirebaseCoreError(e)};
    } on TimeoutException {
      return {
        'success': false,
        'error':
            'La conexión tardó demasiado. Verifica tu internet e intenta de nuevo.',
      };
    } catch (e) {
      debugPrint('Error inesperado en login: $e');
      return {
        'success': false,
        'error': 'No se pudo iniciar sesión. Intenta de nuevo.',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserGender gender,
  }) async {
    await _initPrefs();

    if (!_isValidEmail(email)) {
      return {'success': false, 'error': 'Email inválido'};
    }

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email,
          gender: gender,
          totalPoints: 0,
          level: 1,
          completedActivityIds: const [],
          favoriteActivityIds: const [],
          createdAt: DateTime.now(),
        );

        await user.sendEmailVerification();

        // Guarda el perfil completo en Firestore.
        await _db.collection('usuarios').doc(user.uid).set(userModel.toJson());

        await _saveSession(user.uid, userModel, false);
        UserService().updateUser(userModel);
      }

      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _mapFirebaseAuthError(e)};
    } on FirebaseException catch (e) {
      return {'success': false, 'error': _mapFirebaseCoreError(e)};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    await _initPrefs();

    await _auth.signOut();
    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_userKey);
    await _prefs?.remove(_rememberMeKey);

    return {'success': true};
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _mapFirebaseAuthError(e)};
    } on FirebaseException catch (e) {
      return {'success': false, 'error': _mapFirebaseCoreError(e)};
    } catch (_) {
      return {'success': false, 'error': 'Error al enviar correo'};
    }
  }

  /// Construye un [UserModel] desde los datos de Firestore.
  /// Soporta el nuevo formato (claves en inglés via `toJson`) y migra el
  /// formato antiguo (claves en español) por compatibilidad.
  UserModel _userFromFirestoreData(
    Map<String, dynamic>? data, {
    required String id,
    required String email,
  }) {
    if (data == null || data.isEmpty) {
      return UserModel(
        id: id,
        name: '',
        email: email,
        gender: UserGender.masculino,
        createdAt: DateTime.now(),
      );
    }

    if (data['name'] != null) {
      return UserModel.fromJson(data).copyWith(id: id, email: email);
    }

    // Formato antiguo (claves en español)
    return UserModel(
      id: id,
      name: data['nombre'] ?? '',
      email: email,
      gender: data['gender'] == 'femenino'
          ? UserGender.femenino
          : UserGender.masculino,
      totalPoints: data['totalPoints'] ?? 0,
      level: data['level'] ?? 1,
      completedActivityIds:
          List<String>.from(data['completedActivities'] ?? const []),
      favoriteActivityIds:
          List<String>.from(data['favoriteActivities'] ?? const []),
      createdAt: DateTime.now(),
    );
  }

  bool _isLocalAdmin(LoginModel loginData) {
    if (!kDebugMode) return false;
    if (_adminEmail.isEmpty || _adminPassword.isEmpty) return false;
    return loginData.email.trim().toLowerCase() ==
            _adminEmail.trim().toLowerCase() &&
        loginData.password == _adminPassword;
  }

  Future<Map<String, dynamic>> _loginLocalAdmin(bool rememberMe) async {
    final admin = UserModel(
      id: _localAdminId,
      name: 'Administrador',
      email: _adminEmail,
      gender: UserGender.masculino,
      createdAt: DateTime.now(),
      isAdmin: true,
    );

    await _saveSession(admin.id, admin, rememberMe);

    return {
      'success': true,
      'user': admin,
      'token': admin.id,
      'isAdmin': true,
    };
  }

  Future<void> _saveSession(String token, UserModel user, bool rememberMe) async {
    await _initPrefs();
    await _prefs?.setString(_tokenKey, token);
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs?.setBool(_rememberMeKey, rememberMe);
  }

  Future<bool> isLoggedIn() async {
    await _initPrefs();
    final rememberMe = _prefs?.getBool(_rememberMeKey) ?? false;
    final token = _prefs?.getString(_tokenKey);

    // Sesion local de administrador (solo desarrollo y con "Recordarme").
    if (kDebugMode && token == _localAdminId && rememberMe) {
      return true;
    }

    try {
      if (_auth.currentUser != null && rememberMe) {
        return true;
      }
    } on FirebaseException {
      // Firebase no disponible: solo se permitio la sesion local de admin.
    }

    return false;
  }

  Future<UserModel?> getCurrentUser() async {
    await _initPrefs();
    final userJson = _prefs?.getString(_userKey);

    if (userJson == null) {
      return null;
    }

    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<bool> updateUserPoints(String uid, int points) async {
    try {
      final ref = _db.collection('usuarios').doc(uid);
      await ref.update({'totalPoints': FieldValue.increment(points)});
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String _mapFirebaseCoreError(FirebaseException error) {
    if (error.code == 'no-app') {
      return 'Firebase no está configurado todavía. Revisa la conexión del proyecto.';
    }

    return error.message ?? 'Error de conexión con Firebase';
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'El correo no tiene un formato válido';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';
      case 'email-already-in-use':
        return 'Ese correo ya está registrado';
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'user-disabled':
        return 'Esta cuenta fue deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta de nuevo más tarde';
      case 'network-request-failed':
        return 'No se pudo conectar a internet';
      default:
        return error.message ?? 'Error de autenticación';
    }
  }
}
