// config/menu_app.dart
import 'package:flutter/material.dart'; // Importar framework Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Importar tema de la aplicación
import 'package:huerto_app/themes/app_font.dart'; // Importar fuentes de la aplicación
import 'package:huerto_app/themes/gradients.dart'; // Importar gradientes de la aplicación
import 'package:huerto_app/screens/profile_screen.dart'; // Importar pantalla de perfil
import 'package:huerto_app/screens/achievements_screen.dart'; // Importar pantalla de logros
import 'package:huerto_app/screens/activity_tracking_screen.dart'; // Importar pantalla de seguimiento de actividades
import 'package:huerto_app/models/user_model.dart'; // Importar modelo de usuario
import 'package:huerto_app/config/widgets/avatar_widget.dart'; // Importar widget de avatar
import 'package:huerto_app/services/user_service.dart'; // Importar servicio de usuario para estadísticas

/*
    Clase principal para manejar el menú de navegación de la aplicación
*/
class MenuApp {
  // Usar UserService en lugar de mantener el usuario directamente
  static final UserService _userService =
      UserService(); // Instancia estática del servicio de usuario

  // Método para obtener el usuario actual
  static UserModel get currentUser => _userService
      .currentUser; // Getter que retorna el usuario actual del servicio

  // Método para actualizar el usuario
  static void updateUser(UserModel newUser) {
    _userService.updateUser(newUser); // Llama al método updateUser del servicio
  }

  /*
    Método para construir el Drawer completo de la aplicación
  */
  static Drawer buildDrawer(BuildContext context) {
    final user = currentUser; // Obtiene el usuario actual

    return Drawer(
      // Retorna un widget Drawer
      backgroundColor: verdeGelido, // Color de fondo del drawer
      child: ListView(
        // Lista desplazable para los items del menú
        padding: EdgeInsets.zero, // Sin padding para que ocupe todo el espacio
        children: [
          // Lista de widgets hijos
          _buildDrawerHeader(
              context, user), // Encabezado del drawer con info del usuario
          _buildDrawerItem(
            // Item del menú: Inicio
            icon: Icons.home, // Icono de inicio
            title: 'Inicio', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          _buildDrawerItem(
            // Item del menú: Mi Perfil
            icon: Icons.person, // Icono de perfil
            title: 'Mi Perfil', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _navigateToProfile(context); // Navega a la pantalla de perfil
            },
          ),
          _buildDrawerItem(
            // Item del menú: Mis Plantas
            icon: Icons.eco, // Icono de planta
            title: 'Mis Plantas', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _showComingSoon(context); // Muestra diálogo de "próximamente"
            },
          ),
          _buildDrawerItem(
            // Item del menú: Mis Logros
            customIconPath: // Usa icono personalizado en lugar de IconData
                'lib/images/icons/trophy_35dp_E3E3E3_FILL0_wght400_GRAD0_opsz40.png', // Ruta del icono personalizado
            title: 'Mis Logros', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _navigateToAchievements(
                  context); // Navega a la pantalla de logros
            },
          ),
          // NUEVO: Item para seguimiento de actividades
          _buildDrawerItem(
            // Item del menú: Actividades
            icon: Icons.track_changes, // Icono de seguimiento
            title: 'Actividades', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _navigateToActivityTracking(
                  context); // Navega a pantalla de seguimiento de actividades
            },
          ),
          _buildDrawerItem(
            // Item del menú: Actividades Diarias
            icon: Icons.checklist, // Icono de lista de chequeo
            title: 'Actividades Diarias', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _showComingSoon(context); // Muestra diálogo de "próximamente"
            },
          ),
          _buildDrawerItem(
            // Item del menú: Eco-money
            icon: Icons.attach_money, // Icono de dinero
            title: 'Eco-money', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _showComingSoon(context); // Muestra diálogo de "próximamente"
            },
          ),
          _buildDrawerItem(
            // Item del menú: Mi Progreso
            icon: Icons.bar_chart, // Icono de gráfico de barras
            title: 'Mi Progreso', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _showProgressDialog(context, user); // Muestra diálogo de progreso
            },
          ),
          _buildDrawerItem(
            // Item del menú: Configuración
            icon: Icons.settings, // Icono de configuración
            title: 'Configuración', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _showComingSoon(context); // Muestra diálogo de "próximamente"
            },
          ),
          const Divider(
              color: Colors.grey), // Línea divisoria para separar secciones
          _buildDrawerItem(
            // Item del menú: Cerrar Sesión
            icon: Icons.exit_to_app, // Icono de salida
            title: 'Cerrar Sesión', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _showLogoutDialog(context,
                  user); // Muestra diálogo de confirmación de cierre de sesión
            },
          ),
        ],
      ),
    );
  }

  /*
    Construye el encabezado del Drawer con información del usuario
  */
  static Widget _buildDrawerHeader(BuildContext context, UserModel user) {
    return GestureDetector(
      // Widget que detecta gestos de toque
      onTap: () {
        // Acción al tocar el encabezado
        Navigator.pop(context); // Cierra el drawer
        _navigateToProfile(context); // Navega a la pantalla de perfil
      },
      child: Container(
        // Contenedor para el encabezado
        decoration: BoxDecoration(
          gradient: AppGradients.appBarPrimary, // Fondo con gradiente
        ),
        child: Padding(
          // Padding interno
          padding: const EdgeInsets.all(20.0), // Padding de 20px en todos lados
          child: Column(
            // Columna para organizar contenido verticalmente
            crossAxisAlignment: CrossAxisAlignment
                .start, // Alinea contenido al inicio horizontalmente
            children: [
              // Lista de widgets hijos
              // Avatar y información del usuario
              Row(
                // Fila para avatar e información
                children: [
                  Stack(
                    // Stack para superponer widgets (avatar y botón de editar)
                    alignment: Alignment.bottomRight, // Alinea al fondo-derecha
                    children: [
                      AvatarWidget(
                        // Widget de avatar
                        user: user, // Pasa el usuario al widget de avatar
                        size: 70, // Tamaño del avatar
                        borderColor: cloudWhite, // Color del borde
                        showBorder: true, // Muestra borde
                      ),
                      Container(
                        // Contenedor para el botón de editar
                        width: 25, // Ancho del botón
                        height: 25, // Alto del botón
                        decoration: BoxDecoration(
                          // Decoración del botón
                          color: cloudWhite, // Color de fondo
                          shape: BoxShape.circle, // Forma circular
                          border: Border.all(color: emeraldLeaf), // Borde
                          boxShadow: [
                            // Sombra
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Color de sombra
                              blurRadius: 4, // Radio de desenfoque
                              offset: const Offset(0, 2), // Desplazamiento
                            ),
                          ],
                        ),
                        child: const Icon(
                          // Icono de editar
                          Icons.edit, // Icono de edición
                          size: 12, // Tamaño del icono
                          color: forestDepth, // Color del icono
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16), // Espaciador horizontal
                  Expanded(
                    // Widget que ocupa el espacio restante
                    child: Column(
                      // Columna para información del usuario
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alinea al inicio horizontalmente
                      children: [
                        Text(
                          // Nombre del usuario
                          user.name, // Obtiene nombre del usuario
                          style: AppFont.titleMedium.copyWith(
                            // Estilo del texto
                            color: cloudWhite, // Color blanco
                            fontWeight: FontWeight.bold, // Negrita
                          ),
                          maxLines: 1, // Máximo una línea
                          overflow: TextOverflow
                              .ellipsis, // Puntos suspensivos si es muy largo
                        ),
                        const SizedBox(height: 4), // Espaciador vertical
                        Text(
                          // Email del usuario
                          user.email, // Obtiene email del usuario
                          style: AppFont.bodySmall.copyWith(
                            // Estilo del texto
                            color: cloudWhite
                                .withOpacity(0.9), // Color blanco con opacidad
                          ),
                          maxLines: 1, // Máximo una línea
                          overflow: TextOverflow
                              .ellipsis, // Puntos suspensivos si es muy largo
                        ),
                        const SizedBox(height: 8), // Espaciador vertical
                        Row(
                          // Fila para rango y género
                          children: [
                            // Título/Rango
                            Container(
                              // Contenedor para el rango
                              padding: const EdgeInsets.symmetric(
                                  // Padding interno
                                  horizontal: 8,
                                  vertical: 4), // Horizontal 8px, vertical 4px
                              decoration: BoxDecoration(
                                // Decoración del contenedor
                                color: cloudWhite.withOpacity(
                                    0.2), // Color de fondo con opacidad
                                borderRadius: BorderRadius.circular(
                                    12), // Bordes redondeados
                                border: Border.all(
                                  // Borde
                                  color: cloudWhite.withOpacity(
                                      0.3), // Color del borde con opacidad
                                ),
                              ),
                              child: Row(
                                // Fila para icono y texto del rango
                                children: [
                                  const Icon(
                                      Icons
                                          .workspace_premium, // Icono de premio
                                      size: 12,
                                      color: cloudWhite), // Tamaño y color
                                  const SizedBox(width: 4), // Espaciador
                                  Text(
                                    // Texto del rango
                                    user.displayRank, // Obtiene nombre del rango del usuario
                                    style: AppFont.bodySmall.copyWith(
                                      // Estilo del texto
                                      color: cloudWhite, // Color blanco
                                      fontSize: 10, // Tamaño de fuente
                                      fontWeight:
                                          FontWeight.w600, // Peso de fuente
                                    ),
                                    maxLines: 1, // Máximo una línea
                                    overflow: TextOverflow
                                        .ellipsis, // Puntos suspensivos si es muy largo
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8), // Espaciador horizontal
                            // Género
                            Container(
                              // Contenedor para el género
                              padding: const EdgeInsets.symmetric(
                                  // Padding interno
                                  horizontal: 8,
                                  vertical: 4), // Horizontal 8px, vertical 4px
                              decoration: BoxDecoration(
                                // Decoración del contenedor
                                color: cloudWhite.withOpacity(
                                    0.2), // Color de fondo con opacidad
                                borderRadius: BorderRadius.circular(
                                    12), // Bordes redondeados
                                border: Border.all(
                                  // Borde
                                  color: cloudWhite.withOpacity(
                                      0.3), // Color del borde con opacidad
                                ),
                              ),
                              child: Row(
                                // Fila para icono y texto del género
                                children: [
                                  Icon(
                                      // Icono según género
                                      user.gender ==
                                              UserGender
                                                  .femenino // Si es femenino
                                          ? Icons
                                              .person_2 // Icono de persona femenina
                                          : Icons
                                              .person, // Icono de persona masculina
                                      size: 12, // Tamaño del icono
                                      color: cloudWhite), // Color blanco
                                  const SizedBox(width: 4), // Espaciador
                                  Text(
                                    // Texto del género
                                    user.displayGender, // Obtiene nombre del género del usuario
                                    style: AppFont.bodySmall.copyWith(
                                      // Estilo del texto
                                      color: cloudWhite, // Color blanco
                                      fontSize: 10, // Tamaño de fuente
                                      fontWeight:
                                          FontWeight.w600, // Peso de fuente
                                    ),
                                    maxLines: 1, // Máximo una línea
                                    overflow: TextOverflow
                                        .ellipsis, // Puntos suspensivos si es muy largo
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Puntos y nivel
                        const SizedBox(height: 8), // Espaciador vertical
                        Row(
                          // Fila para puntos y nivel
                          children: [
                            Container(
                              // Contenedor para puntos
                              padding: const EdgeInsets.symmetric(
                                  // Padding interno
                                  horizontal: 8,
                                  vertical: 4), // Horizontal 8px, vertical 4px
                              decoration: BoxDecoration(
                                // Decoración del contenedor
                                color: goldenSun.withOpacity(
                                    0.3), // Color de fondo con opacidad
                                borderRadius: BorderRadius.circular(
                                    12), // Bordes redondeados
                                border: Border.all(
                                  // Borde
                                  color: goldenSun.withOpacity(
                                      0.5), // Color del borde con opacidad
                                ),
                              ),
                              child: Row(
                                // Fila para icono y texto de puntos
                                children: [
                                  const Icon(Icons.star, // Icono de estrella
                                      size: 12,
                                      color: Colors.white), // Tamaño y color
                                  const SizedBox(width: 4), // Espaciador
                                  Text(
                                    // Texto de puntos
                                    '${user.totalPoints} pts', // Puntos del usuario
                                    style: AppFont.bodySmall.copyWith(
                                      // Estilo del texto
                                      color: Colors.white, // Color blanco
                                      fontSize: 10, // Tamaño de fuente
                                      fontWeight:
                                          FontWeight.w600, // Peso de fuente
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8), // Espaciador horizontal
                            Container(
                              // Contenedor para nivel
                              padding: const EdgeInsets.symmetric(
                                  // Padding interno
                                  horizontal: 8,
                                  vertical: 4), // Horizontal 8px, vertical 4px
                              decoration: BoxDecoration(
                                // Decoración del contenedor
                                color: freshMint.withOpacity(
                                    0.3), // Color de fondo con opacidad
                                borderRadius: BorderRadius.circular(
                                    12), // Bordes redondeados
                                border: Border.all(
                                  // Borde
                                  color: freshMint.withOpacity(
                                      0.5), // Color del borde con opacidad
                                ),
                              ),
                              child: Row(
                                // Fila para icono y texto de nivel
                                children: [
                                  const Icon(
                                      Icons
                                          .leaderboard, // Icono de tabla de clasificación
                                      size: 12,
                                      color: Colors.white), // Tamaño y color
                                  const SizedBox(width: 4), // Espaciador
                                  Text(
                                    // Texto de nivel
                                    'Nivel ${user.level}', // Nivel del usuario
                                    style: AppFont.bodySmall.copyWith(
                                      // Estilo del texto
                                      color: Colors.white, // Color blanco
                                      fontSize: 10, // Tamaño de fuente
                                      fontWeight:
                                          FontWeight.w600, // Peso de fuente
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
              const SizedBox(height: 12), // Espaciador vertical
              Container(
                // Contenedor para instrucción táctil
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6), // Padding interno
                decoration: BoxDecoration(
                  // Decoración del contenedor
                  color: cloudWhite
                      .withOpacity(0.1), // Color de fondo con opacidad
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                ),
                child: Row(
                  // Fila para iconos y texto
                  mainAxisSize:
                      MainAxisSize.min, // Tamaño mínimo en eje principal
                  children: [
                    const Icon(Icons.touch_app,
                        size: 12, color: cloudWhite), // Icono de toque
                    const SizedBox(width: 6), // Espaciador
                    Text(
                      // Texto de instrucción
                      'Toca para ver perfil completo', // Instrucción
                      style: AppFont.bodySmall.copyWith(
                        // Estilo del texto
                        color:
                            cloudWhite.withOpacity(0.9), // Color con opacidad
                        fontSize: 10, // Tamaño de fuente
                      ),
                    ),
                    const SizedBox(width: 4), // Espaciador
                    const Icon(Icons.arrow_forward, // Icono de flecha
                        size: 12,
                        color: cloudWhite), // Tamaño y color
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
    Método para construir items del menú del drawer
  */
  static Widget _buildDrawerItem({
    required String title, // Título del item (requerido)
    required VoidCallback onTap, // Función a ejecutar al tocar (requerida)
    IconData? icon, // Icono del item (opcional)
    String? customIconPath, // Ruta de icono personalizado (opcional)
  }) {
    return Container(
      // Contenedor para el item
      margin: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 2), // Margen externo
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
      child: ListTile(
        // Widget ListTile para item de lista
        leading: customIconPath != null // Si hay icono personalizado
            ? Image.asset(
                // Muestra imagen como icono
                customIconPath, // Ruta del icono personalizado
                width: 24, // Ancho
                height: 24, // Alto
                color: forestDepth, // Color del icono
              )
            : Icon(icon, color: forestDepth), // Si no, usa IconData
        title: Text(
          // Título del item
          title, // Texto del título
          style: AppFont.bodyMedium.copyWith(
            // Estilo del texto
            color: Colors.grey[800], // Color gris oscuro
            fontWeight: FontWeight.w500, // Peso de fuente medio
          ),
        ),
        onTap: onTap, // Función a ejecutar al tocar
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16), // Padding interno
        shape: RoundedRectangleBorder(
          // Forma del ListTile
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        tileColor: Colors.transparent, // Color de fondo transparente
        hoverColor: emeraldLeaf.withOpacity(0.1), // Color al pasar el cursor
      ),
    );
  }

  /*
    Método para navegar a la pantalla de perfil
  */
  static void _navigateToProfile(BuildContext context) {
    Navigator.push(
      // Navega a nueva pantalla
      context,
      MaterialPageRoute(
        // Crea una ruta de página material
        builder: (context) => ProfileScreen(
          // Construye la pantalla de perfil
          user: currentUser, // Pasa el usuario actual
          onUserUpdated: (updatedUser) {
            // Callback cuando se actualiza el usuario
            updateUser(updatedUser); // Actualiza el usuario en el servicio
            // Notificar a la pantalla actual que se actualizó el usuario
            if (context.mounted) {
              // Verifica que el contexto esté montado
              ScaffoldMessenger.of(context).showSnackBar(
                // Muestra snackbar de confirmación
                const SnackBar(
                  backgroundColor: forestDepth, // Color de fondo
                  content: Text('Perfil actualizado',
                      style: AppFont.bodyMedium), // Texto del mensaje
                  duration: Duration(seconds: 2), // Duración de 2 segundos
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /*
    Método para navegar a la pantalla de logros
  */
  static Future<void> _navigateToAchievements(BuildContext context) async {
    final updatedUser = await Navigator.push<UserModel>(
      // Navega y espera resultado
      context,
      MaterialPageRoute(
        // Crea una ruta de página material
        builder: (context) => AchievementsScreen(
          // Construye la pantalla de logros
          user: currentUser, // Pasa el usuario actual
          onUserUpdated: (UserModel user) {
            // Callback cuando se actualiza el usuario
            updateUser(user); // Actualiza el usuario en el servicio
            if (context.mounted) {
              // Verifica que el contexto esté montado
              ScaffoldMessenger.of(context).showSnackBar(
                // Muestra snackbar de confirmación
                const SnackBar(
                  backgroundColor: emeraldLeaf, // Color de fondo
                  content: Text('Logros actualizados',
                      style: AppFont.bodyMedium), // Texto del mensaje
                  duration: Duration(seconds: 2), // Duración de 2 segundos
                ),
              );
            }
            return user; // Retorna el usuario actualizado
          },
        ),
      ),
    );

    // Si recibimos un usuario actualizado, actualizamos
    if (updatedUser != null) {
      // Verifica si se recibió un usuario actualizado
      updateUser(updatedUser); // Actualiza el usuario en el servicio
    }
  }

  /*
    NUEVO: Método para navegar a seguimiento de actividades
  */
  static void _navigateToActivityTracking(BuildContext context) {
    Navigator.push(
      // Navega a nueva pantalla
      context,
      MaterialPageRoute(
        // Crea una ruta de página material
        builder: (context) => ActivityTrackingScreen(
          // Construye la pantalla de seguimiento
          user: currentUser, // Pasa el usuario actual
          onUserUpdated: (updatedUser) {
            // Callback cuando se actualiza el usuario
            updateUser(updatedUser); // Actualiza el usuario en el servicio
            if (context.mounted) {
              // Verifica que el contexto esté montado
              ScaffoldMessenger.of(context).showSnackBar(
                // Muestra snackbar de confirmación
                SnackBar(
                  backgroundColor: freshMint, // Color de fondo
                  content: Row(
                    // Fila para icono y texto
                    children: [
                      const Icon(Icons.star,
                          color: Colors.white), // Icono de estrella
                      const SizedBox(width: 8), // Espaciador
                      Text(
                        // Texto del mensaje
                        '¡Actividad registrada! +10 puntos', // Mensaje
                        style: AppFont.bodyMedium
                            .copyWith(color: Colors.white), // Estilo del texto
                      ),
                    ],
                  ),
                  duration:
                      const Duration(seconds: 2), // Duración de 2 segundos
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /*
    Diálogo para funcionalidades próximamente
  */
  static void _showComingSoon(BuildContext context) {
    showDialog(
      // Muestra un diálogo
      context: context, // Contexto actual
      builder: (BuildContext context) {
        // Constructor del diálogo
        return AlertDialog(
          // Retorna un AlertDialog
          backgroundColor: blancoHueso, // Color de fondo
          title: const Row(
            // Fila para el título
            children: [
              Icon(Icons.hourglass_top,
                  color: sunflower), // Icono de reloj de arena
              SizedBox(width: 8), // Espaciador
              Text('Próximamente',
                  style: AppFont.titleMedium), // Texto del título
            ],
          ),
          content: Column(
            // Columna para el contenido
            mainAxisSize: MainAxisSize.min, // Tamaño mínimo en eje principal
            children: [
              const Icon(Icons.construction,
                  size: 50, color: goldenSun), // Icono de construcción
              const SizedBox(height: 16), // Espaciador vertical
              const Text(
                // Texto principal
                'Esta funcionalidad estará disponible pronto.', // Mensaje principal
                style: AppFont.bodyMedium, // Estilo del texto
                textAlign: TextAlign.center, // Centra el texto
              ),
              const SizedBox(height: 8), // Espaciador vertical
              Text(
                // Texto secundario
                'Sigue cultivando tu huerto mientras trabajamos en nuevas características.', // Mensaje secundario
                style: AppFont.bodySmall.copyWith(
                  // Estilo del texto
                  color: Colors.grey[600], // Color gris
                  fontStyle: FontStyle.italic, // Estilo itálico
                ),
                textAlign: TextAlign.center, // Centra el texto
              ),
            ],
          ),
          actions: [
            // Botones de acción
            TextButton(
              // Botón de texto
              onPressed: () => Navigator.pop(context), // Cierra el diálogo
              child: const Text('Entendido',
                  style: AppFont.button), // Texto del botón
            ),
          ],
          shape: RoundedRectangleBorder(
            // Forma del diálogo
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
          ),
          elevation: 8, // Elevación (sombra)
        );
      },
    );
  }

  /*
    Diálogo para cerrar sesión
  */
  static void _showLogoutDialog(BuildContext context, UserModel user) {
    showDialog(
      // Muestra un diálogo
      context: context, // Contexto actual
      builder: (BuildContext context) {
        // Constructor del diálogo
        return AlertDialog(
          // Retorna un AlertDialog
          backgroundColor: blancoHueso, // Color de fondo
          title: const Row(
            // Fila para el título
            children: [
              Icon(Icons.logout, color: tomatoRed), // Icono de cerrar sesión
              SizedBox(width: 8), // Espaciador
              Text('Cerrar Sesión',
                  style: AppFont.titleMedium), // Texto del título
            ],
          ),
          content: Column(
            // Columna para el contenido
            mainAxisSize: MainAxisSize.min, // Tamaño mínimo en eje principal
            children: [
              AvatarWidget(
                // Widget de avatar
                user: user, // Pasa el usuario
                size: 60, // Tamaño del avatar
                showBorder: true, // Muestra borde
                borderColor:
                    tomatoRed.withOpacity(0.3), // Color del borde con opacidad
              ),
              const SizedBox(height: 16), // Espaciador vertical
              Text(
                // Texto de confirmación
                '¿Estás seguro de que quieres cerrar sesión?', // Pregunta de confirmación
                style: AppFont.bodyMedium.copyWith(
                  // Estilo del texto
                  color: Colors.grey[800], // Color gris oscuro
                ),
                textAlign: TextAlign.center, // Centra el texto
              ),
              const SizedBox(height: 8), // Espaciador vertical
              Text(
                // Texto secundario
                '¡Vuelve pronto para seguir cuidando tu huerto!', // Mensaje de despedida
                style: AppFont.bodySmall.copyWith(
                  // Estilo del texto
                  color: Colors.grey[600], // Color gris
                  fontStyle: FontStyle.italic, // Estilo itálico
                ),
                textAlign: TextAlign.center, // Centra el texto
              ),
              const SizedBox(height: 16), // Espaciador vertical
              // Mostrar estadísticas antes de cerrar sesión
              Container(
                // Contenedor para estadísticas
                padding: const EdgeInsets.all(12), // Padding interno
                decoration: BoxDecoration(
                  // Decoración del contenedor
                  color: verdeGelido, // Color de fondo
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: Column(
                  // Columna para estadísticas
                  children: [
                    _buildStatRow('Puntos totales',
                        '${user.totalPoints}'), // Fila para puntos
                    _buildStatRow('Nivel', '${user.level}'), // Fila para nivel
                    _buildStatRow('Rango', user.displayRank), // Fila para rango
                    _buildStatRow(
                        'Género', user.displayGender), // Fila para género
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // Botones de acción
            TextButton(
              // Botón de cancelar
              onPressed: () => Navigator.pop(context), // Cierra el diálogo
              style: TextButton.styleFrom(
                // Estilo del botón
                foregroundColor: forestDepth, // Color del texto
              ),
              child: const Text('Cancelar',
                  style: AppFont.button), // Texto del botón
            ),
            TextButton(
              // Botón de cerrar sesión
              onPressed: () {
                // Acción al presionar
                Navigator.pop(context); // Cierra el diálogo
                _performLogout(context); // Ejecuta el cierre de sesión
              },
              style: TextButton.styleFrom(
                // Estilo del botón
                foregroundColor: tomatoRed, // Color del texto
              ),
              child: const Text(
                // Texto del botón
                'Cerrar Sesión',
                style: TextStyle(
                  // Estilo del texto
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            // Forma del diálogo
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
          ),
          elevation: 8, // Elevación (sombra)
        );
      },
    );
  }

  /*
    Widget auxiliar para mostrar filas de estadísticas
  */
  static Widget _buildStatRow(String label, String value) {
    return Padding(
      // Padding para la fila
      padding: const EdgeInsets.symmetric(vertical: 4), // Padding vertical
      child: Row(
        // Fila para etiqueta y valor
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Espacio entre elementos
        children: [
          Text(label, // Texto de la etiqueta
              style: AppFont.bodySmall
                  .copyWith(color: Colors.grey[600])), // Estilo de la etiqueta
          Text(value, // Texto del valor
              style: AppFont.bodySmall.copyWith(
                // Estilo del valor
                fontWeight: FontWeight.bold, // Negrita
                color: forestDepth, // Color
              )),
        ],
      ),
    );
  }

  /*
    Método para realizar el logout
  */
  static void _performLogout(BuildContext context) {
    final user = currentUser; // Obtiene el usuario actual

    // Mostrar snackbar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      // Muestra snackbar
      SnackBar(
        backgroundColor: forestDepth, // Color de fondo
        content: Row(
          // Fila para icono y texto
          children: [
            const Icon(Icons.check_circle,
                color: Colors.white, size: 20), // Icono de confirmación
            const SizedBox(width: 8), // Espaciador
            Text(
              // Texto del mensaje
              'Sesión cerrada - ¡Hasta pronto, ${user.name}!', // Mensaje personalizado con nombre
              style: AppFont.bodyMedium
                  .copyWith(color: Colors.white), // Estilo del texto
            ),
          ],
        ),
        duration: const Duration(seconds: 3), // Duración de 3 segundos
        behavior: SnackBarBehavior.floating, // Comportamiento flotante
        shape: RoundedRectangleBorder(
          // Forma del snackbar
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        action: SnackBarAction(
          // Acción del snackbar
          label: 'Ok', // Texto de la acción
          textColor: Colors.white, // Color del texto
          onPressed: () {
            // Acción al presionar
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Oculta el snackbar actual
          },
        ),
      ),
    );

    // Aquí iría la lógica real de logout (limpiar tokens, etc.)
    // Por ahora solo mostramos el mensaje y regresamos al home
    Navigator.popUntil(
        context, (route) => route.isFirst); // Regresa a la primera pantalla
  }

  /*
    NUEVO: Diálogo para mostrar progreso del usuario
  */
  static void _showProgressDialog(BuildContext context, UserModel user) {
    showDialog(
      // Muestra un diálogo
      context: context, // Contexto actual
      builder: (context) => AlertDialog(
        // Constructor del diálogo
        backgroundColor: blancoHueso, // Color de fondo
        title: const Row(
          // Fila para el título
          children: [
            Icon(Icons.bar_chart, color: forestDepth), // Icono de gráfico
            SizedBox(width: 8), // Espaciador
            Text('Mi Progreso', style: AppFont.titleMedium), // Texto del título
          ],
        ),
        content: SingleChildScrollView(
          // Contenido desplazable
          child: Column(
            // Columna para el contenido
            mainAxisSize: MainAxisSize.min, // Tamaño mínimo en eje principal
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinea al inicio horizontalmente
            children: [
              // Barra de progreso del nivel
              Container(
                // Contenedor para la barra de progreso
                padding: const EdgeInsets.all(12), // Padding interno
                decoration: BoxDecoration(
                  // Decoración del contenedor
                  gradient: const LinearGradient(
                    // Gradiente de fondo
                    colors: [freshMint, emeraldLeaf], // Colores del gradiente
                    begin: Alignment.topLeft, // Inicio del gradiente
                    end: Alignment.bottomRight, // Fin del gradiente
                  ),
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: Column(
                  // Columna para contenido de progreso
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alinea al inicio horizontalmente
                  children: [
                    Row(
                      // Fila para nivel y puntos
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Espacio entre elementos
                      children: [
                        Text(
                          // Texto del nivel
                          'Nivel ${user.level}', // Muestra el nivel actual
                          style: AppFont.bodyMedium.copyWith(
                            // Estilo del texto
                            color: Colors.white, // Color blanco
                            fontWeight: FontWeight.bold, // Negrita
                          ),
                        ),
                        Text(
                          // Texto de puntos
                          '${user.totalPoints} pts', // Muestra puntos totales
                          style: AppFont.bodyMedium.copyWith(
                            // Estilo del texto
                            color: Colors.white, // Color blanco
                            fontWeight: FontWeight.bold, // Negrita
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Espaciador vertical
                    LinearProgressIndicator(
                      // Indicador de progreso lineal
                      value:
                          user.levelProgress, // Valor del progreso (0.0 a 1.0)
                      backgroundColor:
                          Colors.white.withOpacity(0.3), // Color de fondo
                      color: Colors.white, // Color del progreso
                      minHeight: 10, // Altura mínima
                      borderRadius:
                          BorderRadius.circular(5), // Bordes redondeados
                    ),
                    const SizedBox(height: 4), // Espaciador vertical
                    Row(
                      // Fila para porcentaje y puntos restantes
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Espacio entre elementos
                      children: [
                        Text(
                          // Porcentaje de progreso
                          'Progreso: ${(user.levelProgress * 100).toStringAsFixed(0)}%', // Calcula y muestra porcentaje
                          style: AppFont.bodySmall.copyWith(
                              color: Colors.white70), // Estilo del texto
                        ),
                        Text(
                          // Puntos para siguiente nivel
                          '${user.pointsToNextLevel} pts para nivel ${user.level + 1}', // Muestra puntos necesarios
                          style: AppFont.bodySmall.copyWith(
                              color: Colors.white70), // Estilo del texto
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Espaciador vertical

              // Estadísticas detalladas
              Text(
                // Título de estadísticas
                'Estadísticas Detalladas', // Texto del título
                style: AppFont.titleSmall.copyWith(
                  // Estilo del texto
                  fontWeight: FontWeight.bold, // Negrita
                  color: forestDepth, // Color
                ),
              ),
              const SizedBox(height: 12), // Espaciador vertical

              GridView.count(
                // Grid para estadísticas
                shrinkWrap: true, // Se ajusta al contenido
                physics:
                    const NeverScrollableScrollPhysics(), // Sin desplazamiento propio
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 12, // Espaciado horizontal entre elementos
                mainAxisSpacing: 12, // Espaciado vertical entre elementos
                childAspectRatio: 2.5, // Relación ancho/alto de los hijos
                children: [
                  // Lista de tarjetas de estadísticas
                  _buildStatCard(
                    // Tarjeta de actividades completadas
                    'Actividades Complet.', // Etiqueta
                    '${user.completedActivityIds.length}', // Valor
                    Icons.checklist, // Icono
                    freshMint, // Color
                  ),
                  _buildStatCard(
                    // Tarjeta de favoritos
                    'Favoritos', // Etiqueta
                    '${user.favoriteActivityIds.length}', // Valor
                    Icons.favorite, // Icono
                    sunflower, // Color
                  ),
                  _buildStatCard(
                    // Tarjeta de puntos totales
                    'Puntos Total', // Etiqueta
                    '${user.totalPoints}', // Valor
                    Icons.star, // Icono
                    goldenSun, // Color
                  ),
                  _buildStatCard(
                    // Tarjeta de rango
                    'Rango', // Etiqueta
                    user.displayRank, // Valor
                    Icons.leaderboard, // Icono
                    clearBlue, // Color
                  ),
                ],
              ),

              const SizedBox(height: 16), // Espaciador vertical

              // Botón para ver más detalles
              SizedBox(
                // Contenedor para el botón
                width: double.infinity, // Ancho completo
                child: ElevatedButton.icon(
                  // Botón elevado con icono
                  onPressed: () {
                    // Acción al presionar
                    Navigator.pop(context); // Cierra el diálogo
                    _navigateToActivityTracking(
                        context); // Navega a seguimiento de actividades
                  },
                  style: ElevatedButton.styleFrom(
                    // Estilo del botón
                    backgroundColor: forestDepth, // Color de fondo
                    foregroundColor: blancoHueso, // Color del texto/icono
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Padding vertical
                    shape: RoundedRectangleBorder(
                      // Forma del botón
                      borderRadius:
                          BorderRadius.circular(12), // Bordes redondeados
                    ),
                  ),
                  icon: const Icon(Icons.timeline, size: 18), // Icono del botón
                  label:
                      const Text('Ver Progreso Detallado'), // Texto del botón
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Botones de acción
          TextButton(
            // Botón de cerrar
            onPressed: () => Navigator.pop(context), // Cierra el diálogo
            child:
                const Text('Cerrar', style: AppFont.button), // Texto del botón
          ),
        ],
        shape: RoundedRectangleBorder(
          // Forma del diálogo
          borderRadius: BorderRadius.circular(16), // Bordes redondeados
        ),
        elevation: 8, // Elevación (sombra)
      ),
    );
  }

  /*
    Método auxiliar para construir tarjetas de estadísticas
  */
  static Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      // Contenedor para la tarjeta
      padding: const EdgeInsets.all(8), // Padding interno
      decoration: BoxDecoration(
        // Decoración del contenedor
        color: color.withOpacity(0.1), // Color de fondo con opacidad
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
        border: Border.all(color: color.withOpacity(0.3)), // Borde
      ),
      child: Row(
        // Fila para icono y texto
        children: [
          Container(
            // Contenedor para el icono
            padding: const EdgeInsets.all(6), // Padding interno
            decoration: BoxDecoration(
              // Decoración del contenedor
              color: color.withOpacity(0.2), // Color de fondo con opacidad
              shape: BoxShape.circle, // Forma circular
            ),
            child: Icon(icon, size: 16, color: color), // Icono
          ),
          const SizedBox(width: 8), // Espaciador
          Expanded(
            // Widget que ocupa el espacio restante
            child: Column(
              // Columna para etiqueta y valor
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinea al inicio horizontalmente
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra verticalmente
              children: [
                Text(
                  // Texto de la etiqueta
                  label, // Etiqueta de la estadística
                  style: AppFont.bodySmall.copyWith(
                    // Estilo del texto
                    color: Colors.grey[600], // Color gris
                  ),
                ),
                Text(
                  // Texto del valor
                  value, // Valor de la estadística
                  style: AppFont.bodyMedium.copyWith(
                    // Estilo del texto
                    fontWeight: FontWeight.bold, // Negrita
                    color: forestDepth, // Color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
