// config/widgets/avatar_widget.dart - VERSIÓN CORREGIDA
import 'package:flutter/material.dart';
import 'package:huerto_app/models/user_model.dart';

class AvatarWidget extends StatelessWidget {
  final UserModel user;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  final bool showBorder;
  final bool showEffects;

  const AvatarWidget({
    super.key,
    required this.user,
    this.size = 100,
    this.borderColor,
    this.borderWidth = 3,
    this.showBorder = false,
    this.showEffects = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? Colors.green,
                width: borderWidth,
              ),
              boxShadow: showEffects
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            )
          : null,
      child: ClipOval(
        child: _buildAvatar(),
      ),
    );
  }

  Widget _buildAvatar() {
    // Si el avatar está personalizado, mostrar versión personalizada
    if (_shouldShowCustomizedAvatar()) {
      return _buildCustomizedAvatar();
    }

    // Si no está personalizado, mostrar imagen normal
    return _buildNormalAvatar();
  }

  // Determinar si mostrar avatar personalizado
  bool _shouldShowCustomizedAvatar() {
    return user.isAvatarCustomized ||
        user.usesCustomAvatar ||
        user.hasCustomSkinColor ||
        user.hasCustomHairColor ||
        user.hasCustomEyeColor ||
        user.hasCustomGlasses;
  }

  Widget _buildNormalAvatar() {
    return Image.asset(
      _avatarImagePath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackAvatar();
      },
    );
  }

  Widget _buildCustomizedAvatar() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Imagen base
        _buildNormalAvatar(),

        // 2. Overlay de color de piel (sutil) - SIEMPRE aplicarlo si es personalizado
        if (user.hasCustomSkinColor)
          Container(
            decoration: BoxDecoration(
              color: _getSkinOverlayColor(),
              shape: BoxShape.circle,
            ),
          ),

        // 3. Overlay de cabello (sutil)
        if (user.hasCustomHairColor)
          Positioned(
            top: size * 0.05,
            left: size * 0.1,
            right: size * 0.1,
            child: Container(
              height: size * 0.4,
              decoration: BoxDecoration(
                color: _getHairOverlayColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.5),
                  topRight: Radius.circular(size * 0.5),
                  bottomLeft: Radius.circular(size * 0.1),
                  bottomRight: Radius.circular(size * 0.1),
                ),
              ),
            ),
          ),

        // 4. Overlay de ojos (muy sutil)
        if (user.hasCustomEyeColor)
          Positioned(
            top: size * 0.4,
            left: size * 0.35,
            child: Row(
              children: [
                // Ojo izquierdo
                Container(
                  width: size * 0.08,
                  height: size * 0.08,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getEyeOverlayColor(),
                  ),
                ),
                SizedBox(width: size * 0.14),
                // Ojo derecho
                Container(
                  width: size * 0.08,
                  height: size * 0.08,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getEyeOverlayColor(),
                  ),
                ),
              ],
            ),
          ),

        // 5. Lentes (si los tiene)
        if (user.hasGlasses && showEffects) _buildGlassesEffect(),
      ],
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.green[100]!,
            Colors.green[300]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          user.gender == UserGender.femenino ? Icons.female : Icons.male,
          size: size * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGlassesEffect() {
    final eyeSpacing = size * 0.14;
    final eyeSize = size * 0.08;

    return Positioned(
      top: size * 0.38,
      left: size * 0.33,
      child: Container(
        width: eyeSize * 2 + eyeSpacing,
        height: eyeSize * 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(eyeSize * 0.8),
          border: Border.all(
            color: Colors.grey[700]!.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Lente izquierdo
            Container(
              width: eyeSize * 1.1,
              height: eyeSize * 1.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100]!.withOpacity(0.1),
                border: Border.all(
                  color: Colors.grey[700]!.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            // Lente derecho
            Container(
              width: eyeSize * 1.1,
              height: eyeSize * 1.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100]!.withOpacity(0.1),
                border: Border.all(
                  color: Colors.grey[700]!.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Colores de overlay (muy sutiles)
  Color _getSkinOverlayColor() {
    return user.skinColor.withOpacity(0.15); // Muy sutil
  }

  Color _getHairOverlayColor() {
    return user.hairColor.withOpacity(0.25); // Un poco más visible
  }

  Color _getEyeOverlayColor() {
    return user.eyeColor.withOpacity(0.4); // Moderadamente visible
  }

  // Getter para la ruta de la imagen
  String get _avatarImagePath {
    return user.gender == UserGender.femenino
        ? 'lib/images/avatar_femenino.png'
        : 'lib/images/avatar_masculino.png';
  }
}
