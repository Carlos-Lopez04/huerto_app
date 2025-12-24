import 'package:flutter/material.dart';
import 'package:huerto_app/Themes/app_theme.dart';
import 'package:huerto_app/Themes/app_font.dart';
import 'package:huerto_app/Themes/gradients.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/services/achievement_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<AchievementCategory> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    try {
      final categories = await AchievementService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando logros: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancoHueso,
      appBar: AppBar(
        title: Text(
          'Mis Logros',
          style: AppFont.appBarTitle.copyWith(color: blancoHueso),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.appBarPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blancoHueso),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildAchievementsList(),
    );
  }

  Widget _buildAchievementsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(AchievementCategory category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de categoría
            Row(
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.name,
                    style: AppFont.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: category.colorValue,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: category.colorValue.withOpacity(0.2),
                  label: Text(
                    '${category.unlockedAchievements}/${category.totalAchievements}',
                    style: AppFont.bodySmall.copyWith(
                      color: category.colorValue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Barra de progreso
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: category.progressPercentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(category.colorValue),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${category.progressPercentage.toStringAsFixed(1)}% completado',
              style: AppFont.bodySmall.copyWith(color: Colors.grey),
            ),

            // Logros
            const SizedBox(height: 16),
            Column(
              children: category.achievements
                  .take(3)
                  .map((achievement) => _buildAchievementItem(achievement))
                  .toList(),
            ),

            // Botón para ver más
            if (category.achievements.length > 3)
              TextButton(
                onPressed: () {
                  _showCategoryDetails(category);
                },
                child: Text(
                  'Ver todos los logros (${category.achievements.length})',
                  style: AppFont.bodySmall.copyWith(color: category.colorValue),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    final isUnlocked = achievement.id <= 11;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.getBackgroundColor(isUnlocked),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUnlocked
              ? achievement.colorValue.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Icono
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? achievement.colorValue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.iconData,
              color: achievement.getIconColor(isUnlocked),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: AppFont.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: achievement.getTextColor(isUnlocked),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: AppFont.bodySmall.copyWith(
                    color: isUnlocked ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Puntos
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? achievement.colorValue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: isUnlocked ? achievement.colorValue : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${achievement.points} pts',
                  style: AppFont.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: achievement.getTextColor(isUnlocked),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryDetails(AchievementCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(category.emoji),
            const SizedBox(width: 8),
            Text(category.name),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: category.achievements.length,
            itemBuilder: (context, index) {
              final achievement = category.achievements[index];
              final isUnlocked = achievement.id <= 11;
              return ListTile(
                leading: Icon(
                  achievement.iconData,
                  color: isUnlocked ? achievement.colorValue : Colors.grey,
                ),
                title: Text(
                  achievement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.black : Colors.grey,
                  ),
                ),
                subtitle: Text(achievement.description),
                trailing: Chip(
                  label: Text('${achievement.points} pts'),
                  backgroundColor: isUnlocked
                      ? achievement.colorValue.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
