// home_screen.dart
import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/config/widgets/cards_custom.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:huerto_app/config/menu_app.dart';
import 'package:huerto_app/themes/gradients.dart';
import 'package:huerto_app/screens/profile_screen.dart';
import 'package:huerto_app/screens/activity_tracking_screen.dart';
import 'package:huerto_app/screens/achievements_screen.dart';
import 'package:huerto_app/config/widgets/bottom_nav_custom.dart';
import 'package:huerto_app/config/widgets/progress_widget.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/services/activity_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controlador para el menú desplegable
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 1; // Índice para "Inicio"

  // Lista de notificaciones de logros
  final List<Map<String, dynamic>> _achievementNotifications = [];

  @override
  void initState() {
    super.initState();
    // Simular algunas notificaciones de logros
    _simulateAchievementNotifications();
  }

  void _simulateAchievementNotifications() {
    // Simular notificaciones de logros recientes
    _achievementNotifications.addAll([
      {
        'id': '1',
        'title': '¡Nuevo Logro!',
        'message': 'Has ganado "Primera Semilla"',
        'points': 25,
        'icon': '🌱',
        'color': freshMint,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      },
      {
        'id': '2',
        'title': '¡Racha Mantenida!',
        'message': '3 días consecutivos',
        'points': 30,
        'icon': '🔥',
        'color': sunflower,
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      },
    ]);
  }

  // Método para navegar a la pantalla de perfil
  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          user: MenuApp.currentUser,
          onUserUpdated: (updatedUser) {
            MenuApp.updateUser(updatedUser);
            setState(() {});
          },
        ),
      ),
    );
  }

  // Método para navegar a actividades - ACTUALIZADO
  void _navigateToActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityTrackingScreen(
          user: MenuApp.currentUser,
          onUserUpdated: (updatedUser) {
            MenuApp.updateUser(updatedUser);
            setState(() {});
            // Mostrar notificación de logros nuevos
            _showAchievementNotificationsIfAny(updatedUser);
          },
        ),
      ),
    );
  }

  // Método para navegar a logros
  void _navigateToAchievements(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementsScreen(
          user: MenuApp.currentUser,
          onUserUpdated: (updatedUser) {
            MenuApp.updateUser(updatedUser);
            setState(() {});
          },
        ),
      ),
    );
  }

  // Mostrar notificaciones de logros si hay nuevos
  void _showAchievementNotificationsIfAny(UserModel user) {
    final previousAchievements =
        MenuApp.currentUser.completedAchievementIds.length;
    final newAchievements = user.completedAchievementIds.length;

    if (newAchievements > previousAchievements) {
      _showPointsNotification(25, '¡Nuevo logro desbloqueado!');
    }
  }

  // Mostrar notificación de puntos
  void _showPointsNotification(int points, [String? message]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: freshMint,
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.white),
            const SizedBox(width: 8),
            Text(message ?? '+$points puntos ganados!'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Método para completar actividad rápidamente - ACTUALIZADO
  void _completeQuickActivity(String activityId, int points) {
    // Usar el servicio actualizado
    final (updatedUser, newAchievements) =
        ActivityService.registerActivityComplete(
            MenuApp.currentUser, activityId);

    // Actualizar usuario
    MenuApp.updateUser(updatedUser);
    setState(() {});

    // Mostrar notificación de puntos
    _showPointsNotification(points);

    // Mostrar notificaciones de logros nuevos
    if (newAchievements.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        for (final achievement in newAchievements) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: achievement.colorValue,
              content: Row(
                children: [
                  Text(achievement.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '¡Nuevo logro: ${achievement.title}!',
                      style: AppFont.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
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
        // Ya estamos en home, no hacer nada
        break;
      case 2: // Cuenta
        _navigateToProfile(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = MenuApp.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: emeraldLeaf,

      // MENÚ LATERAL (DRAWER)
      drawer: MenuApp.buildDrawer(context),

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: cloudWhite),
        ),
        title: Transform.translate(
          offset: const Offset(-20, 0),
          child: Row(
            children: [
              Image.asset(
                'lib/images/app_logo.png',
                height: 50,
              ),
              const SizedBox(width: 2),
              Text(
                'Eco-Huerto',
                style: AppFont.appBarTitle.copyWith(color: cloudWhite),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.appBarPrimary,
          ),
        ),
        actions: [
          // Notificación de puntos
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: cloudWhite),
                onPressed: () => _showNotifications(context),
              ),
              if (_achievementNotifications.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: tomatoRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: cloudWhite),
            onPressed: () => _navigateToProfile(context),
          ),
        ],
      ),

      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: AppGradients.plantCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Progreso de nivel
              _buildLevelProgress(user),
              const SizedBox(height: 16),

              // Notificaciones de logros recientes
              if (_achievementNotifications.isNotEmpty)
                Column(
                  children: [
                    _buildAchievementNotifications(),
                    const SizedBox(height: 16),
                  ],
                ),

              // Cards principales
              CustomCards.plantasHuerto(context),
              const SizedBox(height: 8),
              CustomCards.calendarioSiembra(context),
              const SizedBox(height: 16),

              // Actividades rápidas - ACTUALIZADO
              _buildQuickActivities(),
              const SizedBox(height: 16),

              // Estadísticas rápidas - ACTUALIZADO
              _buildQuickStats(user),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => _handleNavigation(index, context),
      ),
    );
  }

  // Widget para mostrar progreso de nivel
  Widget _buildLevelProgress(UserModel user) {
    return ProgressWidget(
      currentPoints: user.totalPoints,
      currentLevel: user.level,
      progress: user.levelProgress,
      title: 'Tu Progreso',
    );
  }

  // Widget para notificaciones de logros
  Widget _buildAchievementNotifications() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: blancoHueso,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppGradients.cardShadow,
        border: Border.all(color: freshMint.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logros Recientes',
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _achievementNotifications.clear();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._achievementNotifications.take(2).map((notification) {
            return _buildNotificationItem(notification);
          }).toList(),
          if (_achievementNotifications.length > 2)
            TextButton(
              onPressed: () => _navigateToAchievements(context),
              child: const Text('Ver todos los logros'),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: notification['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: notification['color'].withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification['color'].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                notification['icon'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: AppFont.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: forestDepth,
                  ),
                ),
                Text(
                  notification['message'],
                  style: AppFont.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: notification['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, size: 12, color: goldenSun),
                const SizedBox(width: 4),
                Text(
                  '+${notification['points']}',
                  style: AppFont.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: goldenSun,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para actividades rápidas - ACTUALIZADO
  Widget _buildQuickActivities() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.cardPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppGradients.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Actividades Rápidas',
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: forestDepth),
                onPressed: () => _navigateToActivities(context),
                tooltip: 'Ver todas las actividades',
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: GridView.count(
              physics: const ClampingScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
              children: [
                _buildQuickActivityButton(
                  '🌱 Plantar Semilla',
                  'Planta una nueva semilla',
                  25,
                  freshMint,
                  'plant_seed',
                ),
                _buildQuickActivityButton(
                  '💧 Regar Plantas',
                  'Cuida tus plantas',
                  10,
                  clearBlue,
                  'water_plant',
                ),
                _buildQuickActivityButton(
                  '📅 Login Diario',
                  'Mantén tu racha',
                  5,
                  sunflower,
                  'daily_login',
                ),
                _buildQuickActivityButton(
                  '📤 Compartir',
                  'Comparte tu progreso',
                  15,
                  berryPink,
                  'share_garden',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActivityButton(
    String label,
    String description,
    int points,
    Color color,
    String activityId,
  ) {
    final user = MenuApp.currentUser;
    // Usar el nuevo método getActivityCount
    final count = user.getActivityCount(activityId);

    return GestureDetector(
      onTap: () => _completeQuickActivity(activityId, points),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.43,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label.split(' ')[0], // Solo el emoji
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: goldenSun),
                      const SizedBox(width: 2),
                      Text(
                        '+$points',
                        style: AppFont.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: goldenSun,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label.split(' ').sublist(1).join(' '), // Texto sin emoji
              style: AppFont.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: forestDepth,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppFont.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  count > 0 ? '$count veces' : 'Nunca',
                  style: AppFont.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.add_circle, size: 16, color: forestDepth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para estadísticas rápidas - ACTUALIZADO
  Widget _buildQuickStats(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: verdeGelido,
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppGradients.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(Icons.eco, size: 40, color: forestDepth),
              const SizedBox(height: 4),
              Text(
                'Tienda',
                style: AppFont.bodySmall.copyWith(color: forestDepth),
              ),
              Text(
                '12 plantas',
                style: AppFont.bodySmall.copyWith(
                  color: emeraldLeaf,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.attach_money, size: 40, color: forestDepth),
              const SizedBox(height: 4),
              Text(
                'Eco-money',
                style: AppFont.bodySmall.copyWith(color: forestDepth),
              ),
              Text(
                '${user.totalPoints} pts',
                style: AppFont.bodySmall.copyWith(
                  color: goldenSun,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.leaderboard, size: 40, color: forestDepth),
              const SizedBox(height: 4),
              Text(
                'Rango',
                style: AppFont.bodySmall.copyWith(color: forestDepth),
              ),
              Text(
                user.displayRank,
                style: AppFont.bodySmall.copyWith(
                  color: emeraldLeaf,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Mostrar notificaciones
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notificaciones',
                  style: AppFont.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: forestDepth,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _achievementNotifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.notifications_off,
                              size: 60, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No hay notificaciones',
                            style:
                                AppFont.bodyMedium.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _achievementNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _achievementNotifications[index];
                        return _buildNotificationItem(notification);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
