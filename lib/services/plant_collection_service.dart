import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia de las plantas descubiertas en la experiencia AR.
class PlantCollectionService {
  PlantCollectionService._();

  static const String _discoveredKey = 'discovered_plants';

  /// Lista de slugs descubiertos por el usuario.
  static Future<Set<String>> getDiscoveredSlugs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return (prefs.getStringList(_discoveredKey) ?? []).toSet();
    } catch (_) {
      return {};
    }
  }

  /// Marca una planta como descubierta. Devuelve `true` si era nueva.
  static Future<bool> addDiscovered(String slug) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final discovered = prefs.getStringList(_discoveredKey) ?? [];
      if (discovered.contains(slug)) return false;

      discovered.add(slug);
      await prefs.setStringList(_discoveredKey, discovered);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Indica si una planta ya fue descubierta.
  static Future<bool> isDiscovered(String slug) async {
    final slugs = await getDiscoveredSlugs();
    return slugs.contains(slug);
  }
}
