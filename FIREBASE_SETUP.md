# Firebase setup

La configuracion de cliente de Firebase ya esta incluida en el repositorio para
que un clon nuevo pueda ejecutar la app en Android sin archivos locales
adicionales. `google-services.json` y `firebase_options.dart` solo contienen
identificadores y claves publicas de cliente; no deben usarse para guardar
credenciales de administracion, tokens privados ni secretos del servidor.

## 1. Crear el proyecto en Firebase

1. Entra a Firebase Console.
2. Crea un proyecto o usa uno existente.
3. Activa `Authentication > Sign-in method > Email/Password`.
4. Crea una base de datos en `Firestore Database`.

## 2. Registrar la app Android

1. En Firebase, agrega una app Android.
2. Usa el mismo `applicationId` del proyecto.
   Actualmente: `com.example.huerto_app`
3. Comprueba que `android/app/google-services.json` corresponde al mismo
   proyecto y paquete (`com.example.huerto_app`).
4. Si cambias de proyecto, descarga el nuevo archivo y vuelve a generar
   `lib/firebase_options.dart` con FlutterFire CLI.

## 3. Registrar la app iOS

1. En Firebase, agrega una app iOS.
2. Usa el mismo bundle id configurado en Xcode.
3. Descarga `GoogleService-Info.plist`.
4. Colocalo en `ios/Runner/GoogleService-Info.plist`.

## 3. Configurar Firebase para desarrollo

Cada colaborador que necesite usar autenticacion o Firestore debe tener acceso
al proyecto `huerto-app-d0d8b` en Firebase Console. El acceso al repositorio
por si solo no concede permisos sobre los datos.

Activa `Authentication > Sign-in method > Email/Password` y crea Firestore.
Las reglas de Firestore deben permitir unicamente las operaciones necesarias
para usuarios autenticados; no uses reglas publicas en un entorno compartido.

## 4. Generar la configuracion despues de cambiar de proyecto

Si instalas FlutterFire CLI, ejecuta:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Eso generara `lib/firebase_options.dart`. Despues de cambiar la configuracion,
versiona el archivo generado junto con `android/app/google-services.json`.

## 5. Importante

- Si cambias `applicationId` o bundle id, deben coincidir tambien en Firebase.
- Android esta configurado y es la plataforma soportada por los archivos que
   actualmente contiene el proyecto.
- iOS, Web, macOS, Windows y Linux requieren registrar cada app en Firebase y
   regenerar `firebase_options.dart`; si se ejecutan ahora, el arranque devuelve
   `UnsupportedError` porque no tienen opciones configuradas.
- Si cambias `applicationId` o bundle id, deben coincidir tambien en Firebase.
