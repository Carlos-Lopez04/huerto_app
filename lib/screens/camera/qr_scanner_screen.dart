import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:huerto_app/models/plant_model.dart';
import 'package:huerto_app/services/plant_repository.dart';
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

  // ----- Estado de realidad aumentada -----
  Size? _cameraSize; // Tamano de salida de la camara
  String? _arCode; // Codigo de la planta detectada
  PlantModel? _arPlant; // Informacion de la planta detectada
  List<Offset>? _arCorners; // Esquinas del codigo en el frame de la camara
  Size? _arFrameSize; // Tamano del frame donde vienen las esquinas
  bool _arLoading = false; // Mientras se resuelve la informacion

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
      debugPrint('Error al inicializar escáner: $e');
      setState(() {
        _isTestMode = true;
        _isInitializing = false;
        _errorMessage = null; // Limpiar error, usamos modo prueba
      });
    }
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (capture.barcodes.isEmpty) return;

    final Barcode barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code == null || code.trim().isEmpty) return;

    // ¿Es un codigo de planta? -> experiencia de realidad aumentada.
    final slug = PlantRepository.slugFromCode(code);
    if (slug != null) {
      _handlePlantDetection(
        code,
        slug,
        barcode.corners,
        capture.size,
      );
      return;
    }

    if (_isProcessing) return;
    _isProcessing = true;

    // Un codigo distinto: cerrar la tarjeta AR antes de continuar.
    if (_arPlant != null) {
      _clearAr();
    }

    await _showCodeDialogFlow(code);
  }

  /// Muestra el dialogo clasico para codigos que no son de plantas.
  Future<void> _showCodeDialogFlow(String code) async {
    // Detener el escáner temporalmente
    await _controller?.stop();

    final shouldContinue = await _showScanResultDialog(code);

    if (!mounted) return;

    if (shouldContinue) {
      // Continuar escaneando
      await _controller?.start();
      _isProcessing = false;
    } else {
      // Finalizar escaneo
      widget.onScanCompleted(code);
      Navigator.pop(context, code);
    }
  }

  /// Actualiza la capa de realidad aumentada con la planta detectada.
  void _handlePlantDetection(
    String code,
    String slug,
    List<Offset> corners,
    Size frameSize,
  ) {
    final effectiveFrame =
        (frameSize.width > 0 && frameSize.height > 0) ? frameSize : _cameraSize;
    final normalizedCorners = corners.isEmpty ? null : corners;
    final isSameCode = _arCode == code;

    // Si el codigo y la posicion no cambiaron, no hay nada que reconstruir.
    if (isSameCode && _cornersEqual(normalizedCorners, _arCorners)) {
      return;
    }

    setState(() {
      _arCode = code;
      _arCorners = normalizedCorners;
      _arFrameSize = effectiveFrame;
      if (!isSameCode) {
        _arPlant = PlantRepository.localInfo(slug);
        _arLoading = _arPlant == null;
      }
    });

    if (!isSameCode && _arPlant == null) {
      PlantRepository.resolve(code).then((plant) {
        if (mounted && _arCode == code) {
          setState(() {
            _arPlant = plant;
            _arLoading = false;
          });
        }
      });
    }
  }

  void _clearAr() {
    setState(() {
      _arCode = null;
      _arPlant = null;
      _arCorners = null;
      _arFrameSize = null;
      _arLoading = false;
    });
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
                  Text('• PLANT-Rosa (cualquier planta)'),
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

  void _processSimulatedCode(String code) {
    // En modo simulacion no hay camara: mostramos la tarjeta AR centrada.
    final slug = PlantRepository.slugFromCode(code);
    if (slug != null) {
      _handlePlantDetection(code, slug, const [], Size.zero);
      return;
    }

    _isProcessing = true;
    _showCodeDialogFlow(code);
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
                border: Border.all(color: emeraldLeaf.withValues(alpha: 0.3)),
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
        title: Text(_isTestMode ? 'Realidad Aumentada (Simulador)' : 'Escanear QR'),
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
              '📱 Escáner QR con Realidad Aumentada',
              style: AppFont.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              '• Apunta la cámara al código QR\n'
              '• Mantén el código dentro del marco\n'
              '• Si el código identifica una planta, aparecerá '
              'un recuadro con su información sobre la cámara',
              style: AppFont.bodySmall,
            ),
            Divider(height: 24),
            Text(
              '🌿 Códigos de plantas (AR)',
              style: AppFont.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Funciona con cualquier planta usando el formato '
              'PLANT-<nombre> o huerto://planta/<nombre>.\n\n'
              'Ejemplos: PLANT-TOMATO-001, PLANT-Rosa, '
              'huerto://planta/Fragaria x ananassa',
              style: AppFont.bodySmall,
            ),
            SizedBox(height: 8),
            Text(
              'Las plantas fuera del catálogo local se consultan en '
              'Trefle (identificación) y Perenual (cuidados); requieren '
              'TREFLE_TOKEN y PERENUAL_KEY en .env.',
              style: AppFont.bodySmall,
            ),
            Divider(height: 24),
            Text(
              '🧪 Modo de Prueba (Emulador)',
              style: AppFont.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              '1. Se activa automáticamente el modo simulación\n'
              '2. Usa el botón "Simular Escaneo"\n'
              '3. Ingresa manualmente el código a probar',
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
      return _buildTestModeBody();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final widgetSize = constraints.biggest;
        final markerCenter = _markerCenter(widgetSize);
        final showArCard = _arPlant != null;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Vista de la cámara
            MobileScanner(
              controller: _controller,
              onDetect: _handleBarcode,
              onScannerStarted: (arguments) {
                _cameraSize = arguments?.size;
              },
            ),

            // Overlay con guía para escanear (se oculta durante la AR)
            if (!showArCard && !_arLoading) _buildScannerOverlay(),

            // Punto/objetivo anclado al código detectado
            if (markerCenter != null && showArCard)
              _ArReticle(center: markerCenter),

            // Tarjeta AR con la información de la planta
            if (showArCard) _buildArCard(_arPlant!),

            // Indicador de carga mientras se resuelve la planta
            if (_arLoading)
              Positioned(
                left: 16,
                right: 16,
                bottom: 90,
                child: _buildScanningBanner(),
              ),

            // Instrucciones en la parte inferior
            if (!showArCard && !_arLoading) _buildBottomHint(),
          ],
        );
      },
    );
  }

  Widget _buildTestModeBody() {
    // Modo de simulación para pruebas en emulador
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.view_in_ar,
                  size: 100,
                  color: forestDepth.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'Realidad Aumentada',
                  style: AppFont.titleLarge.copyWith(
                    color: forestDepth,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'El escáner está en modo simulación.\n'
                  'Usa el botón flotante para probar códigos QR de plantas.',
                  textAlign: TextAlign.center,
                  style: AppFont.bodyMedium,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: verdeGelido,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: emeraldLeaf.withValues(alpha: 0.3)),
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
                        '• PLANT-BASIL-002\n'
                        '• PLANT-ALOE-003\n'
                        '• PLANT-Rosa (cualquier planta)\n'
                        '• https://www.fca.uabc.mx\n'
                        '• REWARD-100-POINTS\n'
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
        ),
        if (_arLoading)
          Positioned(
            left: 16,
            right: 16,
            bottom: 90,
            child: _buildScanningBanner(),
          ),
        if (_arPlant != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 90,
            child: _buildArCard(_arPlant!),
          ),
      ],
    );
  }

  Widget _buildBottomHint() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.view_in_ar, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Escanea un QR de planta para ver su información',
              style: AppFont.bodySmall.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: emeraldLeaf.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Analizando planta...',
            style: AppFont.bodyMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// Tarjeta flotante con la información clave de la planta detectada.
  Widget _buildArCard(PlantModel plant) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: forestDepth.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: emeraldLeaf, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.eco, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: AppFont.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          plant.scientificName,
                          style: AppFont.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: goldenSun,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.view_in_ar, size: 14, color: forestDepth),
                        SizedBox(width: 4),
                        Text(
                          'AR',
                          style: TextStyle(
                            color: forestDepth,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),

            // Información clave
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Column(
                  children: [
                    _arInfoRow(Icons.water_drop, 'Riego', plant.care.watering),
                    _arInfoRow(Icons.wb_sunny, 'Luz', plant.care.light),
                    _arInfoRow(
                      Icons.thermostat,
                      'Temperatura',
                      plant.care.temperature,
                    ),
                    _arInfoRow(
                      Icons.calendar_today,
                      'Siembra',
                      plant.sowingSeason,
                    ),
                    _arInfoRow(Icons.timer, 'Cosecha', plant.harvestTime),
                  ],
                ),
              ),
            ),

            // Acciones
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearAr,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Cerrar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showPlantDetail(plant),
                      icon: const Icon(Icons.menu_book, size: 18),
                      label: const Text('Ficha completa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldenSun,
                        foregroundColor: forestDepth,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _arInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: goldenSun),
          const SizedBox(width: 10),
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: AppFont.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFont.bodySmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Ficha completa de la planta en una hoja deslizable.
  void _showPlantDetail(PlantModel plant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: blancoHueso,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.eco, color: forestDepth, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: AppFont.titleLarge.copyWith(
                          color: forestDepth,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        plant.scientificName,
                        style: AppFont.bodySmall.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _detailSection('📝 Descripción', plant.description),
            const SizedBox(height: 16),
            _detailSection(
              '🌱 Cuidados',
              'Riego: ${plant.care.watering}\n'
              'Luz: ${plant.care.light}\n'
              'Temperatura: ${plant.care.temperature}\n'
              'Suelo: ${plant.care.soil}',
            ),
            const SizedBox(height: 16),
            _detailSection(
              '📋 Información adicional',
              'Siembra: ${plant.sowingSeason}\n'
              'Cosecha: ${plant.harvestTime}',
            ),
            const SizedBox(height: 16),
            _detailSection('✨ Beneficios', plant.benefits),
            const SizedBox(height: 16),
            _detailSection('📚 Datos curiosos', plant.curiousFacts),
            if (plant.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Se muestran datos de respaldo. Verifica tu conexión a internet.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _detailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppFont.titleMedium),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: verdeGelido,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(content, style: AppFont.bodyMedium),
        ),
      ],
    );
  }

  /// Compara dos conjuntos de esquinas con una tolerancia de 1 px para
  /// evitar reconstrucciones innecesarias por micro-movimientos.
  static bool _cornersEqual(List<Offset>? a, List<Offset>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).distance > 1.0) return false;
    }
    return true;
  }

  /// Convierte el centro de las esquinas del código (en coordenadas de la
  /// cámara) a coordenadas del widget, respetando el `BoxFit.cover`.
  Offset? _markerCenter(Size widgetSize) {
    final corners = _arCorners;
    final frame = _arFrameSize;
    if (corners == null || corners.isEmpty || frame == null) return null;
    if (frame.width <= 0 || frame.height <= 0) return null;
    if (widgetSize.width <= 0 || widgetSize.height <= 0) return null;

    var sumX = 0.0;
    var sumY = 0.0;
    for (final corner in corners) {
      sumX += corner.dx;
      sumY += corner.dy;
    }
    final centerX = sumX / corners.length;
    final centerY = sumY / corners.length;

    final scale = math.max(
      widgetSize.width / frame.width,
      widgetSize.height / frame.height,
    );
    final offsetX = (widgetSize.width - frame.width * scale) / 2;
    final offsetY = (widgetSize.height - frame.height * scale) / 2;

    final mapped = Offset(
      centerX * scale + offsetX,
      centerY * scale + offsetY,
    );

    const margin = 44.0;
    return Offset(
      mapped.dx.clamp(margin, widgetSize.width - margin),
      mapped.dy.clamp(margin, widgetSize.height - margin),
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

/// Objetivo animado que marca la posición del código detectado (efecto AR).
class _ArReticle extends StatefulWidget {
  final Offset center;

  const _ArReticle({required this.center});

  @override
  State<_ArReticle> createState() => _ArReticleState();
}

class _ArReticleState extends State<_ArReticle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 96.0;
    return Positioned(
      left: widget.center.dx - size / 2,
      top: widget.center.dy - size / 2,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _controller.value;
            final pulse = 1.0 - progress;
            return SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Anillo que se expande
                  Transform.scale(
                    scale: 0.6 + progress * 0.9,
                    child: Opacity(
                      opacity: (pulse * 0.8).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: goldenSun, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Punto central
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: goldenSun,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: goldenSun.withValues(alpha: 0.6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
