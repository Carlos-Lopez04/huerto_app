import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:huerto_app/services/plant_collection_service.dart';
import 'package:huerto_app/services/user_service.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

/// Pantalla de misiones: retos con recompensa basados en el progreso del usuario.
class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  static const String _claimedKey = 'claimed_missions';

  final UserService _userService = UserService();
  int _discoveredCount = 0;
  Set<String> _claimed = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final discovered = await PlantCollectionService.getDiscoveredSlugs();
    final prefs = await SharedPreferences.getInstance();
    final claimed = (prefs.getStringList(_claimedKey) ?? []).toSet();
    if (mounted) {
      setState(() {
        _discoveredCount = discovered.length;
        _claimed = claimed;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _userService.currentUser;
    final missions = _buildMissions(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Misiones'),
        backgroundColor: forestDepth,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Completa retos para ganar puntos y monedas.',
                  style: AppFont.bodyMedium,
                ),
                const SizedBox(height: 16),
                for (final m in missions) _buildMissionCard(m),
              ],
            ),
    );
  }

  List<Map<String, dynamic>> _buildMissions(user) {
    final waterCount = user.getActivityCount('water_plant');
    final plantCount = user.getActivityCount('plant_seed');
    final totalActivities = user.totalActivitiesCompleted;

    return [
      {
        'id': 'm1',
        'title': 'Primer descubrimiento',
        'description': 'Descubre 1 planta con el escáner AR',
        'icon': Icons.emoji_nature,
        'target': 1,
        'current': _discoveredCount,
        'points': 20,
        'coins': 10,
      },
      {
        'id': 'm2',
        'title': 'Explorador botánico',
        'description': 'Descubre 5 plantas diferentes',
        'icon': Icons.explore,
        'target': 5,
        'current': _discoveredCount,
        'points': 50,
        'coins': 25,
      },
      {
        'id': 'm3',
        'title': 'Jardinero activo',
        'description': 'Completa 3 actividades',
        'icon': Icons.track_changes,
        'target': 3,
        'current': totalActivities,
        'points': 40,
        'coins': 15,
      },
      {
        'id': 'm4',
        'title': 'Maestro del agua',
        'description': 'Riega plantas 5 veces',
        'icon': Icons.water_drop,
        'target': 5,
        'current': waterCount,
        'points': 30,
        'coins': 20,
      },
      {
        'id': 'm5',
        'title': 'Manos a la tierra',
        'description': 'Planta 3 semillas',
        'icon': Icons.grass,
        'target': 3,
        'current': plantCount,
        'points': 30,
        'coins': 15,
      },
    ];
  }

  Widget _buildMissionCard(Map<String, dynamic> m) {
    final target = m['target'] as int;
    final current = m['current'] as int;
    final progress = target <= 0 ? 0.0 : (current / target).clamp(0.0, 1.0);
    final done = current >= target;
    final claimed = _claimed.contains(m['id']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: verdeGelido,
                  child: Icon(m['icon'] as IconData, color: forestDepth),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['title'] as String,
                        style: AppFont.bodyMedium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(m['description'] as String,
                          style: AppFont.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('+${m['points']} pts',
                        style: AppFont.bodySmall.copyWith(
                            color: forestDepth,
                            fontWeight: FontWeight.bold)),
                    Text('+${m['coins']} 🪙',
                        style: AppFont.bodySmall.copyWith(color: goldenSun)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: done ? emeraldLeaf : goldenSun,
              ),
            ),
            const SizedBox(height: 4),
            Text('$current de $target', style: AppFont.bodySmall),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: (done && !claimed) ? () => _claim(m) : null,
                icon: Icon(
                  claimed ? Icons.check : Icons.redeem,
                  size: 18,
                ),
                label: Text(
                  claimed ? 'Reclamado' : (done ? 'Reclamar' : 'En progreso'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: claimed ? Colors.grey.shade300 : goldenSun,
                  foregroundColor: forestDepth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _claim(Map<String, dynamic> m) async {
    final points = m['points'] as int;
    final coins = m['coins'] as int;

    await _userService.addPoints(points);
    await _userService.addCoins(coins);

    final prefs = await SharedPreferences.getInstance();
    final claimed = prefs.getStringList(_claimedKey) ?? [];
    claimed.add(m['id'] as String);
    await prefs.setStringList(_claimedKey, claimed);

    if (mounted) {
      setState(() {
        _claimed = claimed.toSet();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: forestDepth,
          behavior: SnackBarBehavior.floating,
          content: Text(
            '¡Recompensa reclamada! +$points pts, +$coins monedas',
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
