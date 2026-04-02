// screens/activity_tracking_screen.dart - PARTE CORREGIDA
// Importa paquetes necesarios para la pantalla de seguimiento de actividades
import 'package:flutter/material.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/activity_model.dart';
import 'package:huerto_app/services/activity_service.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

/*
    PANTALLA DE SEGUIMIENTO DE ACTIVIDADES
*/

// Widget Stateful para registrar y mostrar actividades
class ActivityTrackingScreen extends StatefulWidget {
  final UserModel user; // Usuario actual
  final Function(UserModel) onUserUpdated; // Callback para actualizar usuario

  const ActivityTrackingScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<ActivityTrackingScreen> createState() => _ActivityTrackingScreenState();
}

class _ActivityTrackingScreenState extends State<ActivityTrackingScreen> {
  late UserModel _currentUser; // Copia local del usuario

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user; // Inicializar con usuario recibido
  }

  /*
    COMPLETAR UNA ACTIVIDAD
  */

  void _completeActivity(String activityId) {
    // Registrar actividad usando el servicio actualizado
    final (updatedUser, newAchievements) =
        ActivityService.registerActivityComplete(_currentUser, activityId);

    setState(() {
      _currentUser = updatedUser; // Actualizar usuario local
    });

    // Notificar cambios al widget padre
    widget.onUserUpdated(_currentUser);

    // Mostrar notificación de puntos
    final activity = ActivityService.getActivityById(activityId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: freshMint, // Color verde menta
        content: Row(
          children: [
            const Icon(Icons.star,
                color: Colors.white, size: 20), // Icono estrella
            const SizedBox(width: 8), // Espaciado
            Text(
              '+${activity?.points ?? 0} puntos ganados!', // Mensaje con puntos
              style: AppFont.bodyMedium
                  .copyWith(color: Colors.white), // Estilo blanco
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Duración corta
      ),
    );

    // Mostrar notificación de logros nuevos
    if (newAchievements.isNotEmpty) {
      // Si hay logros nuevos
      Future.delayed(const Duration(milliseconds: 500), () {
        // Retraso para mostrar después
        for (final achievement in newAchievements) {
          // Iterar sobre cada logro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: achievement.colorValue, // Color del logro
              content: Row(
                children: [
                  Text(achievement.icon,
                      style: const TextStyle(fontSize: 20)), // Icono del logro
                  const SizedBox(width: 8), // Espaciado
                  Expanded(
                    child: Text(
                      '¡Nuevo logro: ${achievement.title}!', // Mensaje con título
                      style: AppFont.bodyMedium
                          .copyWith(color: Colors.white), // Estilo
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3), // Duración más larga
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activities =
        ActivityService.getAvailableActivities(); // Todas las actividades
    final categorizedActivities =
        ActivityService.getActivitiesByCategory(); // Agrupadas
    final stats =
        ActivityService.getActivityStats(_currentUser); // Estadísticas

    return Scaffold(
      backgroundColor: blancoHueso, // Fondo blanco hueso
      appBar: AppBar(
        title: const Text(
          'Actividades', // Título de la pantalla
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
        backgroundColor: forestDepth, // Color verde bosque
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Botón regresar
          onPressed: () =>
              Navigator.of(context).pop(_currentUser), // Regresar con usuario
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Espaciado general
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda
          children: [
            // Estadísticas
            _buildStatsCard(stats), // Tarjeta de estadísticas
            const SizedBox(height: 20), // Espaciado

            // Actividades por categoría
            for (final category
                in categorizedActivities.keys) // Iterar categorías
              _buildActivityCategory(
                category,
                categorizedActivities[category]!, // Lista de actividades
              ),
          ],
        ),
      ),
    );
  }

  /*
    CONSTRUIR TARJETA DE ESTADÍSTICAS
  */

  Widget _buildStatsCard(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16), // Espaciado interno
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [emeraldLeaf, forestDepth], // Gradiente verde
          begin: Alignment.topLeft, // Inicio esquina superior izquierda
          end: Alignment.bottomRight, // Fin esquina inferior derecha
        ),
        borderRadius: BorderRadius.circular(16), // Bordes muy redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Sombra sutil
            blurRadius: 8, // Desenfoque
            offset: const Offset(0, 4), // Desplazamiento hacia abajo
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda
        children: [
          Text(
            'Tu Progreso de Actividades', // Título de la tarjeta
            style: AppFont.titleMedium.copyWith(
              color: Colors.white, // Texto blanco
              fontWeight: FontWeight.bold, // Negrita
            ),
          ),
          const SizedBox(height: 12), // Espaciado
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espaciado uniforme
            children: [
              _buildStatColumn(
                'Total Actividades', // Etiqueta
                '${_currentUser.totalActivitiesCompleted}', // Valor
                Icons.checklist, // Icono lista
              ),
              _buildStatColumn(
                'Puntos Totales',
                '${_currentUser.totalPoints}',
                Icons.star,
              ),
              _buildStatColumn(
                'Días Seguidos',
                '${_currentUser.consecutiveDays}',
                Icons.calendar_today,
              ),
            ],
          ),
          if (stats['mostActiveCategory'] !=
              'Ninguna') // Solo si hay categoría activa
            Padding(
              padding: const EdgeInsets.only(top: 12), // Espaciado superior
              child: Row(
                children: [
                  const Icon(Icons.emoji_events,
                      size: 16, color: Colors.white), // Icono trofeo
                  const SizedBox(width: 8), // Espaciado
                  Text(
                    'Categoría favorita: ${stats['mostActiveCategory']}', // Mensaje
                    style: AppFont.bodySmall.copyWith(
                      color: Colors.white70, // Blanco semitransparente
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
    CONSTRUIR COLUMNA DE ESTADÍSTICA INDIVIDUAL
  */

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white), // Icono grande blanco
        const SizedBox(height: 4), // Espaciado pequeño
        Text(
          value, // Valor numérico
          style: AppFont.titleSmall.copyWith(
            color: Colors.white, // Blanco
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        Text(
          label, // Etiqueta descriptiva
          style: AppFont.bodySmall.copyWith(
            color: Colors.white70, // Blanco semitransparente
          ),
        ),
      ],
    );
  }

  /*
    CONSTRUIR SECCIÓN DE CATEGORÍA DE ACTIVIDADES
  */

  Widget _buildActivityCategory(
      ActivityCategory category, List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda
      children: [
        // CORREGIDO: Usar ActivityService.getCategoryDisplayName en lugar de _getCategoryDisplayName
        Text(
          ActivityService.getCategoryDisplayName(
              category), // Nombre de categoría
          style: AppFont.titleSmall.copyWith(
            fontWeight: FontWeight.bold, // Negrita
            color: forestDepth, // Color verde bosque
          ),
        ),
        const SizedBox(height: 8), // Espaciado
        GridView.builder(
          shrinkWrap: true, // Ajustar al contenido
          physics: const NeverScrollableScrollPhysics(), // Sin scroll interno
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columnas
            crossAxisSpacing: 12, // Espacio entre columnas
            mainAxisSpacing: 12, // Espacio entre filas
            childAspectRatio: 1.5, // Relación ancho/alto
          ),
          itemCount: activities.length, // Número de actividades
          itemBuilder: (context, index) {
            final activity = activities[index]; // Actividad actual
            final count =
                _currentUser.getActivityCount(activity.id); // Veces completada

            return _buildActivityCard(activity, count); // Tarjeta de actividad
          },
        ),
        const SizedBox(height: 20), // Espaciado entre categorías
      ],
    );
  }

  /*
    CONSTRUIR TARJETA DE ACTIVIDAD INDIVIDUAL
  */

  Widget _buildActivityCard(Activity activity, int count) {
    final color = activity.color; // Color de la actividad

    return Card(
      elevation: 2, // Elevación ligera
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      child: InkWell(
        onTap: () => _completeActivity(activity.id), // Completar al tocar
        borderRadius: BorderRadius.circular(12), // Radio del efecto táctil
        child: Container(
          padding: const EdgeInsets.all(12), // Espaciado interno
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1), // Color claro
                color.withOpacity(0.05), // Color más claro
              ],
              begin: Alignment.topLeft, // Inicio esquina superior izquierda
              end: Alignment.bottomRight, // Fin esquina inferior derecha
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alineación izquierda
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espacio uniforme
            children: [
              // Icono y título
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6), // Espaciado del icono
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2), // Fondo semitransparente
                      shape: BoxShape.circle, // Forma circular
                    ),
                    child: Text(
                      activity.icon, // Emoji de la actividad
                      style: const TextStyle(fontSize: 16), // Tamaño
                    ),
                  ),
                  const SizedBox(width: 8), // Espaciado
                  Expanded(
                    child: Text(
                      activity.name, // Nombre de la actividad
                      style: AppFont.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, // Negrita
                        color: forestDepth, // Color verde bosque
                      ),
                      maxLines: 1, // Una sola línea
                      overflow: TextOverflow
                          .ellipsis, // Puntos suspensivos si no cabe
                    ),
                  ),
                ],
              ),

              // Descripción
              Text(
                activity.description, // Descripción de la actividad
                style: AppFont.bodySmall.copyWith(
                  color: Colors.grey[600], // Color gris
                ),
                maxLines: 2, // Máximo dos líneas
                overflow: TextOverflow.ellipsis, // Puntos suspensivos
              ),

              // Contador y puntos
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Espaciado uniforme
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2), // Espaciado
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2), // Fondo semitransparente
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                    ),
                    child: Text(
                      '$count ${count == 1 ? 'vez' : 'veces'}', // Contador con texto singular/plural
                      style: AppFont.bodySmall.copyWith(
                        fontWeight: FontWeight.bold, // Negrita
                        color: color, // Color de la actividad
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: goldenSun), // Icono estrella
                      const SizedBox(width: 2), // Espaciado mínimo
                      Text(
                        '+${activity.points}', // Puntos de la actividad
                        style: AppFont.bodySmall.copyWith(
                          fontWeight: FontWeight.bold, // Negrita
                          color: goldenSun, // Color dorado
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
