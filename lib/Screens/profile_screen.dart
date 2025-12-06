import 'package:flutter/material.dart';
import 'package:huerto_app/Themes/app_theme.dart';
import 'package:huerto_app/Themes/app_font.dart';
import 'package:huerto_app/Themes/gradients.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/config/widgets/bottom_nav_custom.dart'; // NUEVA IMPORTACIÓN

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _currentUser;
  int _currentIndex = 2; // Índice para "Cuenta"

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _updateUser(UserModel newUser) {
    setState(() {
      _currentUser = newUser;
    });
    // Notificar al padre sobre el cambio
    widget.onUserUpdated(newUser);
    _showUpdateConfirmation();
  }

  void _showUpdateConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: forestDepth,
        content: Text('Perfil actualizado', style: AppFont.bodyMedium),
        duration: Duration(seconds: 2),
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
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 2: // Cuenta
        // Ya estamos en perfil, no hacer nada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancoHueso,
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Sección de foto y información básica
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppGradients.cardPrimary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppGradients.cardShadow,
              ),
              child: Column(
                children: [
                  // Foto del usuario
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.interactiveHover,
                          border: Border.all(
                            color: emeraldLeaf,
                            width: 3,
                          ),
                        ),
                        child: _currentUser.imageUrl != null &&
                                _currentUser.imageUrl!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  _currentUser.imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: forestDepth,
                              ),
                      ),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: blancoHueso,
                          shape: BoxShape.circle,
                          border: Border.all(color: emeraldLeaf),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: forestDepth,
                          ),
                          onPressed: _changeProfilePhoto,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Nombre del usuario - ACTUALIZABLE
                  GestureDetector(
                    onTap: _editName,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentUser.name,
                          style: AppFont.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, size: 16, color: stoneGray),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Correo electrónico - ACTUALIZABLE
                  GestureDetector(
                    onTap: _editEmail,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email, size: 16, color: stoneGray),
                        const SizedBox(width: 8),
                        Text(
                          _currentUser.email,
                          style: AppFont.bodyMedium.copyWith(
                            color: stoneGray,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, size: 14, color: stoneGray),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          forestDepth.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Título y Rango
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Título
                      _buildInfoCard(
                        icon: Icons.workspace_premium,
                        title: 'Título',
                        value: _currentUser.title,
                        onTap: _navigateToAchievements,
                      ),

                      // Rango
                      _buildInfoCard(
                        icon: Icons.leaderboard,
                        title: 'Rango',
                        value: _currentUser.rank,
                        onTap: _showRankInfo,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Estadísticas rápidas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppGradients.backgroundSoft,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppGradients.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estadísticas',
                    style: AppFont.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        value: '12',
                        label: 'Plantas',
                        icon: Icons.eco,
                        color: freshMint,
                      ),
                      _buildStatItem(
                        value: '8',
                        label: 'Logros',
                        icon: Icons.emoji_events,
                        color: goldenSun,
                      ),
                      _buildStatItem(
                        value: '15',
                        label: 'Días activo',
                        icon: Icons.calendar_today,
                        color: clearBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Acciones rápidas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppGradients.cardHighlight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppGradients.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones',
                    style: AppFont.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildActionButton(
                        icon: Icons.edit,
                        label: 'Editar Perfil',
                        onTap: _editProfile,
                        color: emeraldLeaf,
                      ),
                      _buildActionButton(
                        icon: Icons.workspace_premium,
                        label: 'Ver Logros',
                        onTap: _navigateToAchievements,
                        color: goldenSun,
                      ),
                      _buildActionButton(
                        icon: Icons.settings,
                        label: 'Configuración',
                        onTap: _openSettings,
                        color: stoneGray,
                      ),
                      _buildActionButton(
                        icon: Icons.help,
                        label: 'Ayuda',
                        onTap: _showHelp,
                        color: clearBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // BOTTOM NAVIGATION BAR - AGREGADO
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => _handleNavigation(index, context),
      ),
    );
  }

  // Widget para construir las tarjetas de información (Título y Rango)
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: AppGradients.interactiveHover,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppGradients.innerShadow,
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: forestDepth),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppFont.bodySmall.copyWith(
                color: stoneGray,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppFont.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir items de estadísticas
  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppFont.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppFont.bodySmall.copyWith(
            color: stoneGray,
          ),
        ),
      ],
    );
  }

  // Widget para construir botones de acción
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppFont.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos para las acciones
  void _changeProfilePhoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar foto', style: AppFont.titleSmall),
        content: const Text('Selecciona una opción', style: AppFont.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: AppFont.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateUser(_currentUser.copyWith(
                imageUrl: 'https://example.com/nueva-foto.jpg',
              ));
            },
            child: const Text('Galería', style: AppFont.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cámara', style: AppFont.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _editName() {
    TextEditingController nameController =
        TextEditingController(text: _currentUser.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nombre', style: AppFont.titleSmall),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Ingresa tu nombre',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: AppFont.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                _updateUser(
                    _currentUser.copyWith(name: nameController.text.trim()));
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar', style: AppFont.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _editEmail() {
    TextEditingController emailController =
        TextEditingController(text: _currentUser.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar email', style: AppFont.titleSmall),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Ingresa tu email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: AppFont.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              if (emailController.text.trim().isNotEmpty) {
                _updateUser(
                    _currentUser.copyWith(email: emailController.text.trim()));
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar', style: AppFont.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _navigateToAchievements() {
    _showComingSoon(context);
  }

  void _showRankInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sistema de Rangos', style: AppFont.titleSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tu rango actual: ${_currentUser.rank}',
                style: AppFont.bodyMedium),
            const SizedBox(height: 16),
            const Text('• Semilla - Nivel inicial', style: AppFont.bodySmall),
            const Text('• Brote - 10 plantas cultivadas',
                style: AppFont.bodySmall),
            const Text('• Árbol - 25 plantas cultivadas',
                style: AppFont.bodySmall),
            const Text('• Bosque - 50+ plantas cultivadas',
                style: AppFont.bodySmall),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido', style: AppFont.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    _editName();
  }

  void _openSettings() {
    _showComingSoon(context);
  }

  void _showHelp() {
    _showComingSoon(context);
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: sunflower,
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
}
