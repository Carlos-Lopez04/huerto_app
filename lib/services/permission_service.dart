import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Solicita y verifica permisos de cámara
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        // El usuario denegó, podemos volver a preguntar
        return false;
      case PermissionStatus.permanentlyDenied:
        // El usuario denegó permanentemente, abrir ajustes
        await openAppSettings();
        return false;
      default:
        return false;
    }
  }
  
  /// Solicita permisos de cámara específicos para escáner
  Future<bool> requestScannerPermission() async {
    final status = await Permission.camera.request();
    
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        return false;
      default:
        return false;
    }
  }
  
  /// Solicita permisos de almacenamiento (Android)
  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isDenied) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }
  
  /// Verifica todos los permisos necesarios
  Future<bool> checkAllPermissions() async {
    final cameraStatus = await Permission.camera.status;
    
    if (!cameraStatus.isGranted) {
      return false;
    }
    
    // Para Android, verificar almacenamiento
    if (await Permission.storage.status.isDenied) {
      return false;
    }
    
    return true;
  }
  
  /// Verifica si la cámara está disponible
  Future<bool> isCameraAvailable() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }
}