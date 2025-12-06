import 'package:flutter/material.dart';
import 'package:huerto_app/Themes/app_theme.dart';
import 'package:huerto_app/Themes/app_font.dart';
import 'package:huerto_app/Themes/gradients.dart';
import 'package:huerto_app/Screens/profile_screen.dart';
import 'package:huerto_app/screens/achievements_screen.dart'; // Importa la pantalla de logros
import 'package:huerto_app/models/user_model.dart';

class MenuApp {
  // Datos del usuario (estos vendrían de tu sistema de autenticación)
  static UserModel _currentUser = UserModel(
    name: 'Ana García',
    email: 'ana.garcia@huerto.com',
    title: 'Agricultor Novato',
    rank: 'Semilla',
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
              _navigateToAchievements(context); // Actualizado
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
      child: DrawerHeader(
        decoration: BoxDecoration(
          gradient: AppGradients.appBarPrimary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: cloudWhite,
              radius: 30,
              child: _currentUser.imageUrl != null &&
                      _currentUser.imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        _currentUser.imageUrl!,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 40,
                      color: forestDepth,
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              _currentUser.name,
              style: AppFont.titleMedium.copyWith(color: cloudWhite),
            ),
            Text(
              _currentUser.email,
              style: AppFont.bodySmall.copyWith(color: cloudWhite),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.workspace_premium,
                    size: 12, color: cloudWhite),
                const SizedBox(width: 4),
                Text(
                  '${_currentUser.title} • ${_currentUser.rank}',
                  style: AppFont.bodySmall.copyWith(
                    color: cloudWhite.withOpacity(0.9),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Toca para ver perfil →',
              style: AppFont.bodySmall.copyWith(
                color: cloudWhite.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ],
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
    return ListTile(
      leading: customIconPath != null
          ? Image.asset(
              customIconPath,
              width: 24,
              height: 24,
              color: forestDepth,
            )
          : Icon(icon, color: forestDepth),
      title: Text(title, style: AppFont.bodyMedium),
      onTap: onTap,
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
          },
        ),
      ),
    );
  }

  // Método para navegar a la pantalla de logros
  // En menu_app.dart, en el método _navigateToAchievements:
  static void _navigateToAchievements(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AchievementsScreen(),
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
          title: const Text('Próximamente', style: AppFont.titleMedium),
          content: const Text('Esta funcionalidad estará disponible pronto.',
              style: AppFont.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: AppFont.button),
            ),
          ],
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
          title: const Text('Cerrar Sesión', style: AppFont.titleMedium),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?',
              style: AppFont.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: AppFont.button),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: forestDepth,
                    content: Text('Sesión cerrada', style: AppFont.bodyMedium),
                  ),
                );
              },
              child: Text('Cerrar Sesión',
                  style: AppFont.button.copyWith(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Diálogo de perfil actualizado
  static void showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blancoHueso,
          title: const Text('Mi Perfil', style: AppFont.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: forestDepth,
                  radius: 40,
                  child: _currentUser.imageUrl != null &&
                          _currentUser.imageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            _currentUser.imageUrl!,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: blancoHueso,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Usuario: ${_currentUser.name}', style: AppFont.bodyMedium),
              Text('Email: ${_currentUser.email}', style: AppFont.bodySmall),
              Text('Título: ${_currentUser.title}', style: AppFont.bodySmall),
              Text('Rango: ${_currentUser.rank}', style: AppFont.bodySmall),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToProfile(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: forestDepth,
                  foregroundColor: blancoHueso,
                ),
                child: const Text('Ver perfil completo', style: AppFont.button),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: AppFont.button),
            ),
          ],
        );
      },
    );
  }
}
