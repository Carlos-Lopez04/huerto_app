import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerService {
  MobileScannerController? _controller;
  
  // Getter para el controlador
  MobileScannerController? get controller => _controller;
  
  // Inicializar el escáner
  MobileScannerController initializeScanner() {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back, // Usar cámara trasera
      torchEnabled: false, // Linterna apagada por defecto
      returnImage: false, // No retornar imagen para mejor rendimiento
    );
    return _controller!;
  }
  
  // Solicitar permisos de cámara
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }
  
  // Cambiar linterna
  Future<void> toggleTorch() async {
    if (_controller != null) {
      await _controller!.toggleTorch();
    }
  }
  
  // Cambiar cámara (frontal/trasera)
  Future<void> switchCamera() async {
    if (_controller != null) {
      await _controller!.switchCamera();
    }
  }
  
  // Liberar recursos
  void dispose() {
    _controller?.dispose();
  }
}