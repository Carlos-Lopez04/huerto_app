import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

class ProgressWidget extends StatelessWidget {
  final int currentPoints;
  final int currentLevel;
  final double progress;
  final String title;

  const ProgressWidget({
    super.key,
    required this.currentPoints,
    required this.currentLevel,
    required this.progress,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [freshMint, emeraldLeaf],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: forestDepth.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppFont.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  'Nivel $currentLevel',
                  style: AppFont.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Barra de progreso
          Stack(
            children: [
              // Fondo de la barra
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Progreso actual
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 20,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [goldenSun, sunflower],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Texto de progreso
              Positioned.fill(
                child: Center(
                  child: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Información de puntos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '$currentPoints puntos',
                    style: AppFont.bodySmall.copyWith(color: Colors.white),
                  ),
                ],
              ),
              Text(
                '${(currentLevel * 100) - currentPoints} para siguiente nivel',
                style: AppFont.bodySmall.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
