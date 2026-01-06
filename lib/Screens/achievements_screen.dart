import 'package:flutter/material.dart';
import 'package:huerto_app/models/user_model.dart';

class AchievementsScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated; // Cambiado a no opcional

  const AchievementsScreen({
    super.key,
    required this.user,
    required this.onUserUpdated, // Ahora es requerido
  });

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late String _selectedTitle;

  // Lista de todos los logros disponibles
  final List<Map<String, dynamic>> _allAchievements = [
    {
      'id': 'beginner',
      'title': 'Novato Verde',
      'description': 'Completa tu primera planta',
      'icon': Icons.eco,
      'color': const Color(0xFF4CAF50), // freshMint
      'requirement': 'Completar tutorial',
    },
    {
      'id': 'collector',
      'title': 'Coleccionista',
      'description': 'Cuida 5 plantas diferentes',
      'icon': Icons.forest,
      'color': const Color(0xFF2E7D32), // emeraldLeaf
      'requirement': '5 plantas únicas',
    },
    {
      'id': 'expert',
      'title': 'Experto Botánico',
      'description': 'Cuida 10 plantas por 30 días',
      'icon': Icons.psychology,
      'color': const Color(0xFFFF9800), // goldenSun
      'requirement': '10 plantas x 30 días',
    },
    {
      'id': 'master',
      'title': 'Maestro Jardinero',
      'description': 'Completa todos los tipos de plantas',
      'icon': Icons.workspace_premium,
      'color': const Color(0xFF1B5E20), // forestDepth
      'requirement': 'Todas las especies',
    },
    {
      'id': 'streak',
      'title': 'Racha Dorada',
      'description': '30 días consecutivos activo',
      'icon': Icons.local_fire_department,
      'color': const Color(0xFFFFC107), // sunflower
      'requirement': '30 días seguidos',
    },
    {
      'id': 'helper',
      'title': 'Guía Verde',
      'description': 'Ayuda a 3 amigos a comenzar',
      'icon': Icons.group,
      'color': const Color(0xFF2196F3), // clearBlue
      'requirement': '3 amigos invitados',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTitle = widget.user.title;
  }

  // Obtener logros desbloqueados
  List<Map<String, dynamic>> get unlockedAchievements {
    return _allAchievements.where((achievement) {
      return widget.user.unlockedAchievements.contains(achievement['id']);
    }).toList();
  }

  // Obtener logros bloqueados
  List<Map<String, dynamic>> get lockedAchievements {
    return _allAchievements.where((achievement) {
      return !widget.user.unlockedAchievements.contains(achievement['id']);
    }).toList();
  }

  // Método para guardar cambios
  void _saveChanges() {
    final updatedUser = widget.user.copyWith(title: _selectedTitle);
    widget.onUserUpdated(updatedUser);
    Navigator.of(context).pop(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mis Logros',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_selectedTitle != widget.user.title)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _saveChanges,
              tooltip: 'Guardar cambios',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner del logro seleccionado actualmente
            _buildCurrentAchievementBanner(),

            const SizedBox(height: 24),

            // Logros desbloqueados
            if (unlockedAchievements.isNotEmpty)
              _buildAchievementsSection(
                title: 'Logros Desbloqueados',
                achievements: unlockedAchievements,
                isLocked: false,
              ),

            const SizedBox(height: 24),

            // Logros bloqueados
            if (lockedAchievements.isNotEmpty)
              _buildAchievementsSection(
                title: 'Próximos Logros',
                achievements: lockedAchievements,
                isLocked: true,
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: _selectedTitle != widget.user.title
          ? FloatingActionButton.extended(
              onPressed: _saveChanges,
              backgroundColor: const Color(0xFF2E7D32),
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Aplicar Cambios',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  // Widget para el banner del logro actual
  Widget _buildCurrentAchievementBanner() {
    final currentAchievement = _allAchievements.firstWhere(
      (a) => a['title'] == _selectedTitle,
      orElse: () => _allAchievements[0],
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE8F5E9),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      currentAchievement['color'].withOpacity(0.3),
                      currentAchievement['color'].withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  currentAchievement['icon'],
                  color: currentAchievement['color'],
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu Título Actual',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentAchievement['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Selecciona un logro para mostrarlo en tu perfil',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para sección de logros
  Widget _buildAchievementsSection({
    required String title,
    required List<Map<String, dynamic>> achievements,
    required bool isLocked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final isSelected = achievement['title'] == _selectedTitle;
            final isUnlocked = !isLocked;

            return _buildAchievementCard(
              achievement: achievement,
              isSelected: isSelected,
              isUnlocked: isUnlocked,
              onTap: isUnlocked
                  ? () {
                      setState(() {
                        _selectedTitle = achievement['title'];
                      });
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }

  // Widget para tarjeta de logro individual
  Widget _buildAchievementCard({
    required Map<String, dynamic> achievement,
    required bool isSelected,
    required bool isUnlocked,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? achievement['color'].withOpacity(0.1)
              : isUnlocked
                  ? achievement['color'].withOpacity(0.05)
                  : Colors.grey.withOpacity(0.05),
          border: Border.all(
            color: isSelected
                ? achievement['color'].withOpacity(0.8)
                : isUnlocked
                    ? achievement['color'].withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: achievement['color'].withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? achievement['color'].withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          achievement['icon'],
                          color: isUnlocked
                              ? achievement['color']
                              : Colors.grey.withOpacity(0.5),
                          size: 24,
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Título
                  Text(
                    achievement['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? (isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.black87)
                          : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Estado
                  Text(
                    isUnlocked ? 'Desbloqueado' : 'Bloqueado',
                    style: TextStyle(
                      fontSize: 11,
                      color: isUnlocked ? const Color(0xFF2E7D32) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Overlay para logros bloqueados
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Bloqueado',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
