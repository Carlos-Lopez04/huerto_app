import 'package:flutter/material.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:huerto_app/themes/gradients.dart';
import 'package:huerto_app/config/widgets/bottom_nav_custom.dart';
import 'package:huerto_app/config/widgets/achievement_card.dart';
import 'package:huerto_app/config/widgets/progress_widget.dart';

class AchievementsScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated;

  const AchievementsScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UserModel _currentUser;
  List<Achievement> _allAchievements = [];
  String _selectedTitle = '';

  // Índice para la navegación inferior
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _selectedTitle = _currentUser.title;

    // Inicializar con logros de ejemplo
    _allAchievements = AchievementUtils.getSampleAchievements();

    _tabController = TabController(
      length: AchievementCategory.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Obtener logros por categoría
  List<Achievement> _getAchievementsByCategory(AchievementCategory category) {
    return _allAchievements
        .where((achievement) => achievement.category == category)
        .toList();
  }

  // Obtener logros desbloqueados por categoría
  List<Achievement> _getUnlockedAchievementsByCategory(
      AchievementCategory category) {
    return _getAchievementsByCategory(category)
        .where((achievement) => _currentUser.hasAchievement(achievement.id))
        .toList();
  }

  // Obtener logros bloqueados por categoría
  List<Achievement> _getLockedAchievementsByCategory(
      AchievementCategory category) {
    return _getAchievementsByCategory(category)
        .where((achievement) => !_currentUser.hasAchievement(achievement.id))
        .toList();
  }

  // Equipar un logro como título
  void _equipAchievement(Achievement achievement) {
    final updatedUser = _currentUser.equipAchievement(achievement.id);
    setState(() {
      _currentUser = updatedUser;
      _selectedTitle = achievement.title;
    });

    widget.onUserUpdated(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: forestDepth,
        content: Text(
          '¡Ahora usas "${achievement.title}" como título!',
          style: AppFont.bodyMedium.copyWith(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Manejo de la navegación del bottom bar
  void _handleNavigation(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Anterior
        Navigator.pop(context);
        break;
      case 1: // Inicio
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 2: // Cuenta
        // Ya estamos en logros, no hacer nada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userStats = _currentUser.stats;
    final categories = AchievementUtils.getSampleCategories();

    return Scaffold(
      backgroundColor: blancoHueso,
      appBar: AppBar(
        title: const Text(
          'Logros y Progreso',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: forestDepth,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(_currentUser),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: freshMint,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: categories.map((category) {
            return Tab(
              text:
                  '${category.displayName} (${category.unlockedAchievements}/${category.totalAchievements})',
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Barra de progreso del nivel
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProgressWidget(
              currentPoints: _currentUser.totalPoints,
              currentLevel: _currentUser.calculatedLevel,
              progress: _currentUser.levelProgress,
              title: 'Tu Progreso de Nivel',
            ),
          ),

          // Estadísticas rápidas
          _buildQuickStats(userStats),

          // Pestañas de logros
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                final categoryEnum = _getCategoryFromName(category.name);
                return _buildCategoryTab(categoryEnum, category);
              }).toList(),
            ),
          ),
        ],
      ),
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => _handleNavigation(index, context),
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: verdeGelido,
        border: Border.all(color: emeraldLeaf.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppGradients.innerShadow,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: 'Puntos',
            value: '${_currentUser.totalPoints}',
            icon: Icons.star,
            color: goldenSun,
          ),
          _buildStatItem(
            label: 'Logros',
            value: '${_currentUser.achievements.length}',
            icon: Icons.emoji_events,
            color: freshMint,
          ),
          _buildStatItem(
            label: 'Días seguidos',
            value: '${_currentUser.consecutiveDays}',
            icon: Icons.calendar_today,
            color: clearBlue,
          ),
          _buildStatItem(
            label: 'Actividades',
            value: '${stats['totalActivities']}',
            icon: Icons.checklist,
            color: berryPink,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFont.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: forestDepth,
          ),
        ),
        Text(
          label,
          style: AppFont.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab(
      AchievementCategory category, AchievementCategoryModel categoryData) {
    final unlockedAchievements = _getUnlockedAchievementsByCategory(category);
    final lockedAchievements = _getLockedAchievementsByCategory(category);
    final totalAchievements =
        unlockedAchievements.length + lockedAchievements.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Encabezado de categoría
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AchievementUtils.getCategoryColor(category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  AchievementUtils.getCategoryColor(category).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Text(
                AchievementUtils.getCategoryEmoji(category),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AchievementUtils.getCategoryName(category),
                      style: AppFont.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AchievementUtils.getCategoryColor(category),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${unlockedAchievements.length} de $totalAchievements logros desbloqueados',
                      style: AppFont.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              CircularProgressIndicator(
                value: totalAchievements > 0
                    ? unlockedAchievements.length / totalAchievements
                    : 0,
                backgroundColor: Colors.grey[200],
                color: AchievementUtils.getCategoryColor(category),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Logros desbloqueados
        if (unlockedAchievements.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Desbloqueados',
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
              const SizedBox(height: 8),
              ...unlockedAchievements.map(
                (achievement) {
                  final isEquipped = _currentUser.title == achievement.title;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AchievementCard(
                      achievement: achievement,
                      isUnlocked: true,
                      isEquipped: isEquipped,
                      onEquip: isEquipped
                          ? null
                          : () => _equipAchievement(achievement),
                      onTap: () => _showAchievementDetails(achievement, true),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),

        // Logros por desbloquear
        if (lockedAchievements.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Por Desbloquear',
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
              const SizedBox(height: 8),
              ...lockedAchievements.map(
                (achievement) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AchievementCard(
                    achievement: achievement,
                    isUnlocked: false,
                    isEquipped: false,
                    onTap: () => _showAchievementDetails(achievement, false),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _showAchievementDetails(Achievement achievement, bool isUnlocked) {
    final levelColor = AchievementUtils.getLevelColor(achievement.level);
    final levelName = AchievementUtils.getLevelName(achievement.level);
    final categoryName = AchievementUtils.getCategoryName(achievement.category);
    final categoryColor =
        AchievementUtils.getCategoryColor(achievement.category);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        title: Row(
          children: [
            Text(achievement.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                achievement.title,
                style: AppFont.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
              style: AppFont.bodyMedium.copyWith(color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),

            // Información del logro
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: verdeGelido,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: emeraldLeaf.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                          'Categoría', categoryName, categoryColor),
                      _buildDetailItem('Nivel', levelName, levelColor),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem('Puntos',
                          '+${achievement.requiredPoints}', goldenSun),
                      _buildDetailItem(
                          'Progreso',
                          isUnlocked
                              ? 'Completado'
                              : '${achievement.currentProgress}/${achievement.totalRequired}',
                          isUnlocked ? freshMint : sunflower),
                    ],
                  ),
                ],
              ),
            ),

            // Descripción adicional si está desbloqueado
            if (isUnlocked && achievement.unlockedDescription != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: freshMint.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: freshMint.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, size: 20, color: freshMint),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          achievement.unlockedDescription!,
                          style: AppFont.bodySmall.copyWith(
                            color: emeraldLeaf,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Botón para equipar si está desbloqueado y no está equipado
            if (isUnlocked && _currentUser.title != achievement.title)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _equipAchievement(achievement);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: achievement.colorValue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.workspace_premium, size: 18),
                    label: const Text('Usar como título'),
                  ),
                ),
              ),
          ],
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

  Widget _buildDetailItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFont.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppFont.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  AchievementCategory _getCategoryFromName(String name) {
    switch (name.toLowerCase()) {
      case 'cultivo':
        return AchievementCategory.cultivo;
      case 'hábitos':
      case 'habitos':
        return AchievementCategory.habitos;
      case 'dedicación':
      case 'dedicacion':
        return AchievementCategory.dedicacion;
      case 'habilidad':
        return AchievementCategory.habilidad;
      case 'social':
        return AchievementCategory.social;
      case 'colección':
      case 'coleccion':
        return AchievementCategory.coleccion;
      default:
        return AchievementCategory.cultivo;
    }
  }
}
