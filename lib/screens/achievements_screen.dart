// screens/achievements_screen.dart - Versión simplificada
// Importa los paquetes necesarios de Flutter y los recursos de la aplicación
import 'package:flutter/material.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/achievement_model.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:huerto_app/themes/gradients.dart';
import 'package:huerto_app/config/widgets/bottom_nav_custom.dart';
import 'package:huerto_app/config/widgets/achievement_card.dart';
import 'package:huerto_app/config/widgets/progress_widget.dart';

/*
    PANTALLA DE LOGROS Y PROGRESO
*/

// Widget Stateful que muestra la pantalla de logros del usuario
class AchievementsScreen extends StatefulWidget {
  final UserModel user; // Usuario actual de la aplicación
  final Function(UserModel) onUserUpdated; // Callback para actualizar usuario

  const AchievementsScreen({
    super.key, // Llave del widget
    required this.user, // Requiere el usuario actual
    required this.onUserUpdated, // Requiere función de actualización
  });

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controlador para pestañas
  late UserModel _currentUser; // Copia local del usuario

  List<Achievement> _allAchievements = []; // Lista de todos los logros
  String _selectedTitle = ''; // Título actualmente seleccionado

  // Índice para la navegación inferior
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user; // Inicializar usuario desde props
    _selectedTitle = _currentUser.selectedTitle ?? ''; // Obtener título actual
    _allAchievements =
        AchievementUtils.getSampleAchievements(); // Cargar logros
    _tabController = TabController(
      length: AchievementCategory.values.length, // Número de pestañas
      vsync: this, // Proveedor de sincronización
    );
  }

  @override
  void dispose() {
    _tabController.dispose(); // Liberar controlador de pestañas
    super.dispose();
  }

  /*
    OBTENER LOGROS POR CATEGORÍA
  */

  // Filtra logros según su categoría
  List<Achievement> _getAchievementsByCategory(AchievementCategory category) {
    return _allAchievements
        .where((achievement) => achievement.category == category)
        .toList();
  }

  /*
    OBTENER LOGROS DESBLOQUEADOS POR CATEGORÍA
  */

  // Filtra logros desbloqueados por categoría
  List<Achievement> _getUnlockedAchievementsByCategory(
      AchievementCategory category) {
    return _getAchievementsByCategory(category)
        .where((achievement) => _currentUser.hasAchievement(achievement.id))
        .toList();
  }

  /*
    OBTENER LOGROS BLOQUEADOS POR CATEGORÍA
  */

  // Filtra logros bloqueados por categoría
  List<Achievement> _getLockedAchievementsByCategory(
      AchievementCategory category) {
    return _getAchievementsByCategory(category)
        .where((achievement) => !_currentUser.hasAchievement(achievement.id))
        .toList();
  }

  /*
    EQUIPAR UN LOGRO COMO TÍTULO
  */

  // Establece un logro como título activo del usuario
  void _equipAchievement(Achievement achievement) {
    setState(() {
      _currentUser =
          _currentUser.equipTitle(achievement.title); // Equipar título
      _selectedTitle = achievement.title; // Actualizar título seleccionado
    });

    widget.onUserUpdated(_currentUser); // Notificar actualización

    // Mostrar notificación de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: forestDepth, // Color de fondo
        content: Text(
          '¡Ahora usas "${achievement.title}" como título!', // Mensaje
          style: AppFont.bodyMedium.copyWith(color: Colors.white), // Estilo
        ),
        duration: const Duration(seconds: 2), // Duración
      ),
    );
  }

  /*
    MANEJO DE LA NAVEGACIÓN DEL BOTTOM BAR
  */

  // Controla la navegación entre pantallas
  void _handleNavigation(int index, BuildContext context) {
    setState(() {
      _currentIndex = index; // Actualizar índice activo
    });

    switch (index) {
      case 0: // Anterior
        Navigator.pop(context); // Regresar a pantalla anterior
        break;
      case 1: // Inicio
        Navigator.popUntil(context, (route) => route.isFirst); // Ir al inicio
        break;
      case 2: // Cuenta
        // Ya estamos en logros, no hacer nada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        AchievementUtils.getSampleCategories(); // Obtener categorías

    return Scaffold(
      backgroundColor: blancoHueso, // Fondo blanco hueso
      appBar: AppBar(
        title: const Text(
          'Logros y Progreso', // Título de la AppBar
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: forestDepth, // Color verde bosque
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.white), // Botón atrás
          onPressed: () => Navigator.of(context).pop(), // Regresar
        ),
        bottom: TabBar(
          controller: _tabController, // Controlador de pestañas
          isScrollable: true, // Permite desplazamiento horizontal
          indicatorColor: freshMint, // Color del indicador
          labelColor: Colors.white, // Color de etiqueta activa
          unselectedLabelColor: Colors.white70, // Color de etiqueta inactiva
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold), // Estilo activo
          tabs: categories.map((category) {
            final categoryEnum =
                _getCategoryFromName(category.name); // Convertir nombre a enum
            final unlocked = _getUnlockedAchievementsByCategory(categoryEnum)
                .length; // Desbloqueados
            final total =
                _getAchievementsByCategory(categoryEnum).length; // Total
            return Tab(
              text:
                  '${category.displayName} ($unlocked/$total)', // Texto con contador
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Barra de progreso del nivel
          Padding(
            padding: const EdgeInsets.all(16), // Espaciado
            child: ProgressWidget(
              currentPoints: _currentUser.totalPoints, // Puntos actuales
              currentLevel: _currentUser.level, // Nivel actual
              progress: _currentUser.levelProgress, // Progreso del nivel
              title: 'Tu Progreso de Nivel', // Título del widget
            ),
          ),

          // Estadísticas rápidas
          _buildQuickStats(), // Widget de estadísticas

          // Pestañas de logros
          Expanded(
            child: TabBarView(
              controller: _tabController, // Controlador
              children: categories.map((category) {
                final categoryEnum =
                    _getCategoryFromName(category.name); // Convertir
                return _buildCategoryTab(
                    categoryEnum, category); // Crear pestaña
              }).toList(),
            ),
          ),
        ],
      ),
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex, // Índice actual
        onTap: (index) => _handleNavigation(index, context), // Manejo de taps
      ),
    );
  }

  /*
    CONSTRUIR WIDGET DE ESTADÍSTICAS RÁPIDAS
  */

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12), // Espaciado interno
      decoration: BoxDecoration(
        color: verdeGelido, // Color de fondo verde claro
        border: Border.all(color: emeraldLeaf.withOpacity(0.2)), // Borde sutil
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        boxShadow: AppGradients.innerShadow, // Sombra interna
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16), // Margen horizontal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Espaciado uniforme
        children: [
          _buildStatItem(
            label: 'Puntos', // Etiqueta
            value: '${_currentUser.totalPoints}', // Valor
            icon: Icons.star, // Icono
            color: goldenSun, // Color dorado
          ),
          _buildStatItem(
            label: 'Logros',
            value: '${_currentUser.unlockedAchievementsCount}',
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
            value: '${_currentUser.totalActivitiesCompleted}',
            icon: Icons.checklist,
            color: berryPink,
          ),
        ],
      ),
    );
  }

  /*
    CONSTRUIR ITEM DE ESTADÍSTICA INDIVIDUAL
  */

  Widget _buildStatItem({
    required String label, // Nombre de la estadística
    required String value, // Valor numérico
    required IconData icon, // Icono representativo
    required Color color, // Color del icono
  }) {
    return Column(
      children: [
        Container(
          width: 36, // Ancho fijo
          height: 36, // Alto fijo
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // Fondo con opacidad
            shape: BoxShape.circle, // Forma circular
            border: Border.all(color: color.withOpacity(0.3)), // Borde sutil
          ),
          child: Icon(icon, size: 18, color: color), // Icono centrado
        ),
        const SizedBox(height: 4), // Espaciado
        Text(
          value, // Valor numérico
          style: AppFont.bodyMedium.copyWith(
            fontWeight: FontWeight.bold, // Negrita
            color: forestDepth, // Color verde oscuro
          ),
        ),
        Text(
          label, // Etiqueta descriptiva
          style: AppFont.bodySmall.copyWith(
            color: Colors.grey[600], // Color gris
          ),
        ),
      ],
    );
  }

  /*
    CONSTRUIR PESTAÑA DE CATEGORÍA DE LOGROS
  */

  Widget _buildCategoryTab(
      AchievementCategory category, AchievementCategoryModel categoryData) {
    final unlockedAchievements =
        _getUnlockedAchievementsByCategory(category); // Logros desbloqueados
    final lockedAchievements =
        _getLockedAchievementsByCategory(category); // Logros bloqueados
    final totalAchievements =
        unlockedAchievements.length + lockedAchievements.length; // Total

    return ListView(
      padding: const EdgeInsets.all(16), // Espaciado interno
      children: [
        // Encabezado de categoría
        Container(
          padding: const EdgeInsets.all(12), // Espaciado interno
          decoration: BoxDecoration(
            color: AchievementUtils.getCategoryColor(category)
                .withOpacity(0.1), // Fondo semitransparente
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
            border: Border.all(
              color: AchievementUtils.getCategoryColor(category)
                  .withOpacity(0.3), // Borde
            ),
          ),
          child: Row(
            children: [
              Text(
                AchievementUtils.getCategoryEmoji(
                    category), // Emoji de categoría
                style: const TextStyle(fontSize: 24), // Tamaño grande
              ),
              const SizedBox(width: 12), // Espaciado
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineación izquierda
                  children: [
                    Text(
                      AchievementUtils.getCategoryName(
                          category), // Nombre de categoría
                      style: AppFont.titleSmall.copyWith(
                        fontWeight: FontWeight.bold, // Negrita
                        color: AchievementUtils.getCategoryColor(
                            category), // Color de categoría
                      ),
                    ),
                    const SizedBox(height: 4), // Espaciado pequeño
                    Text(
                      '${unlockedAchievements.length} de $totalAchievements logros desbloqueados', // Contador
                      style: AppFont.bodySmall.copyWith(
                        color: Colors.grey[600], // Color gris
                      ),
                    ),
                  ],
                ),
              ),
              CircularProgressIndicator(
                value: totalAchievements > 0
                    ? unlockedAchievements.length /
                        totalAchievements // Progreso
                    : 0,
                backgroundColor: Colors.grey[200], // Fondo gris
                color: AchievementUtils.getCategoryColor(
                    category), // Color de progreso
              ),
            ],
          ),
        ),

        const SizedBox(height: 16), // Espaciado

        // Logros desbloqueados
        if (unlockedAchievements.isNotEmpty) // Solo si hay desbloqueados
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Desbloqueados', // Título de sección
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
              const SizedBox(height: 8), // Espaciado
              ...unlockedAchievements.map(
                // Iterar sobre logros desbloqueados
                (achievement) {
                  final isEquipped = _selectedTitle ==
                      achievement.title; // Verificar si está equipado
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12), // Espaciado inferior
                    child: AchievementCard(
                      achievement: achievement, // Logro
                      isUnlocked: true, // Ya desbloqueado
                      isEquipped: isEquipped, // Estado de equipado
                      onEquip: isEquipped
                          ? null // Si ya está equipado, no permitir equipar
                          : () =>
                              _equipAchievement(achievement), // Función equipar
                      onTap: () => _showAchievementDetails(
                          achievement, true), // Mostrar detalles
                    ),
                  );
                },
              ),
              const SizedBox(height: 24), // Espaciado mayor
            ],
          ),

        // Logros por desbloquear
        if (lockedAchievements.isNotEmpty) // Solo si hay bloqueados
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Por Desbloquear', // Título de sección
                style: AppFont.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
              const SizedBox(height: 8), // Espaciado
              ...lockedAchievements.map(
                // Iterar sobre logros bloqueados
                (achievement) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: 12), // Espaciado inferior
                  child: AchievementCard(
                    achievement: achievement, // Logro
                    isUnlocked: false, // No desbloqueado
                    isEquipped: false, // No equipado
                    onTap: () => _showAchievementDetails(
                        achievement, false), // Mostrar detalles
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  /*
    MOSTRAR DETALLES DEL LOGRO
  */

  void _showAchievementDetails(Achievement achievement, bool isUnlocked) {
    final levelColor =
        AchievementUtils.getLevelColor(achievement.level); // Color del nivel
    final levelName =
        AchievementUtils.getLevelName(achievement.level); // Nombre del nivel
    final categoryName = AchievementUtils.getCategoryName(
        achievement.category); // Nombre categoría
    final categoryColor = AchievementUtils.getCategoryColor(
        achievement.category); // Color categoría

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso, // Fondo blanco hueso
        title: Row(
          children: [
            Text(achievement.icon,
                style: const TextStyle(fontSize: 24)), // Icono
            const SizedBox(width: 12), // Espaciado
            Expanded(
              child: Text(
                achievement.title, // Título del logro
                style: AppFont.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Tamaño mínimo
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda
          children: [
            Text(
              achievement.description, // Descripción del logro
              style: AppFont.bodyMedium
                  .copyWith(color: Colors.grey[700]), // Estilo
            ),

            const SizedBox(height: 16), // Espaciado

            // Información del logro
            Container(
              padding: const EdgeInsets.all(12), // Espaciado interno
              decoration: BoxDecoration(
                color: verdeGelido, // Fondo verde claro
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                border:
                    Border.all(color: emeraldLeaf.withOpacity(0.3)), // Borde
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Espaciado uniforme
                    children: [
                      _buildDetailItem('Categoría', categoryName,
                          categoryColor), // Item categoría
                      _buildDetailItem(
                          'Nivel', levelName, levelColor), // Item nivel
                    ],
                  ),
                  const SizedBox(height: 8), // Espaciado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                          'Puntos',
                          '+${achievement.requiredPoints}',
                          goldenSun), // Item puntos
                      _buildDetailItem(
                          'Progreso',
                          isUnlocked
                              ? 'Completado' // Si está desbloqueado
                              : '${achievement.currentProgress}/${achievement.totalRequired}', // Progreso actual
                          isUnlocked
                              ? freshMint
                              : sunflower), // Color según estado
                    ],
                  ),
                ],
              ),
            ),

            // Descripción adicional si está desbloqueado
            if (isUnlocked &&
                achievement.unlockedDescription != null) // Solo si existe
              Padding(
                padding: const EdgeInsets.only(top: 16), // Espaciado superior
                child: Container(
                  padding: const EdgeInsets.all(12), // Espaciado interno
                  decoration: BoxDecoration(
                    color: freshMint.withOpacity(0.1), // Fondo verde claro
                    borderRadius:
                        BorderRadius.circular(8), // Bordes redondeados
                    border:
                        Border.all(color: freshMint.withOpacity(0.3)), // Borde
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info,
                          size: 20, color: freshMint), // Icono info
                      const SizedBox(width: 8), // Espaciado
                      Expanded(
                        child: Text(
                          achievement
                              .unlockedDescription!, // Descripción adicional
                          style: AppFont.bodySmall.copyWith(
                            color: emeraldLeaf,
                            fontStyle: FontStyle.italic, // Cursiva
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Botón para equipar si está desbloqueado y no está equipado
            if (isUnlocked &&
                _selectedTitle != achievement.title) // Condiciones
              Padding(
                padding: const EdgeInsets.only(top: 16), // Espaciado superior
                child: SizedBox(
                  width: double.infinity, // Ancho completo
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar diálogo
                      _equipAchievement(achievement); // Equipar logro
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          achievement.colorValue, // Color del logro
                      foregroundColor: Colors.white, // Texto blanco
                      padding: const EdgeInsets.symmetric(
                          vertical: 12), // Espaciado vertical
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Bordes redondeados
                      ),
                    ),
                    icon:
                        const Icon(Icons.workspace_premium, size: 18), // Icono
                    label: const Text('Usar como título'), // Texto del botón
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cerrar diálogo
            child: const Text('Cerrar'), // Texto del botón
          ),
        ],
      ),
    );
  }

  /*
    CONSTRUIR ITEM DE DETALLE INDIVIDUAL
  */

  Widget _buildDetailItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda
      children: [
        Text(
          label, // Etiqueta (ej: "Categoría")
          style: AppFont.bodySmall.copyWith(
            color: Colors.grey[600], // Color gris
          ),
        ),
        const SizedBox(height: 2), // Espaciado muy pequeño
        Text(
          value, // Valor (ej: "Principiante")
          style: AppFont.bodyMedium.copyWith(
            fontWeight: FontWeight.bold, // Negrita
            color: color, // Color específico
          ),
        ),
      ],
    );
  }

  /*
    CONVERTIR NOMBRE DE CATEGORÍA A ENUM
  */

  AchievementCategory _getCategoryFromName(String name) {
    switch (name.toLowerCase()) {
      // Convertir a minúsculas para comparación
      case 'cultivo':
        return AchievementCategory.cultivo;
      case 'hábitos':
      case 'habitos': // Con y sin tilde
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
        return AchievementCategory.cultivo; // Valor por defecto
    }
  }
}
