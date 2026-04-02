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
  bool _isTestMode = false; // Modo prueba para emulador

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
    if (state == AppLifecycleState.resumed && _controller != null && !_isTestMode) {
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
      // Intentar solicitar permisos
      final hasPermission = await _scannerService.requestCameraPermission();
      if (!hasPermission) {
        // Si no hay permisos, activar modo prueba
        setState(() {
          _isTestMode = true;
          _isInitializing = false;
        });
        return;
      }

      // Intentar inicializar escáner
      _controller = _scannerService.initializeScanner();
      
      // Esperar un momento para ver si se inicializa correctamente
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      // Si hay error (como en emulador sin cámara), activar modo prueba
      print('Error al inicializar escáner: $e');
      setState(() {
        _isTestMode = true;
        _isInitializing = false;
        _errorMessage = null; // Limpiar error, usamos modo prueba
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

  // Simular escaneo para pruebas en emulador
  void _simulateScan() {
    final TextEditingController textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        title: const Row(
          children: [
            Icon(Icons.qr_code_scanner, color: forestDepth),
            SizedBox(width: 8),
            Text('Simular Escaneo', style: AppFont.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresa manualmente el código QR que deseas probar:',
              style: AppFont.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Código QR',
                hintText: 'Ej: PLANT-TOMATO-001',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.qr_code),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: verdeGelido,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Códigos de prueba sugeridos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• PLANT-TOMATO-001'),
                  Text('• https://www.fca.uabc.mx'),
                  Text('• REWARD-100-POINTS'),
                  Text('• PLANT-BASIL-002'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final code = textController.text.trim();
              if (code.isNotEmpty) {
                Navigator.pop(context);
                _processSimulatedCode(code);
              }
            },
            icon: const Icon(Icons.qr_code_scanner, size: 18),
            label: const Text('Escanear'),
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
    );
  }

  void _processSimulatedCode(String code) async {
    _isProcessing = true;
    final shouldContinue = await _showScanResultDialog(code);
    
    if (shouldContinue) {
      _isProcessing = false;
    } else {
      widget.onScanCompleted(code);
      if (mounted) {
        Navigator.pop(context, code);
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
        title: Text(_isTestMode ? 'Simulador de Escáner' : 'Escanear QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          if (!_isTestMode) ...[
            // Botón para linterna (solo en modo real)
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
          // Botón de ayuda
          IconButton(
            onPressed: _showHelpDialog,
            icon: const Icon(Icons.help_outline),
            tooltip: 'Ayuda',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _isTestMode
          ? FloatingActionButton.extended(
              onPressed: _simulateScan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Simular Escaneo'),
              backgroundColor: forestDepth,
            )
          : null,
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        title: const Row(
          children: [
            Icon(Icons.help, color: forestDepth),
            SizedBox(width: 8),
            Text('Ayuda del Escáner', style: AppFont.titleMedium),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📱 Escáner QR',
              style: AppFont.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              '• Apunta la cámara al código QR\n'
              '• Mantén el código dentro del marco\n'
              '• El escáner detectará automáticamente',
              style: AppFont.bodySmall,
            ),
            Divider(height: 24),
            Text(
              '🧪 Modo de Prueba (Emulador)',
              style: AppFont.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Si estás en un emulador sin cámara:\n'
              '1. Se activará automáticamente el modo simulación\n'
              '2. Usa el botón "Simular Escaneo"\n'
              '3. Ingresa manualmente el código que deseas probar\n\n'
              'Códigos de prueba sugeridos:\n'
              '• PLANT-TOMATO-001\n'
              '• https://www.fca.uabc.mx\n'
              '• REWARD-100-POINTS\n'
              '• PLANT-BASIL-002',
              style: AppFont.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido', style: AppFont.button),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
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

    if (_errorMessage != null && !_isTestMode) {
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

    if (_isTestMode) {
      // Modo de simulación para pruebas en emulador
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: forestDepth.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Modo de Prueba',
                style: AppFont.titleLarge.copyWith(
                  color: forestDepth,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'El escáner está en modo simulación.\n'
                'Usa el botón flotante para probar códigos QR.',
                textAlign: TextAlign.center,
                style: AppFont.bodyMedium,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: verdeGelido,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: emeraldLeaf.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Códigos de prueba:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• PLANT-TOMATO-001\n'
                      '• https://www.fca.uabc.mx\n'
                      '• REWARD-100-POINTS\n'
                      '• PLANT-BASIL-002\n'
                      '• PLANT-ALOE-003\n'
                      '• ACT-WATER-001',
                      style: AppFont.bodySmall.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
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