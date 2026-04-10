import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../models/login_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    await _initPrefs();

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: loginData.email,
        password: loginData.password,
      );

      final user = cred.user;

      if (user == null) {
        return {"success": false, "error": "Usuario no encontrado"};
      }

      // ⚠️ Verificar email
      if (!user.emailVerified) {
        return {
          "success": false,
          "error": "Debes verificar tu correo"
        };
      }

      // 🔥 Obtener datos de Firestore
      final doc =
          await _db.collection("usuarios").doc(user.uid).get();

      final data = doc.data();

      final userModel = UserModel(
        id: user.uid,
        name: data?["nombre"] ?? "",
        email: user.email!,
        gender: data?["gender"] == "femenino"
            ? UserGender.femenino
            : UserGender.masculino,
        totalPoints: data?["totalPoints"] ?? 0,
        level: data?["level"] ?? 1,
        completedActivityIds:
            List<String>.from(data?["completedActivities"] ?? []),
        favoriteActivityIds:
            List<String>.from(data?["favoriteActivities"] ?? []),
        createdAt: DateTime.now(),
      );

      final token = user.uid;
      await _saveSession(token, userModel, loginData.rememberMe);

      return {
        "success": true,
        "user": userModel,
        "token": token,
      };
    } on FirebaseAuthException catch (e) {
      return {
        "success": false,
        "error": e.message ?? "Error de autenticación"
      };
    }
  }

  // ================= REGISTER =================
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserGender gender,
  }) async {
    await _initPrefs();

    if (!_isValidEmail(email)) {
      return {"success": false, "error": "Email inválido"};
    }

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user != null) {
        await user.sendEmailVerification();

        // 🔥 Guardar en Firestore
        await _db.collection("usuarios").doc(user.uid).set({
          "nombre": name,
          "correo": email,
          "gender": gender == UserGender.femenino ? "femenino" : "masculino",
          "totalPoints": 0,
          "level": 1,
          "completedActivities": [],
          "favoriteActivities": [],
          "fecha_registro": DateTime.now(),
        });

        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email,
          gender: gender,
          totalPoints: 0,
          level: 1,
          completedActivityIds: [],
          favoriteActivityIds: [],
          createdAt: DateTime.now(),
        );

        await _saveSession(user.uid, userModel, false);
      }

      return {"success": true};
    } on FirebaseAuthException catch (e) {
      return {
        "success": false,
        "error": e.message ?? "Error al registrar"
      };
    }
  }

  // ================= LOGOUT =================
  Future<Map<String, dynamic>> logout() async {
    await _initPrefs();

    await _auth.signOut();

    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_userKey);
    await _prefs?.remove(_rememberMeKey);

    return {"success": true};
  }

  // ================= RESET PASSWORD =================
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {"success": true};
    } catch (e) {
      return {"success": false, "error": "Error al enviar correo"};
    }
  }

  // ================= SESIÓN =================
  Future<void> _saveSession(
      String token, UserModel user, bool rememberMe) async {
    await _initPrefs();
    await _prefs?.setString(_tokenKey, token);
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs?.setBool(_rememberMeKey, rememberMe);
  }

  Future<bool> isLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  Future<UserModel?> getCurrentUser() async {
    await _initPrefs();
    final userJson = _prefs?.getString(_userKey);

    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // ================= ACTUALIZAR DATOS =================
  Future<bool> updateUserPoints(String uid, int points) async {
    try {
      final ref = _db.collection("usuarios").doc(uid);

      await ref.update({
        "totalPoints": FieldValue.increment(points),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // ================= UTIL =================
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
