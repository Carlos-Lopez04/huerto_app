import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  
  // Getters
  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  bool get isRecordingVideo => _controller?.value.isRecordingVideo ?? false;
  
  /// Inicializa la cámara con la cámara trasera por defecto
  Future<void> initializeCamera({CameraLensDirection direction = CameraLensDirection.back}) async {
    try {
      // Obtener lista de cámaras disponibles
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No se encontraron cámaras en el dispositivo');
      }
      
      // Seleccionar cámara según dirección
      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == direction,
        orElse: () => _cameras!.first,
      );
      
      // Liberar controlador anterior si existe
      await _controller?.dispose();
      
      // Crear nuevo controlador con resolución óptima
      _controller = CameraController(
        camera,
        ResolutionPreset.medium, // Opciones: low, medium, high, veryHigh, ultraHigh
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      
      // Inicializar controlador
      await _controller!.initialize();
      
      if (kDebugMode) {
        print('Cámara inicializada: ${camera.name}');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar cámara: $e');
      }
      rethrow;
    }
  }
  
  /// Cambiar entre cámara frontal y trasera
  Future<void> switchCamera() async {
    if (!isInitialized || _cameras == null || _cameras!.length < 2) return;
    
    final currentCamera = _controller!.description;
    final newDirection = currentCamera.lensDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    
    final newCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == newDirection,
      orElse: () => _cameras!.first,
    );
    
    await _controller?.dispose();
    
    _controller = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    
    await _controller!.initialize();
  }
  
  /// Tomar una foto y guardarla en caché
  Future<File?> takePicture() async {
    if (!isInitialized) {
      throw Exception('La cámara no está inicializada');
    }
    
    try {
      final XFile picture = await _controller!.takePicture();
      return File(picture.path);
    } catch (e) {
      if (kDebugMode) {
        print('Error al tomar foto: $e');
      }
      return null;
    }
  }
  
  /// Iniciar grabación de video
  Future<void> startVideoRecording() async {
    if (!isInitialized) {
      throw Exception('La cámara no está inicializada');
    }
    
    if (isRecordingVideo) {
      return;
    }
    
    try {
      await _controller!.startVideoRecording();
    } catch (e) {
      if (kDebugMode) {
        print('Error al iniciar grabación: $e');
      }
      rethrow;
    }
  }
  
  /// Detener grabación y guardar video
  Future<File?> stopVideoRecording() async {
    if (!isInitialized || !isRecordingVideo) {
      return null;
    }
    
    try {
      final XFile videoFile = await _controller!.stopVideoRecording();
      return File(videoFile.path);
    } catch (e) {
      if (kDebugMode) {
        print('Error al detener grabación: $e');
      }
      return null;
    }
  }
  
  /// Liberar recursos
  void dispose() {
    _controller?.dispose();
  }
  
  /// Guardar imagen de manera permanente en la app
  Future<String> saveImagePermanently(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedFile = File('${appDir.path}/$fileName');
    
    await imageFile.copy(savedFile.path);
    return savedFile.path;
  }
  
  /// Convertir imagen a bytes (útil para enviar a API)
  Future<Uint8List?> imageToBytes(File imageFile) async {
    try {
      return await imageFile.readAsBytes();
    } catch (e) {
      return null;
    }
  }
}