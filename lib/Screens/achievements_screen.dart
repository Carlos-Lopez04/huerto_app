import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../services/achievement_service.dart';
import '../Themes/app_theme.dart';
import '../Themes/app_font.dart';
import '../Themes/gradients.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AchievementCategory> _categories = [];
  AchievementStats _stats = const AchievementStats(
    totalAchievements: 0,
    unlockedAchievements: 0,
    totalPoints: 0,
    currentLevel: 'Semilla',
    achievementsByCategory: {},
    achievementsByLevel: {},
  );
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadAchievementsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievementsData() async {
    try {
      final categories = await AchievementService.getCategories();
      final stats = await AchievementService.getStats();

      setState(() {
        _categories = categories;
        _stats = stats;
        _isLoading = false;
        _errorMessage = '';

        // Actualizar el controlador de forma segura
        _tabController.dispose();
        _tabController = TabController(
            length: _categories.isNotEmpty ? _categories.length + 1 : 1,
            vsync: this);
      });
    } catch (e) {
      print('Error loading achievements: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los logros: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: verdeGelido,
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage.isNotEmpty
              ? _buildErrorView()
              : _buildMainContent(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(forestDepth),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando logros...',
            style: AppFont.bodyMedium.copyWith(color: forestDepth),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Error al cargar',
              style: AppFont.titleMedium.copyWith(color: forestDepth),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: AppFont.bodySmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadAchievementsData,
              style: ElevatedButton.styleFrom(
                backgroundColor: forestDepth,
                foregroundColor: blancoHueso,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildAppBar(),
          if (_categories.isNotEmpty) _buildStatsHeader(),
          if (_categories.isNotEmpty) _buildTabBar(),
        ];
      },
      body: _categories.isNotEmpty ? _buildTabViews() : _buildEmptyView(),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay logros disponibles',
            style: AppFont.titleMedium.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Los logros se cargarán próximamente',
            style: AppFont.bodySmall.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: forestDepth,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Logros',
          style: AppFont.appBarTitle.copyWith(color: Colors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.appBarPrimary,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildStatsHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: blancoHueso,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Completados',
                    '${_stats.unlockedAchievements}/${_stats.totalAchievements}'),
                _buildStatItem('Puntos', '${_stats.totalPoints}'),
                _buildStatItem('Nivel', _stats.currentLevel),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _stats.progressPercentage / 100,
              backgroundColor: Colors.green[100],
              valueColor: const AlwaysStoppedAnimation<Color>(forestDepth),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${_stats.progressPercentage.toStringAsFixed(1)}% completado',
              style: AppFont.bodyMedium.copyWith(
                color: forestDepth,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppFont.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: forestDepth,
          ),
        ),
        Text(
          title,
          style: AppFont.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildTabBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: blancoHueso,
      automaticallyImplyLeading: false,
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: forestDepth,
        unselectedLabelColor: Colors.grey,
        indicatorColor: forestDepth,
        tabs: [
          const Tab(text: 'Todos'),
          ..._categories.map((category) => Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.emoji),
                    const SizedBox(width: 4),
                    Text(category.name),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  TabBarView _buildTabViews() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllAchievementsView(),
        ..._categories.map((category) => _buildCategoryView(category)),
      ],
    );
  }

  Widget _buildAllAchievementsView() {
    final allAchievements =
        _categories.expand((category) => category.achievements).toList();

    if (allAchievements.isEmpty) {
      return _buildEmptyAchievementsView();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allAchievements.length,
      itemBuilder: (context, index) {
        final achievement = allAchievements[index];
        final isUnlocked = index < _stats.unlockedAchievements;

        return _buildAchievementCard(achievement, isUnlocked);
      },
    );
  }

  Widget _buildCategoryView(AchievementCategory category) {
    if (category.achievements.isEmpty) {
      return _buildEmptyAchievementsView();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: category.achievements.length,
      itemBuilder: (context, index) {
        final achievement = category.achievements[index];
        final isUnlocked = index < category.unlockedAchievements;

        return _buildAchievementCard(achievement, isUnlocked);
      },
    );
  }

  Widget _buildEmptyAchievementsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay logros en esta categoría',
            style: AppFont.bodyMedium.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? achievement.colorValue.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? achievement.colorValue.withOpacity(0.3)
              : Colors.grey[300]!,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isUnlocked
                ? achievement.colorValue.withOpacity(0.2)
                : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            achievement.iconData,
            color: isUnlocked ? achievement.colorValue : Colors.grey[400],
            size: 24,
          ),
        ),
        title: Text(
          achievement.title,
          style: AppFont.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: isUnlocked ? Colors.black87 : Colors.grey[600],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
              style: AppFont.bodySmall.copyWith(
                color: isUnlocked ? Colors.black54 : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: achievement.difficultyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    achievement.level,
                    style: TextStyle(
                      color: achievement.difficultyColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: achievement.rarityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    achievement.rarityBadge,
                    style: TextStyle(
                      color: achievement.rarityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${achievement.points} pts',
              style: AppFont.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? achievement.colorValue : Colors.grey[400],
              ),
            ),
            Text(
              achievement.levelEmoji,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        onTap: () {
          _showAchievementDetails(achievement, isUnlocked);
        },
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement.colorValue.withOpacity(0.2)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.iconData,
                color: isUnlocked ? achievement.colorValue : Colors.grey[400],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                achievement.title,
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.black87 : Colors.grey[600],
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
              style: AppFont.bodyMedium.copyWith(
                color: isUnlocked ? Colors.black54 : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailItem('Categoría',
                '${achievement.categoryEmoji} ${achievement.category}'),
            _buildDetailItem(
                'Nivel', '${achievement.levelEmoji} ${achievement.level}'),
            _buildDetailItem('Dificultad', achievement.difficulty),
            _buildDetailItem('Rareza', achievement.rarityBadge),
            _buildDetailItem('Puntos', '${achievement.points} pts'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Text(
                'Requisitos: ${achievement.requirements}',
                style: TextStyle(
                  color: Colors.amber[800],
                  fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppFont.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFont.bodyMedium.copyWith(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
