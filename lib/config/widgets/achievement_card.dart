import 'package:flutter/material.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final bool isEquipped;
  final VoidCallback? onTap;
  final VoidCallback? onEquip;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.isUnlocked = false,
    this.isEquipped = false,
    this.onTap,
    this.onEquip,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final color = _getColor(achievement.color);

    return Card(
      elevation: isEquipped ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isEquipped ? color : Colors.transparent,
          width: isEquipped ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: isUnlocked ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con icono y título
              Row(
                children: [
                  // Icono del logro
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(isUnlocked ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(isUnlocked ? 0.5 : 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        achievement.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Título y descripción
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: AppFont.titleSmall.copyWith(
                            color: isUnlocked ? color : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          achievement.description,
                          style: AppFont.bodySmall.copyWith(
                            color: isUnlocked
                                ? Colors.grey[700]
                                : Colors.grey[500],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Estado (bloqueado/desbloqueado)
                  Icon(
                    isUnlocked ? Icons.verified : Icons.lock_outline,
                    color: isUnlocked ? color : Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progreso (solo si no está desbloqueado)
              if (!isUnlocked && achievement.totalRequired > 1)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: achievement.progressPercentage,
                      backgroundColor: Colors.grey[200],
                      color: color,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${achievement.currentProgress}/${achievement.totalRequired}',
                          style: AppFont.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${(achievement.progressPercentage * 100).toStringAsFixed(0)}%',
                          style: AppFont.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              // Puntos y nivel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Puntos
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: goldenSun),
                        const SizedBox(width: 4),
                        Text(
                          '+${achievement.requiredPoints}',
                          style: AppFont.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nivel del logro
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getLevelColor(achievement.level).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            _getLevelColor(achievement.level).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getLevelName(achievement.level),
                      style: AppFont.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getLevelColor(achievement.level),
                      ),
                    ),
                  ),
                ],
              ),

              // Botón para equipar (solo si está desbloqueado y no está equipado)
              if (isUnlocked && !isEquipped && onEquip != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onEquip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Usar como título'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'freshMint':
        return freshMint;
      case 'clearBlue':
        return clearBlue;
      case 'sunflower':
        return sunflower;
      case 'goldenSun':
        return goldenSun;
      case 'berryPink':
        return berryPink;
      case 'emeraldLeaf':
        return emeraldLeaf;
      case 'forestDepth':
        return forestDepth;
      default:
        return freshMint;
    }
  }

  Color _getLevelColor(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return const Color(0xFFCD7F32);
      case AchievementLevel.silver:
        return const Color(0xFFC0C0C0);
      case AchievementLevel.gold:
        return const Color(0xFFFFD700);
      case AchievementLevel.platinum:
        return const Color(0xFFE5E4E2);
      case AchievementLevel.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  String _getLevelName(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return 'Bronce';
      case AchievementLevel.silver:
        return 'Plata';
      case AchievementLevel.gold:
        return 'Oro';
      case AchievementLevel.platinum:
        return 'Platino';
      case AchievementLevel.diamond:
        return 'Diamante';
    }
  }
}
