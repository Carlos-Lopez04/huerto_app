import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

class FirebaseStartupService {
  const FirebaseStartupService._();

  static Future<bool> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return true;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
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
