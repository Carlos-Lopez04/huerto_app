// screens/activity_tracking_screen.dart - PARTE CORREGIDA
import 'package:flutter/material.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/models/activity_model.dart';
import 'package:huerto_app/services/activity_service.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

class ActivityTrackingScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated;

  const ActivityTrackingScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<ActivityTrackingScreen> createState() => _ActivityTrackingScreenState();
}

class _ActivityTrackingScreenState extends State<ActivityTrackingScreen> {
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _completeActivity(String activityId) {
    // Registrar actividad usando el servicio actualizado
    final (updatedUser, newAchievements) =
        ActivityService.registerActivityComplete(_currentUser, activityId);

    setState(() {
      _currentUser = updatedUser;
    });

    // Notificar cambios
    widget.onUserUpdated(_currentUser);

    // Mostrar notificación de puntos
    final activity = ActivityService.getActivityById(activityId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: freshMint,
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              '+${activity?.points ?? 0} puntos ganados!',
              style: AppFont.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // Mostrar notificación de logros nuevos
    if (newAchievements.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        for (final achievement in newAchievements) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: achievement.colorValue,
              content: Row(
                children: [
                  Text(achievement.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '¡Nuevo logro: ${achievement.title}!',
                      style: AppFont.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activities = ActivityService.getAvailableActivities();
    final categorizedActivities = ActivityService.getActivitiesByCategory();
    final stats = ActivityService.getActivityStats(_currentUser);

    return Scaffold(
      backgroundColor: blancoHueso,
      appBar: AppBar(
        title: const Text(
          'Actividades',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: forestDepth,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(_currentUser),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estadísticas
            _buildStatsCard(stats),
            const SizedBox(height: 20),

            // Actividades por categoría
            for (final category in categorizedActivities.keys)
              _buildActivityCategory(
                category,
                categorizedActivities[category]!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [emeraldLeaf, forestDepth],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Progreso de Actividades',
            style: AppFont.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(
                'Total Actividades',
                '${_currentUser.totalActivitiesCompleted}',
                Icons.checklist,
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
          if (stats['mostActiveCategory'] != 'Ninguna')
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Categoría favorita: ${stats['mostActiveCategory']}',
                    style: AppFont.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFont.titleSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppFont.bodySmall.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCategory(
      ActivityCategory category, List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CORREGIDO: Usar ActivityService.getCategoryDisplayName en lugar de _getCategoryDisplayName
        Text(
          ActivityService.getCategoryDisplayName(category),
          style: AppFont.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: forestDepth,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final count = _currentUser.getActivityCount(activity.id);

            return _buildActivityCard(activity, count);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildActivityCard(Activity activity, int count) {
    final color = activity.color;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _completeActivity(activity.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icono y título
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      activity.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activity.name,
                      style: AppFont.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: forestDepth,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Descripción
              Text(
                activity.description,
                style: AppFont.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Contador y puntos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count ${count == 1 ? 'vez' : 'veces'}',
                      style: AppFont.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: goldenSun),
                      const SizedBox(width: 2),
                      Text(
                        '+${activity.points}',
                        style: AppFont.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: goldenSun,
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
