// screens/profile_screen.dart
import 'package:flutter/material.dart'; // Importar framework de Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Importar tema de la aplicación
import 'package:huerto_app/themes/app_font.dart'; // Importar fuentes de la aplicación
import 'package:huerto_app/themes/gradients.dart'; // Importar gradientes
import 'package:huerto_app/models/user_model.dart'; // Importar modelo de usuario
import 'package:huerto_app/config/widgets/bottom_nav_custom.dart'; // Importar navegación inferior personalizada
import 'package:huerto_app/screens/achievements_screen.dart'; // Importar pantalla de logros
import 'package:huerto_app/screens/avatar_customizer_screen.dart'; // Importar personalizador de avatar
import 'package:huerto_app/config/widgets/avatar_widget.dart'; // Importar widget de avatar

/*
    PANTALLA DE PERFIL DE USUARIO - ESTADO MUTABLE
*/
class ProfileScreen extends StatefulWidget {
  final UserModel user; // Usuario actual
  final Function(UserModel)
      onUserUpdated; // Callback cuando se actualiza el usuario

  const ProfileScreen({
    super.key, // Llave opcional
    required this.user, // Usuario requerido
    required this.onUserUpdated, // Callback requerido
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState(); // Crear estado de la pantalla
}

/*
    ESTADO DE LA PANTALLA DE PERFIL
*/
class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _currentUser; // Usuario actual en edición
  int _currentIndex = 2; // Índice para "Cuenta" (tercera posición)

  @override
  void initState() {
    super.initState(); // Llamar al initState del padre
    _currentUser = widget.user; // Inicializar usuario actual con el recibido
  }

  /*
      ACTUALIZAR USUARIO
  */
  void _updateUser(UserModel newUser) {
    setState(() {
      // Actualizar estado
      _currentUser = newUser; // Asignar nuevo usuario
    });
    // Notificar al padre sobre el cambio
    widget.onUserUpdated(newUser); // Ejecutar callback

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      // Mostrar snackbar de confirmación
      const SnackBar(
        backgroundColor: forestDepth, // Fondo verde oscuro
        content: Text('Perfil actualizado',
            style: AppFont.bodyMedium), // Mensaje de confirmación
        duration: Duration(seconds: 2), // Duración de 2 segundos
      ),
    );
  }

  /*
      NAVEGACIÓN A PANTALLA DE LOGROS - ACTUALIZADO
  */
  Future<void> _navigateToAchievements() async {
    final updatedUser = await Navigator.push<UserModel>(
      // Navegar y esperar resultado
      context,
      MaterialPageRoute(
        // Ruta de material
        builder: (context) => AchievementsScreen(
          // Construir pantalla de logros
          user: _currentUser, // Pasar usuario actual
          onUserUpdated: (UserModel user) {
            // Callback cuando se actualiza usuario
            // Actualizar localmente y notificar al padre
            _updateUser(user); // Actualizar usuario
            return user; // Devolver usuario
          },
        ),
      ),
    );

    // Si se devuelve un usuario actualizado
    if (updatedUser != null) {
      // Verificar si hay usuario devuelto
      _updateUser(updatedUser); // Actualizar usuario
    }
  }

  /*
      NAVEGACIÓN A PANTALLA DE PERSONALIZACIÓN DEL AVATAR
  */
  Future<void> _navigateToAvatarCustomizer() async {
    final updatedUser = await Navigator.push<UserModel>(
      // Navegar y esperar resultado
      context,
      MaterialPageRoute(
        // Ruta de material
        builder: (context) => AvatarCustomizerScreen(
          // Construir personalizador de avatar
          user: _currentUser, // Pasar usuario actual
          onAvatarUpdated: (UserModel user) {
            // Callback cuando se actualiza avatar
            // Actualizar localmente y notificar al padre
            _updateUser(user); // Actualizar usuario
            return user; // Devolver usuario
          },
        ),
      ),
    );

    // Si se devuelve un usuario actualizado
    if (updatedUser != null) {
      // Verificar si hay usuario devuelto
      _updateUser(updatedUser); // Actualizar usuario
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
        Navigator.pop(context); // Regresar a home
        break;
      case 2: // Cuenta
        // Ya estamos en perfil, no hacer nada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancoHueso, // Fondo blanco hueso
      appBar: AppBar(
        title: Text(
          'Mi Perfil', // Título de la AppBar
          style: AppFont.appBarTitle
              .copyWith(color: blancoHueso), // Estilo de texto blanco
        ),
        flexibleSpace: Container(
          // Espacio flexible para gradiente
          decoration: BoxDecoration(
            gradient: AppGradients.appBarPrimary, // Gradiente de la AppBar
          ),
        ),
        leading: IconButton(
          // Botón de regresar
          icon: const Icon(Icons.arrow_back,
              color: blancoHueso), // Icono de flecha blanca
          onPressed: () => Navigator.of(context)
              .pop(_currentUser), // Regresar con usuario actual
        ),
      ),
      body: SingleChildScrollView(
        // Permitir scroll
        padding: const EdgeInsets.all(20), // Padding interno
        child: Column(
          children: [
            // Sección de avatar y información básica
            Container(
              padding: const EdgeInsets.all(20), // Padding interno
              decoration: BoxDecoration(
                gradient:
                    AppGradients.cardPrimary, // Gradiente de tarjeta primaria
                borderRadius:
                    BorderRadius.circular(20), // Bordes muy redondeados
                boxShadow: AppGradients.cardShadow, // Sombra de tarjeta
              ),
              child: Column(
                children: [
                  // Avatar del usuario en lugar de foto - ACTUALIZADO
                  GestureDetector(
                    // Detector de toques para el avatar
                    onTap:
                        _navigateToAvatarCustomizer, // Navegar al personalizador al tocar
                    child: Stack(
                      // Apilar elementos para botón de edición
                      alignment: Alignment
                          .bottomRight, // Alinear botón en esquina inferior derecha
                      children: [
                        // AvatarWidget ahora acepta UserModel directamente
                        AvatarWidget(
                          // Widget de avatar personalizado
                          user: _currentUser, // Usuario actual
                          size: 120, // Tamaño grande
                          borderColor: emeraldLeaf, // Color de borde verde
                          showBorder: true, // Mostrar borde
                        ),
                        Container(
                          // Contenedor para botón de edición
                          width: 35, // Ancho pequeño
                          height: 35, // Alto pequeño
                          decoration: BoxDecoration(
                            color: blancoHueso, // Fondo blanco
                            shape: BoxShape.circle, // Forma circular
                            border:
                                Border.all(color: emeraldLeaf), // Borde verde
                          ),
                          child: IconButton(
                            // Botón de icono
                            icon: const Icon(
                              Icons.edit, // Icono de editar
                              size: 18, // Tamaño pequeño
                              color: forestDepth, // Color verde oscuro
                            ),
                            onPressed:
                                _navigateToAvatarCustomizer, // Navegar al personalizador
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Espaciador vertical

                  // Nombre del usuario - ACTUALIZABLE
                  GestureDetector(
                    // Detector de toques para nombre
                    onTap: _editName, // Editar nombre al tocar
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centrar horizontalmente
                      children: [
                        Text(
                          _currentUser.name, // Nombre del usuario
                          style: AppFont.titleLarge.copyWith(
                            // Estilo de texto grande
                            fontWeight: FontWeight.bold, // Negrita
                          ),
                        ),
                        const SizedBox(width: 8), // Espaciador horizontal
                        const Icon(Icons.edit,
                            size: 16,
                            color: stoneGray), // Icono de editar pequeño
                      ],
                    ),
                  ),
                  const SizedBox(height: 8), // Espaciador vertical pequeño

                  // Correo electrónico - ACTUALIZABLE
                  GestureDetector(
                    // Detector de toques para email
                    onTap: _editEmail, // Editar email al tocar
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centrar horizontalmente
                      children: [
                        const Icon(Icons.email,
                            size: 16, color: stoneGray), // Icono de email
                        const SizedBox(width: 8), // Espaciador horizontal
                        Text(
                          _currentUser.email, // Email del usuario
                          style: AppFont.bodyMedium.copyWith(
                            // Estilo de texto medio
                            color: stoneGray, // Color gris piedra
                          ),
                        ),
                        const SizedBox(width: 8), // Espaciador horizontal
                        const Icon(Icons.edit,
                            size: 14,
                            color: stoneGray), // Icono de editar muy pequeño
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // Espaciador vertical

                  // Botón para personalizar avatar
                  _buildAvatarActionButton(), // Widget de botón de acción
                  const SizedBox(height: 16), // Espaciador vertical

                  // Divider
                  Container(
                    // Contenedor para línea divisoria
                    height: 1, // Altura de 1 píxel
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20), // Margen horizontal
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // Gradiente para línea
                        colors: [
                          Colors.transparent, // Transparente al inicio
                          forestDepth.withOpacity(
                              0.3), // Verde semitransparente en medio
                          Colors.transparent, // Transparente al final
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Espaciador vertical

                  // Título y Rango - ACTUALIZADO
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly, // Espaciar uniformemente
                    children: [
                      // Título (seleccionable) - AHORA USA user.title
                      _buildInfoCard(
                        // Tarjeta de información para título
                        icon: Icons.workspace_premium, // Icono de premiun
                        title: 'Título', // Título de la tarjeta
                        value: _currentUser.title, // Usa el getter title
                        onTap:
                            _navigateToAchievements, // Navegar a logros al tocar
                        isSelectable: true, // Es seleccionable
                      ),

                      // Rango - ACTUALIZADO
                      _buildInfoCard(
                        // Tarjeta de información para rango
                        icon: Icons.leaderboard, // Icono de ranking
                        title: 'Rango', // Título de la tarjeta
                        value: _currentUser.displayRank, // Usa displayRank
                        onTap:
                            _showRankInfo, // Mostrar información de rango al tocar
                        isSelectable: false, // No es seleccionable
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Espaciador vertical

            // Estadísticas rápidas - ACTUALIZADO
            Container(
              padding: const EdgeInsets.all(20), // Padding interno
              decoration: BoxDecoration(
                gradient:
                    AppGradients.backgroundSoft, // Gradiente de fondo suave
                borderRadius:
                    BorderRadius.circular(20), // Bordes muy redondeados
                boxShadow: AppGradients.cardShadow, // Sombra de tarjeta
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinear al inicio horizontal
                children: [
                  Text(
                    'Estadísticas', // Título de la sección
                    style: AppFont.titleMedium.copyWith(
                      // Estilo de texto medio
                      fontWeight: FontWeight.bold, // Negrita
                    ),
                  ),
                  const SizedBox(height: 16), // Espaciador vertical
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Espaciar uniformemente
                    children: [
                      // Plantas (simulado)
                      _buildStatItem(
                        // Item de estadística para plantas
                        value: '12', // Valor simulado
                        label: 'Plantas', // Etiqueta
                        icon: Icons.eco, // Icono de planta
                        color: freshMint, // Color verde menta
                      ),
                      // Logros - ACTUALIZADO
                      _buildStatItem(
                        // Item de estadística para logros
                        value:
                            '${_currentUser.unlockedAchievementsCount}/20', // Usa el getter
                        label: 'Logros', // Etiqueta
                        icon: Icons.emoji_events, // Icono de trofeo
                        color: goldenSun, // Color dorado
                      ),
                      // Días activo - ACTUALIZADO
                      _buildStatItem(
                        // Item de estadística para días activos
                        value: _currentUser.consecutiveDays
                            .toString(), // Días consecutivos
                        label: 'Días seguidos', // Etiqueta
                        icon: Icons.calendar_today, // Icono de calendario
                        color: clearBlue, // Color azul claro
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Espaciador vertical

            // Acciones rápidas
            Container(
              padding: const EdgeInsets.all(20), // Padding interno
              decoration: BoxDecoration(
                gradient: AppGradients
                    .cardHighlight, // Gradiente de tarjeta destacada
                borderRadius:
                    BorderRadius.circular(20), // Bordes muy redondeados
                boxShadow: AppGradients.cardShadow, // Sombra de tarjeta
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinear al inicio horizontal
                children: [
                  Text(
                    'Acciones', // Título de la sección
                    style: AppFont.titleMedium.copyWith(
                      // Estilo de texto medio
                      fontWeight: FontWeight.bold, // Negrita
                    ),
                  ),
                  const SizedBox(height: 16), // Espaciador vertical
                  Wrap(
                    // Envolver elementos en múltiples líneas
                    spacing: 12, // Espacio horizontal entre elementos
                    runSpacing: 12, // Espacio vertical entre líneas
                    children: [
                      // Lista de botones de acción
                      _buildActionButton(
                        // Botón para editar perfil
                        icon: Icons.edit,
                        label: 'Editar Perfil',
                        onTap: _editProfile,
                        color: emeraldLeaf,
                      ),
                      _buildActionButton(
                        // Botón para personalizar avatar
                        icon: Icons.face,
                        label: 'Mi Avatar',
                        onTap: _navigateToAvatarCustomizer,
                        color: freshMint,
                      ),
                      _buildActionButton(
                        // Botón para ver logros
                        icon: Icons.workspace_premium,
                        label: 'Ver Logros',
                        onTap: _navigateToAchievements,
                        color: goldenSun,
                      ),
                      _buildActionButton(
                        // Botón para configuración
                        icon: Icons.settings,
                        label: 'Configuración',
                        onTap: _openSettings,
                        color: stoneGray,
                      ),
                      _buildActionButton(
                        // Botón para ayuda
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
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: CustomBottomNav(
        // Barra de navegación inferior personalizada
        currentIndex: _currentIndex, // Índice actual
        onTap: (index) => _handleNavigation(index, context), // Manejar taps
      ),
    );
  }

  /*
      WIDGET PARA CONSTRUIR TARJETAS DE INFORMACIÓN (TÍTULO Y RANGO)
  */
  Widget _buildInfoCard({
    required IconData icon, // Icono de la tarjeta
    required String title, // Título de la tarjeta
    required String value, // Valor de la tarjeta
    required VoidCallback onTap, // Acción al tocar
    required bool isSelectable, // Si es seleccionable (interactivo)
  }) {
    return GestureDetector(
      onTap: onTap, // Ejecutar callback al tocar
      child: Container(
        padding: const EdgeInsets.all(12), // Padding interno
        decoration: BoxDecoration(
          gradient: isSelectable // Gradiente según si es seleccionable
              ? AppGradients
                  .interactiveHover // Gradiente de hover para interactivo
              : AppGradients
                  .cardPrimary, // Gradiente normal para no interactivo
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
          boxShadow: AppGradients.innerShadow, // Sombra interna
          border: isSelectable // Borde solo si es seleccionable
              ? Border.all(
                  color: emeraldLeaf.withOpacity(0.3),
                  width: 1) // Borde verde semitransparente
              : null,
        ),
        child: Column(
          children: [
            Stack(
              // Apilar elementos para badge
              children: [
                Icon(icon, size: 24, color: forestDepth), // Icono principal
                if (isSelectable) // Mostrar indicador de selección si es seleccionable
                  Positioned(
                    // Posicionar badge
                    top: -2, // 2 píxeles arriba
                    right: -2, // 2 píxeles a la derecha
                    child: Container(
                      padding: const EdgeInsets.all(2), // Padding pequeño
                      decoration: const BoxDecoration(
                        color: emeraldLeaf, // Fondo verde
                        shape: BoxShape.circle, // Forma circular
                      ),
                      child: const Icon(
                        Icons.arrow_drop_down, // Icono de flecha hacia abajo
                        size: 12, // Tamaño pequeño
                        color: blancoHueso, // Color blanco
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8), // Espaciador vertical
            Text(
              title, // Título de la tarjeta
              style: AppFont.bodySmall.copyWith(
                // Estilo de texto pequeño
                color: stoneGray, // Color gris piedra
                fontWeight: FontWeight.w500, // Peso medio
              ),
            ),
            const SizedBox(height: 4), // Espaciador vertical pequeño
            Text(
              value, // Valor de la tarjeta
              style: AppFont.bodyMedium.copyWith(
                // Estilo de texto medio
                fontWeight: FontWeight.bold, // Negrita
                color: isSelectable
                    ? emeraldLeaf
                    : null, // Color verde si es seleccionable
              ),
              textAlign: TextAlign.center, // Centrar texto
              maxLines: 2, // Máximo 2 líneas
              overflow:
                  TextOverflow.ellipsis, // Puntos suspensivos si es muy largo
            ),
          ],
        ),
      ),
    );
  }

  /*
      WIDGET PARA CONSTRUIR ITEMS DE ESTADÍSTICAS
  */
  Widget _buildStatItem({
    required String value, // Valor de la estadística
    required String label, // Etiqueta de la estadística
    required IconData icon, // Icono de la estadística
    required Color color, // Color de la estadística
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12), // Padding interno
          decoration: BoxDecoration(
            color: color.withOpacity(0.2), // Fondo semitransparente del color
            shape: BoxShape.circle, // Forma circular
          ),
          child: Icon(icon, size: 24, color: color), // Icono con color
        ),
        const SizedBox(height: 8), // Espaciador vertical
        Text(
          value, // Valor de la estadística
          style: AppFont.titleSmall.copyWith(
            // Estilo de texto pequeño
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        Text(
          label, // Etiqueta de la estadística
          style: AppFont.bodySmall.copyWith(
            // Estilo de texto muy pequeño
            color: stoneGray, // Color gris piedra
          ),
        ),
      ],
    );
  }

  /*
      WIDGET PARA CONSTRUIR BOTONES DE ACCIÓN
  */
  Widget _buildActionButton({
    required IconData icon, // Icono del botón
    required String label, // Texto del botón
    required VoidCallback onTap, // Acción al tocar
    required Color color, // Color del botón
  }) {
    return GestureDetector(
      onTap: onTap, // Ejecutar callback al tocar
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Padding interno específico
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Gradiente del botón
            colors: [
              color.withOpacity(0.1), // Color semitransparente
              color.withOpacity(0.05), // Color más transparente
            ],
          ),
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
          border: Border.all(
              color: color.withOpacity(0.3)), // Borde semitransparente
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Tamaño mínimo en el eje principal
          children: [
            Icon(icon, size: 18, color: color), // Icono pequeño con color
            const SizedBox(width: 8), // Espaciador horizontal
            Text(
              label, // Texto del botón
              style: AppFont.bodyMedium.copyWith(
                // Estilo de texto medio
                fontWeight: FontWeight.w500, // Peso medio
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
      WIDGET PARA BOTÓN DE ACCIÓN DEL AVATAR
  */
  Widget _buildAvatarActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), // Padding interno específico
      decoration: BoxDecoration(
        color: freshMint.withOpacity(0.1), // Fondo verde menta semitransparente
        borderRadius: BorderRadius.circular(20), // Bordes muy redondeados
        border: Border.all(
            color: freshMint.withOpacity(0.3)), // Borde semitransparente
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Tamaño mínimo en el eje principal
        children: [
          const Icon(Icons.face,
              size: 16, color: freshMint), // Icono de cara pequeño
          const SizedBox(width: 8), // Espaciador horizontal
          Text(
            'Personalizar avatar', // Texto del botón
            style: AppFont.bodySmall.copyWith(
              // Estilo de texto pequeño
              color: freshMint, // Color verde menta
              fontWeight: FontWeight.w500, // Peso medio
            ),
          ),
          const SizedBox(width: 8), // Espaciador horizontal
          const Icon(Icons.arrow_forward,
              size: 14, color: freshMint), // Icono de flecha muy pequeño
        ],
      ),
    );
  }

  /*
      MÉTODOS PARA LAS ACCIONES

      CAMBIAR FOTO DE PERFIL (NO IMPLEMENTADO COMPLETAMENTE)
  */
  void _changeProfilePhoto() {
    showDialog(
      // Mostrar diálogo
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar foto',
            style: AppFont.titleSmall), // Título del diálogo
        content: const Text('Selecciona una opción',
            style: AppFont.bodyMedium), // Contenido
        actions: [
          // Botones de acción
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancelar
            child: const Text('Cancelar', style: AppFont.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              _updateUser(_currentUser.copyWith(// Actualizar usuario
                  // Nota: UserModel no tiene imageUrl, así que comentamos esto
                  // imageUrl: 'https://example.com/nueva-foto.jpg',
                  ));
            },
            child: const Text('Galería',
                style: AppFont.bodyMedium), // Opción galería
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
            },
            child: const Text('Cámara',
                style: AppFont.bodyMedium), // Opción cámara
          ),
        ],
      ),
    );
  }

  /*
      EDITAR NOMBRE
  */
  void _editName() {
    TextEditingController nameController = TextEditingController(
        text: _currentUser.name); // Controlador con nombre actual

    showDialog(
      // Mostrar diálogo de edición
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nombre', style: AppFont.titleSmall), // Título
        content: TextField(
          // Campo de texto para editar
          controller: nameController, // Controlador del texto
          decoration: InputDecoration(
            hintText: 'Ingresa tu nombre', // Texto de ayuda
            border: OutlineInputBorder(
              // Borde del campo
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
          ),
        ),
        actions: [
          // Botones de acción
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancelar
            child: const Text('Cancelar', style: AppFont.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                // Validar que no esté vacío
                _updateUser(// Actualizar usuario
                    _currentUser.copyWith(
                        name: nameController.text.trim())); // Nuevo nombre
                Navigator.pop(context); // Cerrar diálogo
              }
            },
            child: const Text('Guardar',
                style: AppFont.bodyMedium), // Guardar cambios
          ),
        ],
      ),
    );
  }

  /*
      EDITAR EMAIL
  */
  void _editEmail() {
    TextEditingController emailController = TextEditingController(
        text: _currentUser.email); // Controlador con email actual

    showDialog(
      // Mostrar diálogo de edición
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar email', style: AppFont.titleSmall), // Título
        content: TextField(
          // Campo de texto para editar
          controller: emailController, // Controlador del texto
          decoration: InputDecoration(
            hintText: 'Ingresa tu email', // Texto de ayuda
            border: OutlineInputBorder(
              // Borde del campo
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
          ),
          keyboardType: TextInputType.emailAddress, // Teclado para email
        ),
        actions: [
          // Botones de acción
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancelar
            child: const Text('Cancelar', style: AppFont.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              if (emailController.text.trim().isNotEmpty) {
                // Validar que no esté vacío
                _updateUser(// Actualizar usuario
                    _currentUser.copyWith(
                        email: emailController.text.trim())); // Nuevo email
                Navigator.pop(context); // Cerrar diálogo
              }
            },
            child: const Text('Guardar',
                style: AppFont.bodyMedium), // Guardar cambios
          ),
        ],
      ),
    );
  }

  /*
      MOSTRAR INFORMACIÓN DE RANGO
  */
  void _showRankInfo() {
    showDialog(
      // Mostrar diálogo informativo
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sistema de Rangos',
            style: AppFont.titleSmall), // Título
        content: Column(
          // Contenido en columna
          mainAxisSize: MainAxisSize.min, // Tamaño mínimo en eje principal
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinear al inicio horizontal
          children: [
            Text('Tu rango actual: ${_currentUser.displayRank}', // Rango actual
                style: AppFont.bodyMedium),
            const SizedBox(height: 16), // Espaciador vertical
            const Text('• Semilla - Nivel inicial',
                style: AppFont.bodySmall), // Descripción de rangos
            const Text('• Brote - 10 plantas cultivadas',
                style: AppFont.bodySmall),
            const Text('• Árbol - 25 plantas cultivadas',
                style: AppFont.bodySmall),
            const Text('• Bosque - 50+ plantas cultivadas',
                style: AppFont.bodySmall),
          ],
        ),
        actions: [
          // Botón de acción
          TextButton(
            onPressed: () => Navigator.pop(context), // Cerrar diálogo
            child: const Text('Entendido', style: AppFont.bodyMedium),
          ),
        ],
      ),
    );
  }

  /*
      EDITAR PERFIL (LLAMA A EDITAR NOMBRE)
  */
  void _editProfile() {
    _editName(); // Por ahora solo edita el nombre
  }

  /*
      ABRIR CONFIGURACIÓN (PRÓXIMAMENTE)
  */
  void _openSettings() {
    _showComingSoon(context); // Mostrar mensaje de "próximamente"
  }

  /*
      MOSTRAR AYUDA (PRÓXIMAMENTE)
  */
  void _showHelp() {
    _showComingSoon(context); // Mostrar mensaje de "próximamente"
  }

  /*
      MOSTRAR MENSAJE DE "PRÓXIMAMENTE"
  */
  void _showComingSoon(BuildContext context) {
    showDialog(
      // Mostrar diálogo
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: sunflower, // Fondo amarillo
          title:
              const Text('Próximamente', style: AppFont.titleMedium), // Título
          content: const Text(
              'Esta funcionalidad estará disponible pronto.', // Mensaje
              style: AppFont.bodyMedium),
          actions: [
            // Botón de acción
            TextButton(
              onPressed: () => Navigator.pop(context), // Cerrar diálogo
              child: const Text('OK', style: AppFont.button),
            ),
          ],
        );
      },
    );
  }
}
