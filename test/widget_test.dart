import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:huerto_app/firebase_options.dart';
import 'package:huerto_app/main.dart';

class _MockFirebasePlatform extends FirebasePlatform {
  _MockFirebasePlatform(this._options);

  final FirebaseOptions _options;
  final List<FirebaseAppPlatform> _apps = [];

  @override
  List<FirebaseAppPlatform> get apps => List.unmodifiable(_apps);

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    final appName = name ?? defaultFirebaseAppName;
    final appOptions = options ?? _options;
    final app = FirebaseAppPlatform(appName, appOptions);
    _apps.add(app);
    return app;
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return _apps.firstWhere(
      (a) => a.name == name,
      orElse: () => throw FirebaseException(
        plugin: 'core',
        code: 'no-app',
        message: "No Firebase App '$name' has been created.",
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    FirebasePlatform.instance = _MockFirebasePlatform(
      DefaultFirebaseOptions.currentPlatform,
    );
    await Firebase.initializeApp();
  });

  testWidgets('renders the login screen without Firebase setup',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}