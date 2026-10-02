import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

/// Servicio de persistencia en Firestore del perfil completo del usuario.
///
/// Complementa a [UserService] (que guarda localmente en SharedPreferences)
/// para que los datos (puntos, nivel, monedas, avatar, logros, actividades,
/// rachas, etc.) se sincronicen y persistan en la nube.
class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  static const String usersCollection = 'usuarios';

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Guarda el perfil completo en `usuarios/{uid}` (con merge para no borrar
  /// campos no presentes). No hace nada para la cuenta local de desarrollo.
  Future<void> saveUser(UserModel user) async {
    if (user.id.isEmpty || user.id == 'local_admin') return;

    final uid = _currentUid();
    if (uid == null || uid != user.id) return;

    try {
      await _db
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error al guardar usuario en Firestore: $e');
    }
  }

  /// Carga el perfil completo desde Firestore. Devuelve null si no existe.
  Future<UserModel?> loadUser(String uid) async {
    if (uid.isEmpty || uid == 'local_admin') return null;

    try {
      final doc = await _db.collection(usersCollection).doc(uid).get();
      final data = doc.data();
      if (data == null || data.isEmpty) return null;
      return UserModel.fromJson(data).copyWith(id: uid);
    } catch (e) {
      debugPrint('Error al cargar usuario de Firestore: $e');
      return null;
    }
  }

  /// Elimina el documento del usuario (útil para limpiar datos).
  Future<void> deleteUser(String uid) async {
    if (uid.isEmpty || uid == 'local_admin') return;
    try {
      await _db.collection(usersCollection).doc(uid).delete();
    } catch (e) {
      debugPrint('Error al eliminar usuario de Firestore: $e');
    }
  }

  String? _currentUid() {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }
}
