import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseStartupService {
  const FirebaseStartupService._();

  static Future<bool> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return true;
    }

    try {
      await Firebase.initializeApp();
      return true;
    } on FirebaseException catch (e) {
      debugPrint('Firebase initialization failed: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      return false;
    }
  }
}
