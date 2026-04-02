import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';  // ← IMPORTANTE: Agregar este import
import 'package:huerto_app/services/camera_service.dart';
import 'package:huerto_app/services/permission_service.dart';

class CameraMiniWidget extends StatefulWidget {
  final Function(File photo) onPhotoTaken;
  final double height;
  final double width;
  
  const CameraMiniWidget({
    super.key,
    required this.onPhotoTaken,
    this.height = 200,
    this.width = double.infinity,
  });
  
  @override
  State<CameraMiniWidget> createState() => _CameraMiniWidgetState();
}

class _CameraMiniWidgetState extends State<CameraMiniWidget> {
  final CameraService _cameraService = CameraService();
  final PermissionService _permissionService = PermissionService();
  bool _isInitialized = false;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
  
  Future<void> _initializeCamera() async {
    final hasPermission = await _permissionService.requestCameraPermission();
    if (hasPermission) {
      await _cameraService.initializeCamera();
      if (mounted) {
        setState(() {
          _isInitialized = _cameraService.isInitialized;
        });
      }
    }
  }
  
  Future<void> _takePicture() async {
    final photo = await _cameraService.takePicture();
    if (photo != null) {
      widget.onPhotoTaken(photo);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (_isInitialized && _cameraService.controller != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CameraPreview(_cameraService.controller!), // ← Ahora funciona con el import
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton.small(
              onPressed: _takePicture,
              child: const Icon(Icons.camera_alt, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}