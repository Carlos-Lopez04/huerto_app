// widgets/avatar_widget.dart
import 'package:flutter/material.dart';
import 'package:huerto_app/models/avatar_model.dart';

class AvatarWidget extends StatelessWidget {
  final AvatarModel avatar;
  final double size;
  final bool showBorder;
  final Color borderColor;

  const AvatarWidget({
    super.key,
    required this.avatar,
    this.size = 100.0,
    this.showBorder = true,
    this.borderColor = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBorder
          ? BoxDecoration(
              color: avatar.skinColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: size * 0.03,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : BoxDecoration(
              color: avatar.skinColor,
              shape: BoxShape.circle,
            ),
      child: Stack(
        children: [
          // Cabello
          Positioned(
            top: size * 0.05,
            left: size * 0.1,
            right: size * 0.1,
            child: Container(
              height: size * 0.25,
              decoration: BoxDecoration(
                color: avatar.hairColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.15),
                  topRight: Radius.circular(size * 0.15),
                  bottomLeft: Radius.circular(size * 0.05),
                  bottomRight: Radius.circular(size * 0.05),
                ),
              ),
            ),
          ),

          // Ojos
          Positioned(
            top: size * 0.35,
            child: Row(
              children: [
                SizedBox(width: size * 0.25),
                _buildEye(size * 0.08),
                SizedBox(width: size * 0.1),
                _buildEye(size * 0.08),
              ],
            ),
          ),

          // Boca
          Positioned(
            bottom: size * 0.25,
            left: size * 0.35,
            child: Container(
              width: size * 0.3,
              height: size * 0.05,
              decoration: BoxDecoration(
                color: Colors.pink[300],
                borderRadius: BorderRadius.circular(size * 0.02),
              ),
            ),
          ),

          // Lentes (opcional)
          if (avatar.hasGlasses)
            Positioned(
              top: size * 0.33,
              left: size * 0.2,
              child: Container(
                width: size * 0.6,
                height: size * 0.1,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.black,
                    width: size * 0.015,
                  ),
                  borderRadius: BorderRadius.circular(size * 0.05),
                ),
              ),
            ),

          // Decoración de rango (opcional)
          if (avatar.outfit != null)
            Positioned(
              bottom: 0,
              child: Container(
                width: size * 0.8,
                height: size * 0.2,
                decoration: BoxDecoration(
                  color: _getOutfitColor(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size * 0.1),
                    topRight: Radius.circular(size * 0.1),
                  ),
                ),
                child: Center(
                  child: Text(
                    avatar.outfit!,
                    style: TextStyle(
                      fontSize: size * 0.07,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEye(double eyeSize) {
    return Container(
      width: eyeSize,
      height: eyeSize,
      decoration: BoxDecoration(
        color: avatar.eyeColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: eyeSize * 0.15,
        ),
      ),
      child: Center(
        child: Container(
          width: eyeSize * 0.4,
          height: eyeSize * 0.4,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Color _getOutfitColor() {
    switch (avatar.outfit) {
      case 'Semilla':
        return const Color(0xFF4CAF50);
      case 'Brote':
        return const Color(0xFF2E7D32);
      case 'Árbol':
        return const Color(0xFF1B5E20);
      case 'Bosque':
        return const Color(0xFF004D40);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}
