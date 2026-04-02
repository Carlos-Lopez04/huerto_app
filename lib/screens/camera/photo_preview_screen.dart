import 'package:flutter/material.dart';
import 'dart:io';

class PhotoPreviewScreen extends StatelessWidget {
  final File photo;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;
  
  const PhotoPreviewScreen({
    super.key,
    required this.photo,
    required this.onRetake,
    required this.onConfirm,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Previa'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 2.0,
                  child: Image.file(
                    photo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.camera_alt,
                  label: 'Re-tomar',
                  color: Colors.grey[700]!,
                  onPressed: onRetake,
                ),
                _buildActionButton(
                  icon: Icons.check_circle,
                  label: 'Aceptar',
                  color: Colors.green,
                  onPressed: onConfirm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}