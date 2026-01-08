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
    final result = ActivityService.registerActivity(_currentUser, activityId);

    setState(() {
      _currentUser = result.$1;
    });

    widget.onUserUpdated(_currentUser);

    // Mostrar notificación de puntos
    final activity = ActivityService.getAvailableActivities()
        .firstWhere((a) => a.id == activityId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: freshMint,
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              '+${activity.points} puntos ganados!',
              style: AppFont.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = ActivityService.getAvailableActivities();
    final categorizedActivities = ActivityService.getActivitiesByCategory();
    final statsMap = ActivityService.getActivityStats(_currentUser);

    // Convertir Map a ActivityStats si es necesario, o trabajar directamente con el mapa
    final stats = statsMap is Map<String, dynamic>
        ? _parseStatsFromMap(statsMap)
        : statsMap as ActivityStats;

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

  // Método para parsear Map a ActivityStats
  ActivityStats _parseStatsFromMap(Map<String, dynamic> map) {
    return ActivityStats(
      userId: map['userId'] ?? _currentUser.id,
      totalActivities: map['totalActivities'] ?? 0,
      totalPoints: map['totalPoints'] ?? 0,
      activitiesByCategory:
          Map<String, int>.from(map['activitiesByCategory'] ?? {}),
      activitiesByDay: Map<String, int>.from(map['activitiesByDay'] ?? {}),
      mostActiveCategory: map['mostActiveCategory'] ?? '',
      mostActiveDay: map['mostActiveDay'] ?? '',
      averageTimeSpent: Duration(seconds: map['averageTimeSpent'] ?? 0),
      currentStreak: map['currentStreak'] ??
          map['consecutiveDays'] ??
          0, // Intenta ambos nombres
      longestStreak: map['longestStreak'] ?? 0,
      activitiesByDifficulty:
          (map['activitiesByDifficulty'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(_parseDifficulty(key), value as int),
      ),
    );
  }

  ActivityDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
      case 'facil':
        return ActivityDifficulty.facil;
      case 'medio':
        return ActivityDifficulty.medio;
      case 'difícil':
      case 'dificil':
        return ActivityDifficulty.dificil;
      case 'experto':
        return ActivityDifficulty.experto;
      default:
        return ActivityDifficulty.facil;
    }
  }

  Widget _buildStatsCard(ActivityStats stats) {
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
                stats.totalActivities.toString(),
                Icons.checklist,
              ),
              _buildStatColumn(
                'Puntos Totales',
                stats.totalPoints.toString(),
                Icons.star,
              ),
              _buildStatColumn(
                'Días Seguidos',
                stats.currentStreak.toString(),
                Icons.calendar_today,
              ),
            ],
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
        Text(
          ActivityUtils.getCategoryName(category),
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
            final count = _currentUser.activityCounts[activity.id] ?? 0;

            return _buildActivityCard(activity, count);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildActivityCard(Activity activity, int count) {
    // activity.color ya es de tipo Color
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
                      '$count veces',
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
