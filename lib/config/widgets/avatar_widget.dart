// config/widgets/avatar_widget.dart

// Importaciones de paquetes necesarios
import 'package:flutter/material.dart'; // Widgets básicos de Flutter
import 'package:huerto_app/models/user_model.dart'; // Modelo de usuario

// Widget que muestra el avatar del usuario con personalizaciones
class AvatarWidget extends StatelessWidget {
  // Propiedades del widget
  final UserModel user; // Datos del usuario
  final double size; // Tamaño del avatar
  final Color? borderColor; // Color del borde (opcional)
  final double borderWidth; // Ancho del borde
  final bool showBorder; // Mostrar borde
  final bool showEffects; // Mostrar efectos como sombras y lentes

  // Constructor del widget
  const AvatarWidget({
    super.key, // Clave para identificar el widget
    required this.user, // Usuario obligatorio
    this.size = 100, // Tamaño por defecto: 100
    this.borderColor, // Color del borde opcional
    this.borderWidth = 3, // Ancho del borde por defecto: 3
    this.showBorder = false, // Por defecto sin borde
    this.showEffects = true, // Por defecto con efectos
  });

  // Método principal de construcción del widget
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, // Ancho del contenedor
      height: size, // Alto del contenedor
      decoration: showBorder // Si debe mostrar borde
          ? BoxDecoration(
              shape: BoxShape.circle, // Forma circular
              border: Border.all(
                // Configurar borde
                color: borderColor ??
                    Colors.green, // Color del borde o verde por defecto
                width: borderWidth, // Ancho del borde
              ),
              boxShadow: showEffects // Si debe mostrar efectos de sombra
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 
                            0.1), // Color de sombra semitransparente
                        blurRadius: 8, // Radio de desenfoque
                        offset:
                            const Offset(0, 4), // Desplazamiento de la sombra
                      ),
                    ]
                  : null, // Sin sombra si showEffects es false
            )
          : null, // Sin decoración si showBorder es false
      child: ClipOval(
        // Recortar contenido en forma ovalada
        child: _buildAvatar(), // Construir el contenido del avatar
      ),
    );
  }

  /*
      Método para construir el avatar
      Decide si mostrar avatar normal o personalizado
  */
  Widget _buildAvatar() {
    // Si el avatar está personalizado, mostrar versión personalizada
    if (_shouldShowCustomizedAvatar()) {
      return _buildCustomizedAvatar();
    }

    // Si no está personalizado, mostrar imagen normal
    return _buildNormalAvatar();
  }

  /*
      Determinar si mostrar avatar personalizado
      Verifica todas las propiedades de personalización
  */
  bool _shouldShowCustomizedAvatar() {
    return user.isAvatarCustomized || // Avatar personalizado globalmente
        user.usesCustomAvatar || // Usa avatar personalizado
        user.hasCustomSkinColor || // Tiene color de piel personalizado
        user.hasCustomHairColor || // Tiene color de cabello personalizado
        user.hasCustomEyeColor || // Tiene color de ojos personalizado
        user.hasCustomGlasses; // Tiene lentes personalizados
  }

  /*
      Construir avatar normal (sin personalizaciones)
  */
  Widget _buildNormalAvatar() {
    return Image.asset(
      _avatarImagePath, // Ruta de la imagen según género
      width: size, // Ancho de la imagen
      height: size, // Alto de la imagen
      fit: BoxFit.cover, // Ajustar imagen para cubrir el espacio
      errorBuilder: (context, error, stackTrace) {
        // Manejar errores de carga
        return _buildFallbackAvatar(); // Mostrar avatar de respaldo
      },
    );
  }

  /*
      Construir avatar personalizado
      Usa una pila de widgets para aplicar overlays
  */
  Widget _buildCustomizedAvatar() {
    return Stack(
      fit: StackFit.expand, // Expandir para llenar todo el espacio
      children: [
        // 1. Imagen base (avatar normal)
        _buildNormalAvatar(),

        // 2. Overlay de color de piel (sutil) - SIEMPRE aplicarlo si es personalizado
        if (user.hasCustomSkinColor) // Condicional para mostrar overlay de piel
          Container(
            decoration: BoxDecoration(
              color: _getSkinOverlayColor(), // Color de overlay de piel
              shape: BoxShape.circle, // Forma circular
            ),
          ),

        // 3. Cabello según corte y color
        ..._buildHairOverlays(),

        // 4. Overlay de ojos (muy sutil)
        if (user.hasCustomEyeColor) // Condicional para mostrar overlay de ojos
          Positioned(
            top: size * 0.4, // 40% desde arriba (posición vertical de los ojos)
            left: size * 0.35, // 35% desde la izquierda
            child: Row(
              // Fila para los dos ojos
              children: [
                // Ojo izquierdo
                Container(
                  width: size * 0.08, // 8% del tamaño total
                  height: size * 0.08, // 8% del tamaño total
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Forma circular para el ojo
                    color: _getEyeOverlayColor(), // Color de overlay de ojos
                  ),
                ),
                SizedBox(width: size * 0.14), // Espacio entre ojos (14%)
                // Ojo derecho
                Container(
                  width: size * 0.08, // 8% del tamaño total
                  height: size * 0.08, // 8% del tamaño total
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Forma circular para el ojo
                    color: _getEyeOverlayColor(), // Color de overlay de ojos
                  ),
                ),
              ],
            ),
          ),

        // 5. Lentes (si los tiene)
        if ((user.hasGlasses || user.glassesStyle.isNotEmpty) && showEffects)
          _buildGlassesEffect(), // Condicional para mostrar lentes

        // 5.1 Sombrero / accesorio (si lo tiene)
        ..._buildAccessoryOverlays(),

        // 6. Vestimenta (si la tiene)
        ..._buildOutfitOverlays(),
      ],
    );
  }

  /*
      Construir avatar de respaldo (fallback)
      Se muestra cuando no se puede cargar la imagen principal
  */
  Widget _buildFallbackAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Forma circular
        gradient: LinearGradient(
          // Gradiente de color
          colors: [
            Colors.green[100]!, // Verde claro
            Colors.green[300]!, // Verde medio
          ],
          begin: Alignment.topLeft, // Inicio del gradiente
          end: Alignment.bottomRight, // Fin del gradiente
        ),
      ),
      child: Center(
        // Centrar contenido
        child: Icon(
          user.gender == UserGender.femenino
              ? Icons.female
              : Icons.male, // Icono según género
          size: size * 0.5, // 50% del tamaño total
          color: Colors.white, // Color blanco
        ),
      ),
    );
  }

  /*
      Construir efecto de lentes
  */
  Widget _buildGlassesEffect() {
    final eyeSpacing = size * 0.14; // Espacio entre ojos (14%)
    final eyeSize = size * 0.08; // Tamaño de cada ojo (8%)

    return Positioned(
      top: size * 0.38, // 38% desde arriba
      left: size * 0.33, // 33% desde la izquierda
      child: Container(
        width: eyeSize * 2 + eyeSpacing, // Ancho total: 2 ojos + espacio
        height: eyeSize * 1.5, // Alto: 1.5 veces el tamaño del ojo
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(eyeSize * 0.8), // Bordes redondeados
          border: Border.all(
            // Borde del marco de lentes
            color: _glassesColor().withValues(alpha: 0.85), // Color de lentes
            width: 1.5, // Ancho del borde
          ),
        ),
        child: Row(
          // Fila para los dos lentes
          mainAxisAlignment:
              MainAxisAlignment.spaceAround, // Espacio uniforme entre lentes
          children: [
            // Lente izquierdo
            Container(
              width: eyeSize * 1.1, // 10% más grande que el ojo
              height: eyeSize * 1.1, // 10% más grande que el ojo
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forma circular
                color: Colors.grey[100]!
                    .withValues(alpha: 0.1), // Color muy transparente
                border: Border.all(
                  // Borde del lente
                  color: _glassesColor().withValues(alpha: 0.6), // Color de lente
                  width: 1, // Ancho del borde
                ),
              ),
            ),
            // Lente derecho
            Container(
              width: eyeSize * 1.1, // 10% más grande que el ojo
              height: eyeSize * 1.1, // 10% más grande que el ojo
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forma circular
                color: Colors.grey[100]!
                    .withValues(alpha: 0.1), // Color muy transparente
                border: Border.all(
                  // Borde del lente
                  color: _glassesColor().withValues(alpha: 0.6), // Color de lente
                  width: 1, // Ancho del borde
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
      Colores de overlay (muy sutiles)
  */

  // Construye los overlays de cabello según el corte y color elegidos
  List<Widget> _buildHairOverlays() {
    if (user.hasCustomHairStyle) {
      return _styledHair(user.hairColor.withValues(alpha: 0.88));
    }
    if (user.hasCustomHairColor) {
      return [_tintedHair(_getHairOverlayColor())];
    }
    return const [];
  }

  // Tintado sutil del cabello (cuando solo cambió el color)
  Widget _tintedHair(Color color) {
    return Positioned(
      top: size * 0.05,
      left: size * 0.1,
      right: size * 0.1,
      child: Container(
        height: size * 0.4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.5),
            topRight: Radius.circular(size * 0.5),
            bottomLeft: Radius.circular(size * 0.1),
            bottomRight: Radius.circular(size * 0.1),
          ),
        ),
      ),
    );
  }

  // Cabello dibujado según el corte elegido
  List<Widget> _styledHair(Color color) {
    final base = Positioned(
      top: size * 0.02,
      left: size * 0.08,
      right: size * 0.08,
      child: Container(
        height: size * 0.38,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.45),
            topRight: Radius.circular(size * 0.45),
            bottomLeft: Radius.circular(size * 0.12),
            bottomRight: Radius.circular(size * 0.12),
          ),
        ),
      ),
    );

    switch (user.hairStyle) {
      case 'largo':
        return [
          base,
          Positioned(
            top: size * 0.04,
            left: size * 0.02,
            child: Container(
              width: size * 0.16,
              height: size * 0.72,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
          Positioned(
            top: size * 0.04,
            right: size * 0.02,
            child: Container(
              width: size * 0.16,
              height: size * 0.72,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
        ];
      case 'rizado':
        return [
          base,
          Positioned(
            top: 0,
            left: size * 0.16,
            right: size * 0.16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _hairBump(color),
                _hairBump(color),
                _hairBump(color),
              ],
            ),
          ),
        ];
      case 'afro':
        return [
          Positioned(
            top: 0,
            left: size * 0.18,
            right: size * 0.18,
            child: Container(
              height: size * 0.42,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ];
      default: // 'corto'
        return [base];
    }
  }

  Widget _hairBump(Color color) {
    return Container(
      width: size * 0.17,
      height: size * 0.17,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // Construye el overlay de vestimenta según el outfit elegido
  List<Widget> _buildOutfitOverlays() {
    if (!user.hasCustomOutfit) return const [];
    return [
      Positioned(
        bottom: 0,
        left: size * 0.16,
        right: size * 0.16,
        child: Container(
          height: size * 0.22,
          decoration: BoxDecoration(
            color: _outfitColor(user.outfit),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size * 0.08),
              topRight: Radius.circular(size * 0.08),
            ),
          ),
        ),
      ),
    ];
  }

  Color _outfitColor(String outfit) {
    switch (outfit) {
      case 'overol':
        return const Color(0xFF4E6E3B); // Overol verde olivo
      case 'camiseta':
        return const Color(0xFF2E7D32); // Camiseta verde
      case 'camiseta_azul':
        return const Color(0xFF1976D2); // Camiseta azul
      case 'formal':
        return const Color(0xFF42A5F5); // Camisa formal azul
      case 'chaqueta':
        return const Color(0xFF6D4C41); // Chaqueta café
      default:
        return const Color(0xFF78909C); // Gris azulado
    }
  }

  // Color del marco de lentes según el estilo elegido
  Color _glassesColor() {
    switch (user.glassesStyle) {
      case 'redonda':
        return const Color(0xFF37474F); // Negro azulado
      case 'sol':
        return const Color(0xFF212121); // Negro (gafas de sol)
      case 'deportiva':
        return const Color(0xFF1976D2); // Azul deportivo
      default:
        return Colors.grey[700]!; // Gris por defecto
    }
  }

  // Construye el sombrero/accesorio según lo equipado
  List<Widget> _buildAccessoryOverlays() {
    final accessory = user.accessory;
    if (accessory == null || accessory.isEmpty) return const [];

    switch (accessory) {
      case 'gorra':
        return [
          Positioned(
            top: size * 0.02,
            left: size * 0.16,
            right: size * 0.16,
            child: Container(
              height: size * 0.18,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.09),
                  topRight: Radius.circular(size * 0.09),
                ),
              ),
            ),
          ),
          Positioned(
            top: size * 0.16,
            left: size * 0.1,
            right: size * 0.04,
            child: Container(
              height: size * 0.04,
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20),
                borderRadius: BorderRadius.circular(size * 0.02),
              ),
            ),
          ),
        ];
      case 'sombrero_paja':
        return [
          Positioned(
            top: size * 0.01,
            left: size * 0.12,
            right: size * 0.12,
            child: Container(
              height: size * 0.16,
              decoration: const BoxDecoration(
                color: Color(0xFFF0C75E),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: size * 0.12,
            left: size * 0.02,
            right: size * 0.02,
            child: Container(
              height: size * 0.08,
              decoration: BoxDecoration(
                color: const Color(0xFFF0C75E),
                borderRadius: BorderRadius.circular(size * 0.04),
              ),
            ),
          ),
        ];
      case 'sombrero_jardinero':
        return [
          Positioned(
            top: size * 0.01,
            left: size * 0.1,
            right: size * 0.1,
            child: Container(
              height: size * 0.16,
              decoration: BoxDecoration(
                color: const Color(0xFF4E6E3B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.08),
                  topRight: Radius.circular(size * 0.08),
                ),
              ),
            ),
          ),
          Positioned(
            top: size * 0.13,
            left: size * 0.02,
            right: size * 0.02,
            child: Container(
              height: size * 0.05,
              decoration: BoxDecoration(
                color: const Color(0xFF3E5C2F),
                borderRadius: BorderRadius.circular(size * 0.03),
              ),
            ),
          ),
        ];
      default:
        return const [];
    }
  }

  // Obtener color de overlay de piel
  Color _getSkinOverlayColor() {
    return user.skinColor.withValues(alpha: 0.15); // Muy sutil (15% opacidad)
  }

  // Obtener color de overlay de cabello
  Color _getHairOverlayColor() {
    return user.hairColor
        .withValues(alpha: 0.25); // Un poco más visible (25% opacidad)
  }

  // Obtener color de overlay de ojos
  Color _getEyeOverlayColor() {
    return user.eyeColor
        .withValues(alpha: 0.4); // Moderadamente visible (40% opacidad)
  }

  /*
      Getter para la ruta de la imagen
      Devuelve la ruta según el género del usuario
  */
  String get _avatarImagePath {
    return user.gender == UserGender.femenino
        ? 'lib/images/avatar_femenino.png' // Ruta para avatar femenino
        : 'lib/images/avatar_masculino.png'; // Ruta para avatar masculino
  }
}
