import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huerto_app/services/plant_collection_service.dart';
import 'package:huerto_app/services/plant_repository.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

/// Pantalla "Mi Herbario": muestra las plantas descubiertas con el escáner AR
/// y el progreso de la colección.
class PlantCollectionScreen extends StatefulWidget {
  const PlantCollectionScreen({super.key});

  @override
  State<PlantCollectionScreen> createState() => _PlantCollectionScreenState();
}

class _PlantCollectionScreenState extends State<PlantCollectionScreen> {
  Set<String> _discovered = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final slugs = await PlantCollectionService.getDiscoveredSlugs();
    if (mounted) {
      setState(() {
        _discovered = slugs;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = PlantRepository.availableSlugs;
    final discoveredCount = catalog.where(_discovered.contains).length;
    final extra =
        _discovered.where((slug) => !catalog.contains(slug)).toList();
    final progress =
        catalog.isEmpty ? 0.0 : discoveredCount / catalog.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Herbario'),
        backgroundColor: forestDepth,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildProgressCard(discoveredCount, catalog.length, progress),
                const SizedBox(height: 24),
                const Text('Plantas del catálogo',
                    style: AppFont.titleMedium),
                const SizedBox(height: 12),                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    for (final slug in catalog)
                      _plantCard(slug, _discovered.contains(slug)),
                  ],
                ),
                if (extra.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('Otras plantas descubiertas',
                      style: AppFont.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final slug in extra)
                        Chip(
                          label: Text(_pretty(slug)),
                          avatar: const Icon(Icons.eco,
                              size: 16, color: forestDepth),
                          backgroundColor: verdeGelido,
                        ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildProgressCard(int discovered, int total, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: forestDepth,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.eco, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Text(
            'Colección de plantas',
            style: AppFont.titleMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white24,
              color: goldenSun,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$discovered de $total plantas del huerto',
            style: AppFont.bodySmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _plantCard(String slug, bool discovered) {
    final plant = PlantRepository.localInfo(slug);
    final name = plant?.name ?? _pretty(slug);
    final scientific = plant?.scientificName ?? '';

    return Container(
      decoration: BoxDecoration(
        color: discovered ? verdeGelido : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: discovered ? emeraldLeaf : Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            discovered ? Icons.eco : Icons.help_outline,
            size: 36,
            color: discovered ? forestDepth : Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              discovered ? name : '???',
              textAlign: TextAlign.center,
              style: AppFont.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: discovered ? forestDepth : Colors.grey,
              ),
            ),
          ),
          if (discovered && scientific.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                scientific,
                textAlign: TextAlign.center,
                style: AppFont.bodySmall.copyWith(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _pretty(String slug) {
    final local = PlantRepository.localInfo(slug);
    if (local != null) return local.name;
    final words = slug.split(RegExp(r'[_\-\s]+')).where((w) => w.isNotEmpty);
    return words
        .map((w) =>
            w.length == 1 ? w.toUpperCase() : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
