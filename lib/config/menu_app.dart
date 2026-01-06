// config/menu_app.dart
import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:huerto_app/themes/gradients.dart';
import 'package:huerto_app/Screens/profile_screen.dart';
import 'package:huerto_app/Screens/achievements_screen.dart';
import 'package:huerto_app/models/user_model.dart';
// import 'package:huerto_app/models/avatar_model.dart';
import 'package:huerto_app/config/widgets/avatar_widget.dart';

class MenuApp {
  // Datos del usuario actual - USANDO UserModel.defaultUser
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
            title: 'Mis logros',
            onTap: () {
              Navigator.pop(context);
              _navigateToAchievements(context);
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
              // Avatar del usuario
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
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
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

  // Diálogo de perfil actualizado
  static void showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blancoHueso,
          title: const Row(
            children: [
              Icon(Icons.person, color: forestDepth),
              SizedBox(width: 8),
              Text('Mi Perfil', style: AppFont.titleMedium),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AvatarWidget(
                  avatar: _currentUser.avatar,
                  size: 100,
                  borderColor: emeraldLeaf,
                  showBorder: true,
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileInfo('Nombre', _currentUser.name),
              _buildProfileInfo('Email', _currentUser.email),
              _buildProfileInfo('Título', _currentUser.title),
              _buildProfileInfo('Rango', _currentUser.rank),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: verdeGelido,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: emeraldLeaf.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events,
                        size: 16, color: emeraldLeaf),
                    const SizedBox(width: 8),
                    Text(
                      'Logros desbloqueados: ${_currentUser.unlockedAchievements.length}',
                      style: AppFont.bodySmall.copyWith(
                        color: forestDepth,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToProfile(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: forestDepth,
                    foregroundColor: blancoHueso,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility, size: 18),
                      SizedBox(width: 8),
                      Text('Ver perfil completo', style: AppFont.button),
                    ],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        );
      },
    );
  }

  // Widget auxiliar para mostrar información del perfil
  static Widget _buildProfileInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: AppFont.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFont.bodySmall.copyWith(
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Método para mostrar vista previa rápida del avatar
  static void showAvatarPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.cardHighlight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppGradients.elevatedShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AvatarWidget(
                  avatar: _currentUser.avatar,
                  size: 150,
                  borderColor: emeraldLeaf,
                ),
                const SizedBox(height: 16),
                Text(
                  'Mi Avatar',
                  style: AppFont.titleMedium.copyWith(
                    color: forestDepth,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toca para personalizar',
                  style: AppFont.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToProfile(context);
                      },
                      child: const Text('Ver perfil'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToProfile(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: freshMint,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Personalizar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
