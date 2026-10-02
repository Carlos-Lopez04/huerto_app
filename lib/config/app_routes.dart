import 'package:flutter/material.dart';
import '../screens/camera/camera_screen.dart';

class AppRoutes {
  static const String camera = '/camera';
  
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case camera:
        return MaterialPageRoute(
          builder: (context) => CameraScreen(
            onPhotoCaptured: (photo) {
              // Manejar la foto capturada
              if (photo != null) {
                Navigator.pop(context, photo);
              }
            },
          ),
        );
      default:
        return null;
    }
  }
}