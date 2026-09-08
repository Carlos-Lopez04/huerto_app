import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';  // ← IMPORTANTE: Agregar este import
import 'package:huerto_app/services/camera_service.dart';
import 'package:huerto_app/services/permission_service.dart';
// import 'package:huerto_app/config/widgets/bottom_nav_custom.dart';
import 'package:huerto_app/screens/camera/photo_preview_screen.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  final Function(File? photo) onPhotoCaptured;
  final bool enableVideo;
  
  const CameraScreen({
    super.key,
    required this.onPhotoCaptured,
    this.enableVideo = false,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  final PermissionService _permissionService = PermissionService();
  
  bool _isInitializing = true;
  bool _isRecording = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-inicializar cámara cuando la app vuelve al primer plano
      _initializeCamera();
    }
    if (state == AppLifecycleState.paused) {
      // Detener grabación si está activa
      if (_isRecording) {
        _stopVideoRecording();
      }
    }
  }
  
  Future<void> _initializeCamera() async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });
    
    try {
      // Verificar permisos
      final hasPermission = await _permissionService.requestCameraPermission();
      if (!hasPermission) {
        setState(() {
          _errorMessage = 'No se tienen permisos para usar la cámara.\nPor favor, otorga los permisos en ajustes.'; // ← Corregido: /n a \n
          _isInitializing = false;
        });
        return;
      }
      
      // Inicializar cámara
      await _cameraService.initializeCamera();
      
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al iniciar la cámara: ${e.toString()}';
        _isInitializing = false;
      });
    }
  }
  
  Future<void> _takePicture() async {
    final photo = await _cameraService.takePicture();
    
    if (photo != null && mounted) {
      // Navegar a vista previa
      final confirmed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoPreviewScreen(
            photo: photo,
            onRetake: () => Navigator.pop(context, false),
            onConfirm: () => Navigator.pop(context, true),
          ),
        ),
      );
      
      if (confirmed == true) {
        widget.onPhotoCaptured(photo);
        Navigator.pop(context, photo);
      }
    }
  }
  
  Future<void> _startVideoRecording() async {
    try {
      await _cameraService.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
      
      // Mostrar snackbar indicando grabación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grabando video...'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al grabar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _stopVideoRecording() async {
    final video = await _cameraService.stopVideoRecording();
    setState(() {
      _isRecording = false;
    });
    
    if (video != null && mounted) {
      // Aquí puedes manejar el video grabado
      widget.onPhotoCaptured(video); // Usamos la misma función pero con video
      Navigator.pop(context, video);
    }
  }
  
  Future<void> _switchCamera() async {
    await _cameraService.switchCamera();
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          if (_cameraService.isInitialized)
            IconButton(
              onPressed: _switchCamera,
              icon: const Icon(Icons.switch_camera),
              tooltip: 'Cambiar cámara',
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
  Widget _buildBody() {
    if (_isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Inicializando cámara...'),
          ],
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeCamera,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_cameraService.isInitialized && _cameraService.controller != null) {
      return CameraPreview(_cameraService.controller!); // ← Ahora funciona con el import
    }
    
    return const Center(child: Text('Cámara no disponible'));
  }
  
  Widget _buildFloatingButton() {
    if (_isInitializing || _errorMessage != null) return const SizedBox.shrink();
    
    if (widget.enableVideo) {
      // Botón con opción de foto/video
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isRecording)
            FloatingActionButton(
              onPressed: _stopVideoRecording,
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón para foto
                FloatingActionButton(
                  onPressed: _takePicture,
                  heroTag: 'photo',
                  child: const Icon(Icons.camera_alt, size: 28),
                ),
                const SizedBox(width: 20),
                // Botón para video
                FloatingActionButton(
                  onPressed: _startVideoRecording,
                  heroTag: 'video',
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.videocam, size: 28),
                ),
              ],
            ),
        ],
      );
    } else {
      // Solo botón de foto
      return FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt, size: 32),
      );
    }
  }
}