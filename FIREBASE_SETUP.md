# Firebase setup

El proyecto ya usa `firebase_auth`, `cloud_firestore` y `firebase_core`, pero todavia necesitas conectar este codigo con tu proyecto real de Firebase.

## 1. Crear el proyecto en Firebase

1. Entra a Firebase Console.
2. Crea un proyecto o usa uno existente.
3. Activa `Authentication > Sign-in method > Email/Password`.
4. Crea una base de datos en `Firestore Database`.

## 2. Registrar la app Android

1. En Firebase, agrega una app Android.
2. Usa el mismo `applicationId` del proyecto.
   Actualmente: `com.example.huerto_app`
3. Descarga `google-services.json`.
4. Colocalo en `android/app/google-services.json`.

## 3. Registrar la app iOS

1. En Firebase, agrega una app iOS.
2. Usa el mismo bundle id configurado en Xcode.
3. Descarga `GoogleService-Info.plist`.
4. Colocalo en `ios/Runner/GoogleService-Info.plist`.

## 4. Opcional recomendado: generar `firebase_options.dart`

Si instalas FlutterFire CLI, ejecuta:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Eso generara `lib/firebase_options.dart`. El proyecto ya ignora ese archivo en git.

## 5. Importante

- Si cambias `applicationId` o bundle id, deben coincidir tambien en Firebase.
- Sin `google-services.json` y `GoogleService-Info.plist`, `Firebase.initializeApp()` no podra conectarse en Android/iOS.
- Si vas a usar Web, tambien necesitas registrar la app web y usar `firebase_options.dart`.
