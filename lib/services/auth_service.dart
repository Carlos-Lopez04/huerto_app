import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_model.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    await _initPrefs();

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: loginData.email,
        password: loginData.password,
      );

      final user = cred.user;

      if (user == null) {
        return {'success': false, 'error': 'Usuario no encontrado'};
      }

      if (!user.emailVerified) {
        return {'success': false, 'error': 'Debes verificar tu correo'};
      }

      final doc = await _db.collection('usuarios').doc(user.uid).get();
      final data = doc.data();

      final userModel = UserModel(
        id: user.uid,
        name: data?['nombre'] ?? '',
        email: user.email ?? loginData.email,
        gender: data?['gender'] == 'femenino'
            ? UserGender.femenino
            : UserGender.masculino,
        totalPoints: data?['totalPoints'] ?? 0,
        level: data?['level'] ?? 1,
        completedActivityIds:
            List<String>.from(data?['completedActivities'] ?? const []),
        favoriteActivityIds:
            List<String>.from(data?['favoriteActivities'] ?? const []),
        createdAt: DateTime.now(),
      );

      final token = user.uid;
      await _saveSession(token, userModel, loginData.rememberMe);

      return {
        'success': true,
        'user': userModel,
        'token': token,
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _mapFirebaseAuthError(e)};
    } on FirebaseException catch (e) {
      return {'success': false, 'error': _mapFirebaseCoreError(e)};
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
      return {'success': false, 'error': 'Email invalido'};
    }

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user != null) {
        await user.sendEmailVerification();

        await _db.collection('usuarios').doc(user.uid).set({
          'nombre': name,
          'correo': email,
          'gender': gender == UserGender.femenino ? 'femenino' : 'masculino',
          'totalPoints': 0,
          'level': 1,
          'completedActivities': [],
          'favoriteActivities': [],
          'fecha_registro': DateTime.now(),
        });

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

        await _saveSession(user.uid, userModel, false);
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

  Future<void> _saveSession(String token, UserModel user, bool rememberMe) async {
    await _initPrefs();
    await _prefs?.setString(_tokenKey, token);
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs?.setBool(_rememberMeKey, rememberMe);
  }

  Future<bool> isLoggedIn() async {
    try {
      return _auth.currentUser != null;
    } on FirebaseException {
      return false;
    }
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
      return 'Firebase no esta configurado todavia. Revisa la conexion del proyecto.';
    }

    return error.message ?? 'Error de conexion con Firebase';
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'El correo no tiene un formato valido';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contrasena incorrectos';
      case 'email-already-in-use':
        return 'Ese correo ya esta registrado';
      case 'weak-password':
        return 'La contrasena es demasiado debil';
      case 'user-disabled':
        return 'Esta cuenta fue deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta de nuevo mas tarde';
      case 'network-request-failed':
        return 'No se pudo conectar a internet';
      default:
        return error.message ?? 'Error de autenticacion';
    }
  }
}
