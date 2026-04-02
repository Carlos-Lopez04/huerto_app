import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:huerto_app/services/qr_scanner_service.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String result) onScanCompleted;
  
  const QRScannerScreen({
    super.key,
    required this.onScanCompleted,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with WidgetsBindingObserver {
  final QRScannerService _scannerService = QRScannerService();
  MobileScannerController? _controller;
  bool _isInitializing = true;
  bool _isTorchOn = false;
  String? _errorMessage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _controller != null) {
      _controller?.start();
    }
    if (state == AppLifecycleState.paused && _controller != null) {
      _controller?.stop();
    }
  }

  Future<void> _initializeScanner() async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      // Solicitar permisos
      final hasPermission = await _scannerService.requestCameraPermission();
      if (!hasPermission) {
        setState(() {
          _errorMessage =
              'No se tienen permisos para usar la cámara.\nPor favor, otorga los permisos en ajustes.';
          _isInitializing = false;
        });
        return;
      }

      // Inicializar escáner
      _controller = _scannerService.initializeScanner();
      
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al iniciar el escáner: ${e.toString()}';
        _isInitializing = false;
      });
    }
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    
    final String? code = capture.barcodes.first.rawValue;
    
    if (code != null && code.isNotEmpty) {
      _isProcessing = true;
      
      // Detener el escáner temporalmente
      await _controller?.stop();
      
      // Mostrar diálogo con el resultado
      final shouldContinue = await _showScanResultDialog(code);
      
      if (shouldContinue) {
        // Continuar escaneando
        await _controller?.start();
        _isProcessing = false;
      } else {
        // Finalizar escaneo
        widget.onScanCompleted(code);
        if (mounted) {
          Navigator.pop(context, code);
        }
      }
    }
  }

  Future<bool> _showScanResultDialog(String code) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        title: const Row(
          children: [
            Icon(Icons.qr_code, color: forestDepth),
            SizedBox(width: 8),
            Text('Código Escaneado', style: AppFont.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del código:',
              style: AppFont.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: verdeGelido,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: emeraldLeaf.withOpacity(0.3)),
              ),
              child: SelectableText(
                code,
                style: AppFont.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '¿Qué deseas hacer?',
              style: AppFont.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Escanear otro', style: AppFont.button),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Aceptar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: forestDepth,
              foregroundColor: blancoHueso,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ).then((value) => value ?? false);
  }

  Future<void> _toggleTorch() async {
    if (_controller != null) {
      await _scannerService.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_controller != null) {
      await _scannerService.switchCamera();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          // Botón para linterna
          IconButton(
            onPressed: _toggleTorch,
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            tooltip: _isTorchOn ? 'Apagar linterna' : 'Encender linterna',
          ),
          // Botón para cambiar cámara
          IconButton(
            onPressed: _switchCamera,
            icon: const Icon(Icons.switch_camera),
            tooltip: 'Cambiar cámara',
          ),
        ],
      ),
      body: _buildBody(),
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
            Text('Inicializando escáner...'),
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
                onPressed: _initializeScanner,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Vista de la cámara
        MobileScanner(
          controller: _controller,
          onDetect: _handleBarcode,
        ),
        
        // Overlay con guía para escanear
        _buildScannerOverlay(),
        
        // Instrucciones en la parte inferior
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Apunta al código QR para escanear',
                  style: AppFont.bodySmall.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Esquinas decorativas
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 4),
                    left: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 4),
                    right: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 4),
                    left: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 4),
                    right: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}