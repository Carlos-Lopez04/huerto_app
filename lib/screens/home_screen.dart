// home_screen.dart
import 'package:flutter/material.dart'; // Importar framework de Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Importar tema de la aplicación
import 'package:huerto_app/config/widgets/cards_custom.dart'; // Importar widgets de tarjetas personalizadas
import 'package:huerto_app/themes/app_font.dart'; // Importar fuentes de la aplicación
import 'package:huerto_app/config/menu_app.dart'; // Importar menú de la aplicación
import 'package:huerto_app/themes/gradients.dart'; // Importar gradientes
import 'package:huerto_app/screens/profile_screen.dart'; // Importar pantalla de perfil
import 'package:huerto_app/screens/activity_tracking_screen.dart'; // Importar pantalla de seguimiento de actividades
import 'package:huerto_app/screens/achievements_screen.dart'; // Importar pantalla de logros
import 'package:huerto_app/config/widgets/bottom_nav_custom.dart'; // Importar navegación inferior personalizada
import 'package:huerto_app/config/widgets/progress_widget.dart'; // Importar widget de progreso
import 'package:huerto_app/models/user_model.dart'; // Importar modelo de usuario
import 'package:huerto_app/services/activity_service.dart'; // Importar servicio de actividades

/*
    PANTALLA PRINCIPAL DE INICIO - ESTADO MUTABLE
*/
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // Constructor con llave opcional

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState(); // Crear estado de la pantalla
}

/*
    ESTADO DE LA PANTALLA DE INICIO
*/
class _HomeScreenState extends State<HomeScreen> {
  // Controlador para el menú desplegable
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Llave para controlar Scaffold
  int _currentIndex = 1; // Índice para "Inicio" (posición central)

  // Lista de notificaciones de logros
  final List<Map<String, dynamic>> _achievementNotifications =
      []; // Lista vacía inicialmente

  @override
  void initState() {
    super.initState(); // Llamar al initState del padre
    _simulateAchievementNotifications(); // Simular notificaciones al iniciar
  }

  /*
      SIMULAR NOTIFICACIONES DE LOGROS
  */
  void _simulateAchievementNotifications() {
    // Simular notificaciones de logros recientes
    _achievementNotifications.addAll([
      // Agregar múltiples notificaciones
      {
        'id': '1', // Identificador único
        'title': '¡Nuevo Logro!', // Título de la notificación
        'message': 'Has ganado "Primera Semilla"', // Mensaje descriptivo
        'points': 25, // Puntos ganados
        'icon': '🌱', // Icono emoji
        'color': freshMint, // Color de la notificación
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 5)), // Hace 5 minutos
      },
      {
        'id': '2', // Segundo identificador
        'title': '¡Racha Mantenida!', // Título de racha
        'message': '3 días consecutivos', // Mensaje de racha
        'points': 30, // Puntos ganados
        'icon': '🔥', // Icono de fuego
        'color': sunflower, // Color amarillo
        'timestamp':
            DateTime.now().subtract(const Duration(hours: 1)), // Hace 1 hora
      },
    ]);
  }

  /*
      MÉTODO PARA NAVEGAR A LA PANTALLA DE PERFIL
  */
  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      // Navegar a nueva pantalla
      context,
      MaterialPageRoute(
        // Ruta de pantalla de material
        builder: (context) => ProfileScreen(
          // Construir pantalla de perfil
          user: MenuApp.currentUser, // Pasar usuario actual
          onUserUpdated: (updatedUser) {
            // Callback cuando se actualiza usuario
            MenuApp.updateUser(updatedUser); // Actualizar usuario globalmente
            setState(() {}); // Forzar actualización de la interfaz
          },
        ),
      ),
    );
  }

  /*
      MÉTODO PARA NAVEGAR A ACTIVIDADES - ACTUALIZADO
  */
  void _navigateToActivities(BuildContext context) {
    Navigator.push(
      // Navegar a pantalla de actividades
      context,
      MaterialPageRoute(
        // Ruta de material
        builder: (context) => ActivityTrackingScreen(
          // Construir pantalla de actividades
          user: MenuApp.currentUser, // Pasar usuario actual
          onUserUpdated: (updatedUser) {
            // Callback cuando se actualiza usuario
            MenuApp.updateUser(updatedUser); // Actualizar usuario globalmente
            setState(() {}); // Forzar actualización de la interfaz
            // Mostrar notificación de logros nuevos
            _showAchievementNotificationsIfAny(
                updatedUser); // Verificar nuevos logros
          },
        ),
      ),
    );
  }

  /*
      MÉTODO PARA NAVEGAR A LOGROS
  */
  void _navigateToAchievements(BuildContext context) {
    Navigator.push(
      // Navegar a pantalla de logros
      context,
      MaterialPageRoute(
        // Ruta de material
        builder: (context) => AchievementsScreen(
          // Construir pantalla de logros
          user: MenuApp.currentUser, // Pasar usuario actual
          onUserUpdated: (updatedUser) {
            // Callback cuando se actualiza usuario
            MenuApp.updateUser(updatedUser); // Actualizar usuario globalmente
            setState(() {}); // Forzar actualización de la interfaz
          },
        ),
      ),
    );
  }

  /*
      MOSTRAR NOTIFICACIONES DE LOGROS SI HAY NUEVOS
  */
  void _showAchievementNotificationsIfAny(UserModel user) {
    final previousAchievements =
        MenuApp.currentUser.completedAchievementIds.length; // Logros anteriores
    final newAchievements =
        user.completedAchievementIds.length; // Logros nuevos

    if (newAchievements > previousAchievements) {
      // Si hay nuevos logros
      _showPointsNotification(
          25, '¡Nuevo logro desbloqueado!'); // Mostrar notificación
    }
  }

  /*
      MOSTRAR NOTIFICACIÓN DE PUNTOS
  */
  void _showPointsNotification(int points, [String? message]) {
    ScaffoldMessenger.of(context).showSnackBar(
      // Mostrar snackbar
      SnackBar(
        backgroundColor: freshMint, // Fondo verde menta
        content: Row(
          // Contenido en fila
          children: [
            const Icon(Icons.star, color: Colors.white), // Icono de estrella
            const SizedBox(width: 8), // Espaciador horizontal
            Text(message ??
                '+$points puntos ganados!'), // Mensaje personalizado o por defecto
          ],
        ),
        duration: const Duration(seconds: 2), // Duración de 2 segundos
      ),
    );
  }

  /*
      MÉTODO PARA COMPLETAR ACTIVIDAD RÁPIDAMENTE - ACTUALIZADO
  */
  void _completeQuickActivity(String activityId, int points) {
    // Usar el servicio actualizado
    final (updatedUser, newAchievements) =
        ActivityService.registerActivityComplete(
            // Registrar actividad completada
            MenuApp.currentUser,
            activityId); // Usuario y ID de actividad

    // Actualizar usuario
    MenuApp.updateUser(updatedUser); // Actualizar usuario globalmente
    setState(() {}); // Forzar actualización de la interfaz

    // Mostrar notificación de puntos
    _showPointsNotification(points); // Mostrar puntos ganados

    // Mostrar notificaciones de logros nuevos
    if (newAchievements.isNotEmpty) {
      // Si hay nuevos logros
      Future.delayed(const Duration(milliseconds: 500), () {
        // Retrasar 500ms
        for (final achievement in newAchievements) {
          // Para cada logro nuevo
          ScaffoldMessenger.of(context).showSnackBar(
            // Mostrar snackbar
            SnackBar(
              backgroundColor: achievement.colorValue, // Color del logro
              content: Row(
                // Contenido en fila
                children: [
                  Text(achievement.icon,
                      style: const TextStyle(fontSize: 20)), // Icono del logro
                  const SizedBox(width: 8), // Espaciador horizontal
                  Expanded(
                    // Ocupar espacio disponible
                    child: Text(
                      '¡Nuevo logro: ${achievement.title}!', // Título del logro
                      style: AppFont.bodyMedium
                          .copyWith(color: Colors.white), // Estilo de texto
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3), // Duración de 3 segundos
            ),
          );
        }
      });
    }
  }

  /*
      MANEJO DE LA NAVEGACIÓN DEL BOTTOM BAR
  */
  void _handleNavigation(int index, BuildContext context) {
    setState(() {
      // Actualizar estado
      _currentIndex = index; // Actualizar índice actual
    });

    switch (index) {
      case 0: // Anterior
        Navigator.pop(context); // Regresar a pantalla anterior
        break;
      case 1: // Inicio
        // Ya estamos en home, no hacer nada
        break;
      case 2: // Cuenta
        _navigateToProfile(context); // Navegar a perfil
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = MenuApp.currentUser; // Obtener usuario actual

    return Scaffold(
      key: _scaffoldKey, // Asignar llave al Scaffold
      backgroundColor: emeraldLeaf, // Fondo verde esmeralda

      // MENÚ LATERAL (DRAWER)
      drawer: MenuApp.buildDrawer(context), // Construir menú lateral

      appBar: AppBar(
        leading: IconButton(
          // Botón de menú lateral
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Abrir menú lateral
          },
          icon:
              const Icon(Icons.menu, color: cloudWhite), // Icono de menú blanco
        ),
        title: Transform.translate(
          // Transformar posición del título
          offset: const Offset(-20, 0), // Desplazar 20 píxeles a la izquierda
          child: Row(
            // Fila para logo y texto
            children: [
              Image.asset(
                // Imagen del logo
                'lib/images/app_logo.png', // Ruta del logo
                height: 50, // Altura del logo
              ),
              const SizedBox(width: 2), // Espaciador horizontal pequeño
              Text(
                'Eco-Huerto', // Nombre de la aplicación
                style: AppFont.appBarTitle
                    .copyWith(color: cloudWhite), // Estilo de texto
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          // Espacio flexible para gradiente
          decoration: BoxDecoration(
            gradient: AppGradients.appBarPrimary, // Gradiente de la AppBar
          ),
        ),
        actions: [
          // Acciones de la AppBar
          // Notificación de puntos
          Stack(
            // Apilar elementos para badge de notificación
            children: [
              IconButton(
                icon: const Icon(Icons.notifications,
                    color: cloudWhite), // Icono de notificaciones
                onPressed: () =>
                    _showNotifications(context), // Mostrar notificaciones
              ),
              if (_achievementNotifications
                  .isNotEmpty) // Mostrar badge si hay notificaciones
                Positioned(
                  // Posicionar badge
                  right: 8, // 8 píxeles desde la derecha
                  top: 8, // 8 píxeles desde arriba
                  child: Container(
                    padding: const EdgeInsets.all(2), // Padding pequeño
                    decoration: const BoxDecoration(
                      color: tomatoRed, // Color rojo para badge
                      shape: BoxShape.circle, // Forma circular
                    ),
                    child: const Text(
                      '', // Texto vacío (solo círculo rojo)
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
            icon: const Icon(Icons.account_circle,
                color: cloudWhite), // Icono de perfil
            onPressed: () => _navigateToProfile(context), // Navegar a perfil
          ),
        ],
      ),

      body: Container(
        // Cuerpo de la pantalla
        padding: const EdgeInsets.all(16), // Padding interno
        margin: const EdgeInsets.all(10), // Margen externo
        decoration: BoxDecoration(
          gradient: AppGradients.plantCard, // Gradiente de fondo
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
        ),
        child: SingleChildScrollView(
          // Permitir scroll
          child: Column(
            children: [
              // Progreso de nivel
              _buildLevelProgress(user), // Widget de progreso de nivel
              const SizedBox(height: 16), // Espaciador vertical

              // Notificaciones de logros recientes
              if (_achievementNotifications
                  .isNotEmpty) // Mostrar solo si hay notificaciones
                Column(
                  children: [
                    _buildAchievementNotifications(), // Widget de notificaciones
                    const SizedBox(height: 16), // Espaciador vertical
                  ],
                ),

              // Cards principales
              CustomCards.plantasHuerto(
                  context), // Tarjeta de plantas del huerto
              const SizedBox(height: 8), // Espaciador vertical pequeño
              CustomCards.calendarioSiembra(
                  context), // Tarjeta de calendario de siembra
              const SizedBox(height: 16), // Espaciador vertical

              // Actividades rápidas - ACTUALIZADO
              _buildQuickActivities(), // Widget de actividades rápidas
              const SizedBox(height: 16), // Espaciador vertical

              // Estadísticas rápidas - ACTUALIZADO
              _buildQuickStats(user), // Widget de estadísticas rápidas
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: CustomBottomNav(
        // Barra de navegación inferior personalizada
        currentIndex: _currentIndex, // Índice actual
        onTap: (index) => _handleNavigation(index, context), // Manejar taps
      ),
    );
  }

  /*
      WIDGET PARA MOSTRAR PROGRESO DE NIVEL
  */
  Widget _buildLevelProgress(UserModel user) {
    return ProgressWidget(
      // Widget de progreso personalizado
      currentPoints: user.totalPoints, // Puntos totales del usuario
      currentLevel: user.level, // Nivel actual del usuario
      progress: user.levelProgress, // Progreso hacia siguiente nivel
      title: 'Tu Progreso', // Título del widget
    );
  }

  /*
      WIDGET PARA NOTIFICACIONES DE LOGROS
  */
  Widget _buildAchievementNotifications() {
    return Container(
      padding: const EdgeInsets.all(12), // Padding interno
      decoration: BoxDecoration(
        color: blancoHueso, // Fondo blanco hueso
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        boxShadow: AppGradients.cardShadow, // Sombra de tarjeta
        border: Border.all(
            color: freshMint
                .withOpacity(0.3)), // Borde verde menta semitransparente
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinear al inicio horizontal
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espaciar entre elementos
            children: [
              Text(
                'Logros Recientes', // Título de la sección
                style: AppFont.titleSmall.copyWith(
                  // Estilo de texto pequeño
                  fontWeight: FontWeight.bold, // Negrita
                  color: forestDepth, // Color verde oscuro
                ),
              ),
              IconButton(
                // Botón para cerrar notificaciones
                icon: const Icon(Icons.close,
                    size: 18), // Icono de cerrar pequeño
                onPressed: () {
                  setState(() {
                    // Actualizar estado
                    _achievementNotifications
                        .clear(); // Limpiar todas las notificaciones
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8), // Espaciador vertical
          ..._achievementNotifications.take(2).map((notification) {
            // Tomar solo 2 notificaciones
            return _buildNotificationItem(
                notification); // Construir item de notificación
          }), // Convertir a lista
          if (_achievementNotifications.length >
              2) // Mostrar botón si hay más de 2 notificaciones
            TextButton(
              onPressed: () =>
                  _navigateToAchievements(context), // Navegar a logros
              child: const Text('Ver todos los logros'), // Texto del botón
            ),
        ],
      ),
    );
  }

  /*
      WIDGET PARA ITEM INDIVIDUAL DE NOTIFICACIÓN
  */
  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Margen inferior
      padding: const EdgeInsets.all(8), // Padding interno
      decoration: BoxDecoration(
        color: notification['color'].withOpacity(
            0.1), // Fondo con color de notificación semitransparente
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
        border: Border.all(
            color: notification['color']
                .withOpacity(0.3)), // Borde semitransparente
      ),
      child: Row(
        children: [
          Container(
            width: 40, // Ancho fijo
            height: 40, // Alto fijo
            decoration: BoxDecoration(
              color: notification['color']
                  .withOpacity(0.2), // Fondo circular semitransparente
              shape: BoxShape.circle, // Forma circular
            ),
            child: Center(
              child: Text(
                notification['icon'], // Icono emoji de la notificación
                style:
                    const TextStyle(fontSize: 20), // Tamaño grande para emoji
              ),
            ),
          ),
          const SizedBox(width: 12), // Espaciador horizontal
          Expanded(
            // Ocupar espacio disponible
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinear al inicio horizontal
              children: [
                Text(
                  notification['title'], // Título de la notificación
                  style: AppFont.bodyMedium.copyWith(
                    // Estilo de texto medio
                    fontWeight: FontWeight.bold, // Negrita
                    color: forestDepth, // Color verde oscuro
                  ),
                ),
                Text(
                  notification['message'], // Mensaje de la notificación
                  style: AppFont.bodySmall.copyWith(
                    // Estilo de texto pequeño
                    color: Colors.grey[600], // Color gris medio
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4), // Padding interno pequeño
            decoration: BoxDecoration(
              color: notification['color']
                  .withOpacity(0.2), // Fondo semitransparente
              borderRadius: BorderRadius.circular(12), // Bordes redondeados
            ),
            child: Row(
              children: [
                const Icon(Icons.star,
                    size: 12, color: goldenSun), // Icono de estrella pequeña
                const SizedBox(width: 4), // Espaciador horizontal pequeño
                Text(
                  '+${notification['points']}', // Puntos ganados
                  style: AppFont.bodySmall.copyWith(
                    // Estilo de texto pequeño
                    fontWeight: FontWeight.bold, // Negrita
                    color: goldenSun, // Color dorado
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*
      WIDGET PARA ACTIVIDADES RÁPIDAS - ACTUALIZADO
  */
  Widget _buildQuickActivities() {
    return Container(
      padding: const EdgeInsets.all(16), // Padding interno
      decoration: BoxDecoration(
        gradient: AppGradients.cardPrimary, // Gradiente de tarjeta primaria
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        boxShadow: AppGradients.cardShadow, // Sombra de tarjeta
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinear al inicio horizontal
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espaciar entre elementos
            children: [
              Text(
                'Actividades Rápidas', // Título de la sección
                style: AppFont.titleSmall.copyWith(
                  // Estilo de texto pequeño
                  fontWeight: FontWeight.bold, // Negrita
                  color: forestDepth, // Color verde oscuro
                ),
              ),
              IconButton(
                // Botón para ver todas las actividades
                icon: const Icon(Icons.add_circle,
                    color: forestDepth), // Icono de agregar
                onPressed: () =>
                    _navigateToActivities(context), // Navegar a actividades
                tooltip: 'Ver todas las actividades', // Texto de ayuda
              ),
            ],
          ),
          const SizedBox(height: 12), // Espaciador vertical
          SizedBox(
            height: 280, // Altura fija para el grid
            child: GridView.count(
              // Grid con número de columnas fijo
              physics:
                  const ClampingScrollPhysics(), // Física de scroll sin rebote
              crossAxisCount: 2, // 2 columnas
              crossAxisSpacing: 8, // Espacio horizontal entre columnas
              mainAxisSpacing: 8, // Espacio vertical entre filas
              childAspectRatio: 0.8, // Relación aspecto de los hijos
              children: [
                // Lista de botones de actividades
                _buildQuickActivityButton(
                  // Botón plantar semilla
                  '🌱 Plantar Semilla',
                  'Planta una nueva semilla',
                  25,
                  freshMint,
                  'plant_seed',
                ),
                _buildQuickActivityButton(
                  // Botón regar plantas
                  '💧 Regar Plantas',
                  'Cuida tus plantas',
                  10,
                  clearBlue,
                  'water_plant',
                ),
                _buildQuickActivityButton(
                  // Botón login diario
                  '📅 Login Diario',
                  'Mantén tu racha',
                  5,
                  sunflower,
                  'daily_login',
                ),
                _buildQuickActivityButton(
                  // Botón compartir
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

  /*
      WIDGET PARA BOTÓN DE ACTIVIDAD RÁPIDA
  */
  Widget _buildQuickActivityButton(
    String label, // Texto del botón (incluye emoji)
    String description, // Descripción de la actividad
    int points, // Puntos que otorga
    Color color, // Color del botón
    String activityId, // ID único de la actividad
  ) {
    final user = MenuApp.currentUser; // Obtener usuario actual
    // Usar el nuevo método getActivityCount
    final count =
        user.getActivityCount(activityId); // Obtener conteo de esta actividad

    return GestureDetector(
      onTap: () => _completeQuickActivity(
          activityId, points), // Completar actividad al tocar
      child: Container(
        padding: const EdgeInsets.all(12), // Padding interno
        width: MediaQuery.of(context).size.width *
            0.43, // Ancho relativo a la pantalla
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // Fondo semitransparente del color
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
          border: Border.all(
              color: color.withOpacity(0.3)), // Borde semitransparente
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinear al inicio horizontal
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Espaciar entre elementos
              children: [
                Container(
                  padding: const EdgeInsets.all(6), // Padding interno pequeño
                  decoration: BoxDecoration(
                    color: color
                        .withOpacity(0.2), // Fondo circular semitransparente
                    shape: BoxShape.circle, // Forma circular
                  ),
                  child: Text(
                    label.split(
                        ' ')[0], // Solo el emoji (primer elemento del split)
                    style: const TextStyle(
                        fontSize: 18), // Tamaño grande para emoji
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2), // Padding interno pequeño
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2), // Fondo semitransparente
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star,
                          size: 12,
                          color: goldenSun), // Icono de estrella pequeña
                      const SizedBox(
                          width: 2), // Espaciador horizontal muy pequeño
                      Text(
                        '+$points', // Puntos que otorga
                        style: AppFont.bodySmall.copyWith(
                          // Estilo de texto pequeño
                          fontWeight: FontWeight.bold, // Negrita
                          color: goldenSun, // Color dorado
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Espaciador vertical
            Text(
              label
                  .split(' ')
                  .sublist(1)
                  .join(' '), // Texto sin emoji (resto del split)
              style: AppFont.bodyMedium.copyWith(
                // Estilo de texto medio
                fontWeight: FontWeight.bold, // Negrita
                color: forestDepth, // Color verde oscuro
              ),
            ),
            const SizedBox(height: 4), // Espaciador vertical pequeño
            Text(
              description, // Descripción de la actividad
              style: AppFont.bodySmall.copyWith(
                // Estilo de texto pequeño
                color: Colors.grey[600], // Color gris medio
              ),
              maxLines: 2, // Máximo 2 líneas
              overflow:
                  TextOverflow.ellipsis, // Puntos suspensivos si es muy largo
            ),
            const SizedBox(height: 8), // Espaciador vertical
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Espaciar entre elementos
              children: [
                Text(
                  count > 0
                      ? '$count veces'
                      : 'Nunca', // Conteo de veces realizada
                  style: AppFont.bodySmall.copyWith(
                    // Estilo de texto pequeño
                    color: color, // Color de la actividad
                    fontWeight: FontWeight.bold, // Negrita
                  ),
                ),
                const Icon(Icons.add_circle,
                    size: 16, color: forestDepth), // Icono de agregar
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*
      WIDGET PARA ESTADÍSTICAS RÁPIDAS - ACTUALIZADO
  */
  Widget _buildQuickStats(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(12), // Padding interno
      decoration: BoxDecoration(
        color: verdeGelido, // Fondo verde claro
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
        boxShadow: AppGradients.cardShadow, // Sombra de tarjeta
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Espaciar uniformemente
        children: [
          Column(
            // Columna para tienda
            children: [
              const Icon(Icons.eco,
                  size: 40, color: forestDepth), // Icono de planta
              const SizedBox(height: 4), // Espaciador vertical pequeño
              Text(
                'Tienda', // Título de la estadística
                style: AppFont.bodySmall
                    .copyWith(color: forestDepth), // Estilo de texto
              ),
              Text(
                '12 plantas', // Valor de la estadística (simulado)
                style: AppFont.bodySmall.copyWith(
                  color: emeraldLeaf, // Color verde esmeralda
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
            ],
          ),
          Column(
            // Columna para eco-money
            children: [
              const Icon(Icons.attach_money,
                  size: 40, color: forestDepth), // Icono de dinero
              const SizedBox(height: 4), // Espaciador vertical pequeño
              Text(
                'Eco-money', // Título de la estadística
                style: AppFont.bodySmall
                    .copyWith(color: forestDepth), // Estilo de texto
              ),
              Text(
                '${user.totalPoints} pts', // Puntos totales del usuario
                style: AppFont.bodySmall.copyWith(
                  color: goldenSun, // Color dorado
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
            ],
          ),
          Column(
            // Columna para rango
            children: [
              const Icon(Icons.leaderboard,
                  size: 40, color: forestDepth), // Icono de ranking
              const SizedBox(height: 4), // Espaciador vertical pequeño
              Text(
                'Rango', // Título de la estadística
                style: AppFont.bodySmall
                    .copyWith(color: forestDepth), // Estilo de texto
              ),
              Text(
                user.displayRank, // Rango del usuario (formateado)
                style: AppFont.bodySmall.copyWith(
                  color: emeraldLeaf, // Color verde esmeralda
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
      MOSTRAR NOTIFICACIONES
  */
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      // Mostrar hoja modal inferior
      context: context,
      shape: const RoundedRectangleBorder(
        // Forma rectangular redondeada
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Solo redondear la parte superior
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20), // Padding interno
        height: 400, // Altura fija
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinear al inicio horizontal
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Espaciar entre elementos
              children: [
                Text(
                  'Notificaciones', // Título de la hoja modal
                  style: AppFont.titleSmall.copyWith(
                    // Estilo de texto pequeño
                    fontWeight: FontWeight.bold, // Negrita
                    color: forestDepth, // Color verde oscuro
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close), // Icono de cerrar
                  onPressed: () => Navigator.pop(context), // Cerrar hoja modal
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaciador vertical
            Expanded(
              // Ocupar espacio restante
              child: _achievementNotifications
                      .isEmpty // Si no hay notificaciones
                  ? Center(
                      // Centrar contenido
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centrar verticalmente
                        children: [
                          const Icon(Icons.notifications_off,
                              size: 60,
                              color:
                                  Colors.grey), // Icono de sin notificaciones
                          const SizedBox(height: 16), // Espaciador vertical
                          Text(
                            'No hay notificaciones', // Mensaje de no notificaciones
                            style: AppFont.bodyMedium.copyWith(
                                color: Colors.grey), // Estilo de texto gris
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      // Lista de notificaciones si hay
                      itemCount: _achievementNotifications
                          .length, // Número de notificaciones
                      itemBuilder: (context, index) {
                        // Constructor de items
                        final notification = _achievementNotifications[
                            index]; // Obtener notificación
                        return _buildNotificationItem(
                            notification); // Construir item de notificación
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
