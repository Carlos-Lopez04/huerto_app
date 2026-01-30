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
                        color: Colors.black.withOpacity(
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

        // 3. Overlay de cabello (sutil)
        if (user
            .hasCustomHairColor) // Condicional para mostrar overlay de cabello
          Positioned(
            // Posicionamiento relativo
            top: size * 0.05, // 5% desde arriba
            left: size * 0.1, // 10% desde la izquierda
            right: size * 0.1, // 10% desde la derecha
            child: Container(
              height: size * 0.4, // 40% de la altura total
              decoration: BoxDecoration(
                color: _getHairOverlayColor(), // Color de overlay de cabello
                borderRadius: BorderRadius.only(
                  // Bordes redondeados específicos
                  topLeft: Radius.circular(
                      size * 0.5), // Redondeo superior izquierdo
                  topRight:
                      Radius.circular(size * 0.5), // Redondeo superior derecho
                  bottomLeft: Radius.circular(
                      size * 0.1), // Redondeo inferior izquierdo
                  bottomRight:
                      Radius.circular(size * 0.1), // Redondeo inferior derecho
                ),
              ),
            ),
          ),

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
        if (user.hasGlasses && showEffects)
          _buildGlassesEffect(), // Condicional para mostrar lentes
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
            color: Colors.grey[700]!
                .withOpacity(0.7), // Color gris semitransparente
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
                    .withOpacity(0.1), // Color muy transparente
                border: Border.all(
                  // Borde del lente
                  color: Colors.grey[700]!
                      .withOpacity(0.5), // Color gris semitransparente
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
                    .withOpacity(0.1), // Color muy transparente
                border: Border.all(
                  // Borde del lente
                  color: Colors.grey[700]!
                      .withOpacity(0.5), // Color gris semitransparente
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

  // Obtener color de overlay de piel
  Color _getSkinOverlayColor() {
    return user.skinColor.withOpacity(0.15); // Muy sutil (15% opacidad)
  }

  // Obtener color de overlay de cabello
  Color _getHairOverlayColor() {
    return user.hairColor
        .withOpacity(0.25); // Un poco más visible (25% opacidad)
  }

  // Obtener color de overlay de ojos
  Color _getEyeOverlayColor() {
    return user.eyeColor
        .withOpacity(0.4); // Moderadamente visible (40% opacidad)
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
