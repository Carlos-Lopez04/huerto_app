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
import 'package:huerto_app/screens/camera/camera_screen.dart'; // Importar pantalla de cámara
import 'package:huerto_app/screens/camera/qr_scanner_screen.dart'; // Importar pantalla de escáner QR
import 'package:huerto_app/screens/camera/test_qr_with_image.dart'; // IMPORTAR PANTALLA DE PRUEBA QR
import 'dart:io'; // Importar para manejar archivos
import 'package:huerto_app/screens/plants_info_screen.dart'; // Importar pantalla de información de plantas


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
          
          // ========== NUEVAS OPCIONES DE CÁMARA Y ESCÁNER ==========
          // Opción 1: Escanear (QR/Barras)
          _buildDrawerItem(
            icon: Icons.qr_code_scanner, // Icono de escáner QR
            title: 'Escanear', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _navigateToScanner(context); // Navega al escáner
            },
          ),
          
          // Opción 2: Cámara General
          _buildDrawerItem(
            icon: Icons.camera_alt, // Icono de cámara
            title: 'Cámara', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              _navigateToCamera(context); // Navega a la cámara
            },
          ),
          
          // ========== NUEVO: BOTÓN DE PRUEBA QR CON IMAGEN ==========
          // Opción 3: Probar QR con Imagen (para desarrollo/pruebas)
          // _buildDrawerItem(
          //   icon: Icons.qr_code, // Icono de código QR
          //   title: 'Probar QR (Imagen)', // Título del item
          //   onTap: () {
              // Acción al tocar
          //     Navigator.pop(context); // Cierra el drawer
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const TestQRWithImage(),
          //       ),
          //     );
          //   },
          // ),
          // =========================================================
          
          // ========== NUEVO: BOTÓN DE INFORMACIÓN DE PLANTAS ==========
          // Opción 4: Información de Plantas (con API)
          _buildDrawerItem(
            icon: Icons.grass, // Icono de planta/grass
            title: 'Información de Plantas', // Título del item
            onTap: () {
              // Acción al tocar
              Navigator.pop(context); // Cierra el drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlantInfoScreen(),
                ),
              );
            },
          ),
          // ===========================================================
          
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

  /* ========== MÉTODOS DE NAVEGACIÓN PARA CÁMARA Y ESCÁNER ========== */
  
  /*
    Método para navegar al escáner QR/Código de barras
  */
  static Future<void> _navigateToScanner(BuildContext context) async {
    final String? scannedCode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onScanCompleted: (code) {
            Navigator.pop(context, code);
          },
        ),
      ),
    );
    
    if (scannedCode != null && context.mounted) {
      // Procesar el código escaneado
      _processScannedCode(context, scannedCode);
    }
  }
  
  /*
    Procesar el código QR escaneado
  */
  static void _processScannedCode(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blancoHueso,
        title: const Row(
          children: [
            Icon(Icons.qr_code, color: forestDepth),
            SizedBox(width: 8),
            Text('Código Escaneado', style: AppFont.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: verdeGelido,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                code,
                style: AppFont.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: forestDepth,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Código QR procesado correctamente.',
              style: AppFont.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: AppFont.button),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Aquí puedes agregar lógica adicional según el tipo de código
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: forestDepth,
                  content: Text('Código QR registrado exitosamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Aceptar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: forestDepth,
              foregroundColor: blancoHueso,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  /*
    Método para navegar a la cámara
  */
  static Future<void> _navigateToCamera(BuildContext context) async {
    final File? photo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          onPhotoCaptured: (photo) {
            Navigator.pop(context, photo);
          },
          enableVideo: false, // Solo fotos por ahora
        ),
      ),
    );
    
    if (photo != null && context.mounted) {
      // Aquí puedes manejar la foto capturada
      _showPhotoTakenDialog(context, photo);
    }
  }
  
  /*
    Diálogo para mostrar la foto capturada
  */
  static void _showPhotoTakenDialog(BuildContext context, File photo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blancoHueso,
          title: const Row(
            children: [
              Icon(Icons.camera_alt, color: forestDepth),
              SizedBox(width: 8),
              Text('Foto Capturada', style: AppFont.titleMedium),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(photo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Qué deseas hacer con esta foto?',
                style: AppFont.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: AppFont.button),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Aquí puedes agregar la lógica para guardar la foto
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: forestDepth,
                    content: Text('Foto guardada correctamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: forestDepth,
                foregroundColor: blancoHueso,
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
  
  /* ========== FIN MÉTODOS DE NAVEGACIÓN ========== */

  /*
    Construye el encabezado del Drawer con información del usuario
  */
  static Widget _buildDrawerHeader(BuildContext context, UserModel user) {
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
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AvatarWidget(
                        user: user,
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
                          user.name,
                          style: AppFont.titleMedium.copyWith(
                            color: cloudWhite,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
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
                                  const Icon(
                                      Icons.workspace_premium,
                                      size: 12,
                                      color: cloudWhite),
                                  const SizedBox(width: 4),
                                  Text(
                                    user.displayRank,
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
                                  Icon(
                                      user.gender == UserGender.femenino
                                          ? Icons.person_2
                                          : Icons.person,
                                      size: 12,
                                      color: cloudWhite),
                                  const SizedBox(width: 4),
                                  Text(
                                    user.displayGender,
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
                                    '${user.totalPoints} pts',
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
                                    'Nivel ${user.level}',
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cloudWhite.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app,
                        size: 12, color: cloudWhite),
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

  /*
    Método para construir items del menú del drawer
  */
  static Widget _buildDrawerItem({
    required String title,
    required VoidCallback onTap,
    IconData? icon,
    String? customIconPath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 2),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.transparent,
        hoverColor: emeraldLeaf.withOpacity(0.1),
      ),
    );
  }

  /*
    Método para navegar a la pantalla de perfil
  */
  static void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          user: currentUser,
          onUserUpdated: (updatedUser) {
            updateUser(updatedUser);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: forestDepth,
                  content: Text('Perfil actualizado',
                      style: AppFont.bodyMedium),
                  duration: Duration(seconds: 2),
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
      context,
      MaterialPageRoute(
        builder: (context) => AchievementsScreen(
          user: currentUser,
          onUserUpdated: (UserModel user) {
            updateUser(user);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: emeraldLeaf,
                  content: Text('Logros actualizados',
                      style: AppFont.bodyMedium),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            return user;
          },
        ),
      ),
    );

    if (updatedUser != null) {
      updateUser(updatedUser);
    }
  }

  /*
    NUEVO: Método para navegar a seguimiento de actividades
  */
  static void _navigateToActivityTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityTrackingScreen(
          user: currentUser,
          onUserUpdated: (updatedUser) {
            updateUser(updatedUser);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: freshMint,
                  content: Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '¡Actividad registrada! +10 puntos',
                        style: AppFont.bodyMedium
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  duration:
                      const Duration(seconds: 2),
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
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blancoHueso,
          title: const Row(
            children: [
              Icon(Icons.hourglass_top,
                  color: sunflower),
              SizedBox(width: 8),
              Text('Próximamente',
                  style: AppFont.titleMedium),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction,
                  size: 50, color: goldenSun),
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
              child: const Text('Entendido',
                  style: AppFont.button),
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

  /*
    Diálogo para cerrar sesión
  */
  static void _showLogoutDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blancoHueso,
          title: const Row(
            children: [
              Icon(Icons.logout, color: tomatoRed),
              SizedBox(width: 8),
              Text('Cerrar Sesión',
                  style: AppFont.titleMedium),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarWidget(
                user: user,
                size: 60,
                showBorder: true,
                borderColor:
                    tomatoRed.withOpacity(0.3),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: verdeGelido,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildStatRow('Puntos totales',
                        '${user.totalPoints}'),
                    _buildStatRow('Nivel', '${user.level}'),
                    _buildStatRow('Rango', user.displayRank),
                    _buildStatRow(
                        'Género', user.displayGender),
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
              child: const Text('Cancelar',
                  style: AppFont.button),
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

  /*
    Widget auxiliar para mostrar filas de estadísticas
  */
  static Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppFont.bodySmall
                  .copyWith(color: Colors.grey[600])),
          Text(value,
              style: AppFont.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: forestDepth,
              )),
        ],
      ),
    );
  }

  /*
    Método para realizar el logout
  */
  static void _performLogout(BuildContext context) {
    final user = currentUser;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: forestDepth,
        content: Row(
          children: [
            const Icon(Icons.check_circle,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Sesión cerrada - ¡Hasta pronto, ${user.name}!',
              style: AppFont.bodyMedium
                  .copyWith(color: Colors.white),
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
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar();
          },
        ),
      ),
    );

    Navigator.popUntil(
        context, (route) => route.isFirst);
  }

  /*
    NUEVO: Diálogo para mostrar progreso del usuario
  */
  static void _showProgressDialog(BuildContext context, UserModel user) {
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
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
                  crossAxisAlignment: CrossAxisAlignment
                      .start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          'Nivel ${user.level}',
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
                      value:
                          user.levelProgress,
                      backgroundColor:
                          Colors.white.withOpacity(0.3),
                      color: Colors.white,
                      minHeight: 10,
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          'Progreso: ${(user.levelProgress * 100).toStringAsFixed(0)}%',
                          style: AppFont.bodySmall.copyWith(
                              color: Colors.white70),
                        ),
                        Text(
                          '${user.pointsToNextLevel} pts para nivel ${user.level + 1}',
                          style: AppFont.bodySmall.copyWith(
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

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
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _buildStatCard(
                    'Actividades Complet.',
                    '${user.completedActivityIds.length}',
                    Icons.checklist,
                    freshMint,
                  ),
                  _buildStatCard(
                    'Favoritos',
                    '${user.favoriteActivityIds.length}',
                    Icons.favorite,
                    sunflower,
                  ),
                  _buildStatCard(
                    'Puntos Total',
                    '${user.totalPoints}',
                    Icons.star,
                    goldenSun,
                  ),
                  _buildStatCard(
                    'Rango',
                    user.displayRank,
                    Icons.leaderboard,
                    clearBlue,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToActivityTracking(
                        context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: forestDepth,
                    foregroundColor: blancoHueso,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.timeline, size: 18),
                  label:
                      const Text('Ver Progreso Detallado'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cerrar', style: AppFont.button),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),
    );
  }

  /*
    Método auxiliar para construir tarjetas de estadísticas
  */
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
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
}