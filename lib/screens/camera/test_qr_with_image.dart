import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';
// Importar la pantalla del escáner QR
import 'package:huerto_app/screens/camera/qr_scanner_screen.dart';

class TestQRWithImage extends StatefulWidget {
  const TestQRWithImage({super.key});

  @override
  State<TestQRWithImage> createState() => _TestQRWithImageState();
}

class _TestQRWithImageState extends State<TestQRWithImage> {
  String? _lastScannedCode; // Cambiado nombre para mejor claridad
  final bool _isAnalyzing = false; // Este campo se mantiene para futuras funcionalidades

  // Contenido simulado del código QR (puedes cambiarlo según el QR real)
  static const String _simulatedQRContent = 'https://www.fca.uabc.mx';

  Future<void> _simulateQRCode() async {
    // Actualizar el último código escaneado
    setState(() {
      _lastScannedCode = _simulatedQRContent;
    });
    
    // Mostrar diálogo con el resultado
    await _showQRDialog(
      title: 'Código QR Simulado',
      content: _simulatedQRContent,
      showImage: true,
    );
  }

  // Método para leer el código QR real usando la cámara
  Future<void> _openRealScanner() async {
    final String? scannedCode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onScanCompleted: (code) {
            Navigator.pop(context, code);
          },
        ),
      ),
    );
    
    if (scannedCode != null && scannedCode.isNotEmpty && mounted) {
      setState(() {
        _lastScannedCode = scannedCode;
      });
      
      // Mostrar el resultado del escaneo real
      await _showQRDialog(
        title: 'Código QR Escaneado',
        content: scannedCode,
        showImage: false,
        isRealScan: true,
      );
    }
  }

  // Diálogo para mostrar información del QR
  Future<void> _showQRDialog({
    required String title,
    required String content,
    bool showImage = false,
    bool isRealScan = false,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        title: Row(
          children: [
            Icon(
              isRealScan ? Icons.check_circle : Icons.qr_code,
              color: isRealScan ? Colors.green : forestDepth,
            ),
            const SizedBox(width: 8),
            Text(title, style: AppFont.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showImage)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/images/fca_link.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[200],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, size: 40),
                              SizedBox(height: 8),
                              Text(
                                'Imagen no encontrada',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                ],
              ),
            
            if (isRealScan)
              const Icon(Icons.check_circle, size: 50, color: Colors.green),
            
            if (!showImage && !isRealScan)
              const Icon(Icons.qr_code, size: 50, color: forestDepth),
            
            const SizedBox(height: 16),
            
            const Text(
              'Contenido del código QR:',
              style: AppFont.bodyMedium,
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: verdeGelido,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: emeraldLeaf.withOpacity(0.3)),
              ),
              child: SelectableText(
                content,
                style: AppFont.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            if (content.startsWith('http'))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🔗 Este es un enlace web',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: AppFont.button),
          ),
          if (content.startsWith('http'))
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Aquí puedes agregar la lógica para abrir el enlace
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: forestDepth,
                    content: Text('Abrir enlace: $content'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.open_in_browser, size: 18),
              label: const Text('Abrir Enlace'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Probar QR - FCA Link'),
        backgroundColor: forestDepth,
        foregroundColor: blancoHueso,
        actions: [
          IconButton(
            onPressed: _showHelpDialog,
            icon: const Icon(Icons.help_outline),
            tooltip: 'Ayuda',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tarjeta con la imagen del QR
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Imagen QR de Prueba',
                      style: AppFont.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'lib/images/fca_link.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, size: 50),
                              SizedBox(height: 8),
                              Text(
                                'Imagen no encontrada',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'lib/images/fca_link.png',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Archivo: lib/images/fca_link.png',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '💡 Haz clic en "Leer Código QR" para ver su contenido',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botón para leer QR simulado
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simulateQRCode,
                  icon: const Icon(Icons.qr_code, size: 24),
                  label: const Text(
                    'Leer Código QR',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: forestDepth,
                    foregroundColor: blancoHueso,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botón para abrir escáner real
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openRealScanner,
                  icon: const Icon(Icons.camera_alt, size: 24),
                  label: const Text(
                    'Abrir Escáner Real',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: forestDepth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    side: const BorderSide(color: forestDepth),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Mostrar último código escaneado (ahora usando _lastScannedCode)
              if (_lastScannedCode != null)
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
                        'Último código escaneado:',
                        style: AppFont.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: blancoHueso,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _lastScannedCode!,
                          style: AppFont.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: forestDepth,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
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
            Text('Información', style: AppFont.titleMedium),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📱 Esta pantalla te permite probar el código QR:',
              style: AppFont.bodyMedium,
            ),
            SizedBox(height: 12),
            Text(
              '• "Leer Código QR" - Muestra el contenido simulado del QR\n'
              '  (Actual: https://www.fca.uabc.mx)\n\n'
              '• "Abrir Escáner Real" - Usa la cámara para escanear códigos reales\n\n'
              '📁 Archivo de imagen: lib/images/fca_link.png\n\n'
              '💡 Para cambiar el contenido simulado, modifica la constante\n'
              '  "_simulatedQRContent" en el código.',
              style: TextStyle(fontSize: 12),
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
}