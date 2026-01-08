// config/menu_app.dart
import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:huerto_app/themes/gradients.dart';
import 'package:huerto_app/screens/profile_screen.dart';
import 'package:huerto_app/screens/achievements_screen.dart';
import 'package:huerto_app/screens/activity_tracking_screen.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/config/widgets/avatar_widget.dart';

class MenuApp {
  // Datos del usuario actual
  static UserModel _currentUser = UserModel.defaultUser(
    name: 'Ana García',
    email: 'ana.garcia@huerto.com',
  );

  // Método para actualizar el usuario desde otras pantallas
  static void updateUser(UserModel newUser) {
    _currentUser = newUser;
  }

  // Método para obtener el usuario actual
  static UserModel get currentUser => _currentUser;

  // Método para obtener el Drawer completo
  static Drawer buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: verdeGelido,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Inicio',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'Mi Perfil',
            onTap: () {
              Navigator.pop(context);
              _navigateToProfile(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.eco,
            title: 'Mis Plantas',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon(context);
            },
          ),
          _buildDrawerItem(
            customIconPath:
                'lib/images/icons/trophy_35dp_E3E3E3_FILL0_wght400_GRAD0_opsz40.png',
            title: 'Mis Logros',
            onTap: () {
              Navigator.pop(context);
              _navigateToAchievements(context);
            },
          ),
          // NUEVO: Item para seguimiento de actividades
          _buildDrawerItem(
            icon: Icons.track_changes,
            title: 'Actividades',
            onTap: () {
              Navigator.pop(context);
              _navigateToActivityTracking(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.checklist,
            title: 'Actividades Diarias',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.attach_money,
            title: 'Eco-money',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.bar_chart,
            title: 'Mi Progreso',
            onTap: () {
              Navigator.pop(context);
              _showProgressDialog(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Configuración',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon(context);
            },
          ),
          const Divider(color: Colors.grey),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: 'Cerrar Sesión',
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Encabezado del Drawer
  static Widget _buildDrawerHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _navigateToProfile(context);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.appBarPrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar y información del usuario
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AvatarWidget(
                        avatar: _currentUser.avatar,
                        size: 70,
                        borderColor: cloudWhite,
                        showBorder: true,
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: cloudWhite,
                          shape: BoxShape.circle,
                          border: Border.all(color: emeraldLeaf),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 12,
                          color: forestDepth,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentUser.name,
                          style: AppFont.titleMedium.copyWith(
                            color: cloudWhite,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentUser.email,
                          style: AppFont.bodySmall.copyWith(
                            color: cloudWhite.withOpacity(0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Título actual
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: cloudWhite.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: cloudWhite.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.workspace_premium,
                                      size: 12, color: cloudWhite),
                                  const SizedBox(width: 4),
                                  Text(
                                    _currentUser.title,
                                    style: AppFont.bodySmall.copyWith(
                                      color: cloudWhite,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Rango actual
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: cloudWhite.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: cloudWhite.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.leaderboard,
                                      size: 12, color: cloudWhite),
                                  const SizedBox(width: 4),
                                  Text(
                                    _currentUser.rank,
                                    style: AppFont.bodySmall.copyWith(
                                      color: cloudWhite,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // NUEVO: Puntos y nivel
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: goldenSun.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: goldenSun.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_currentUser.totalPoints} pts',
                                    style: AppFont.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: freshMint.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: freshMint.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.leaderboard,
                                      size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Nivel ${_currentUser.calculatedLevel}',
                                    style: AppFont.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cloudWhite.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app, size: 12, color: cloudWhite),
                    const SizedBox(width: 6),
                    Text(
                      'Toca para ver perfil completo',
                      style: AppFont.bodySmall.copyWith(
                        color: cloudWhite.withOpacity(0.9),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        size: 12, color: cloudWhite),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir items del menú
  static Widget _buildDrawerItem({
    required String title,
    required VoidCallback onTap,
    IconData? icon,
    String? customIconPath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: customIconPath != null
            ? Image.asset(
                customIconPath,
                width: 24,
                height: 24,
                color: forestDepth,
              )
            : Icon(icon, color: forestDepth),
        title: Text(
          title,
          style: AppFont.bodyMedium.copyWith(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.transparent,
        hoverColor: emeraldLeaf.withOpacity(0.1),
      ),
    );
  }

  // Método para navegar a la pantalla de perfil
  static void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          user: _currentUser,
          onUserUpdated: (updatedUser) {
            updateUser(updatedUser);
            // Notificar a la pantalla actual que se actualizó el usuario
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: forestDepth,
                  content:
                      Text('Perfil actualizado', style: AppFont.bodyMedium),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Método para navegar a la pantalla de logros
  static Future<void> _navigateToAchievements(BuildContext context) async {
    final updatedUser = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementsScreen(
          user: _currentUser,
          onUserUpdated: (UserModel user) {
            updateUser(user);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: emeraldLeaf,
                  content:
                      Text('Logros actualizados', style: AppFont.bodyMedium),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            return user;
          },
        ),
      ),
    );

    // Si recibimos un usuario actualizado, actualizamos
    if (updatedUser != null) {
      updateUser(updatedUser);
    }
  }

  // NUEVO: Método para navegar a seguimiento de actividades
  static void _navigateToActivityTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityTrackingScreen(
          user: _currentUser,
          onUserUpdated: (updatedUser) {
            updateUser(updatedUser);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: freshMint,
                  content: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '¡Actividad registrada! +10 puntos',
                        style: AppFont.bodyMedium.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Diálogo para funcionalidades próximamente
  static void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blancoHueso,
          title: const Row(
            children: [
              Icon(Icons.hourglass_top, color: sunflower),
              SizedBox(width: 8),
              Text('Próximamente', style: AppFont.titleMedium),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction, size: 50, color: goldenSun),
              const SizedBox(height: 16),
              const Text(
                'Esta funcionalidad estará disponible pronto.',
                style: AppFont.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sigue cultivando tu huerto mientras trabajamos en nuevas características.',
                style: AppFont.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido', style: AppFont.button),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        );
      },
    );
  }

  // Diálogo para cerrar sesión
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blancoHueso,
          title: const Row(
            children: [
              Icon(Icons.logout, color: tomatoRed),
              SizedBox(width: 8),
              Text('Cerrar Sesión', style: AppFont.titleMedium),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarWidget(
                avatar: _currentUser.avatar,
                size: 60,
                borderColor: tomatoRed.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Estás seguro de que quieres cerrar sesión?',
                style: AppFont.bodyMedium.copyWith(
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '¡Vuelve pronto para seguir cuidando tu huerto!',
                style: AppFont.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Mostrar estadísticas antes de cerrar sesión
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: verdeGelido,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildStatRow(
                        'Puntos totales', '${_currentUser.totalPoints}'),
                    _buildStatRow(
                        'Logros', '${_currentUser.achievements.length}'),
                    _buildStatRow(
                        'Días seguidos', '${_currentUser.consecutiveDays}'),
                    _buildStatRow('Nivel', '${_currentUser.calculatedLevel}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: forestDepth,
              ),
              child: const Text('Cancelar', style: AppFont.button),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: tomatoRed,
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        );
      },
    );
  }

  // Widget auxiliar para mostrar estadísticas
  static Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppFont.bodySmall.copyWith(color: Colors.grey[600])),
          Text(value,
              style: AppFont.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: forestDepth,
              )),
        ],
      ),
    );
  }

  // Método para realizar el logout
  static void _performLogout(BuildContext context) {
    // Mostrar snackbar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: forestDepth,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Sesión cerrada - ¡Hasta pronto, ${_currentUser.name}!',
              style: AppFont.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Aquí iría la lógica real de logout (limpiar tokens, etc.)
    // Por ahora solo mostramos el mensaje y regresamos al home
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // NUEVO: Diálogo para mostrar progreso
  static void _showProgressDialog(BuildContext context) {
    final user = _currentUser;
    final stats = user.stats;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        title: const Row(
          children: [
            Icon(Icons.bar_chart, color: forestDepth),
            SizedBox(width: 8),
            Text('Mi Progreso', style: AppFont.titleMedium),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de progreso del nivel
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [freshMint, emeraldLeaf],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nivel ${user.calculatedLevel}',
                          style: AppFont.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${user.totalPoints} pts',
                          style: AppFont.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: user.levelProgress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: Colors.white,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progreso: ${(user.levelProgress * 100).toStringAsFixed(0)}%',
                          style:
                              AppFont.bodySmall.copyWith(color: Colors.white70),
                        ),
                        Text(
                          '${user.pointsToNextLevel} pts para nivel ${user.calculatedLevel + 1}',
                          style:
                              AppFont.bodySmall.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Estadísticas detalladas
              Text(
                'Estadísticas Detalladas',
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _buildStatCard(
                    'Logros Desbl.',
                    '${user.achievements.length}',
                    Icons.emoji_events,
                    freshMint,
                  ),
                  _buildStatCard(
                    'Días Seguidos',
                    '${user.consecutiveDays}',
                    Icons.calendar_today,
                    sunflower,
                  ),
                  _buildStatCard(
                    'Actividades Tot.',
                    '${stats['totalActivities']}',
                    Icons.checklist,
                    clearBlue,
                  ),
                  _buildStatCard(
                    'Login Hoy',
                    user.hasLoggedInToday ? 'Sí' : 'No',
                    Icons.login,
                    user.hasLoggedInToday ? emeraldLeaf : Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Actividades más comunes
              if (user.activityCounts.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actividades Frecuentes',
                      style: AppFont.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: forestDepth,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...user.activityCounts.entries
                        .where((entry) => entry.value > 0)
                        .take(3)
                        .map((entry) =>
                            _buildActivityItem(entry.key, entry.value))
                        .toList(),
                  ],
                ),

              const SizedBox(height: 16),

              // Botón para ver más detalles
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToActivityTracking(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: forestDepth,
                    foregroundColor: blancoHueso,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.timeline, size: 18),
                  label: const Text('Ver Progreso Detallado'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: AppFont.button),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),
    );
  }

  static Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppFont.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: AppFont.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: forestDepth,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildActivityItem(String activityId, int count) {
    final activityNames = {
      'plant_seed': 'Plantar Semilla',
      'water_plant': 'Regar Plantas',
      'daily_login': 'Login Diario',
      'share_garden': 'Compartir Huerto',
      'harvest_plant': 'Cosechar',
    };

    final activityIcons = {
      'plant_seed': Icons.eco,
      'water_plant': Icons.water_drop,
      'daily_login': Icons.login,
      'share_garden': Icons.share,
      'harvest_plant': Icons.grass,
    };

    final activityColors = {
      'plant_seed': freshMint,
      'water_plant': clearBlue,
      'daily_login': sunflower,
      'share_garden': berryPink,
      'harvest_plant': goldenSun,
    };

    final name = activityNames[activityId] ?? activityId;
    final icon = activityIcons[activityId] ?? Icons.help;
    final color = activityColors[activityId] ?? forestDepth;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name, style: AppFont.bodySmall),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count veces',
              style: AppFont.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
