import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/plant_model.dart';

/// Cliente del API de Perenual (https://perenual.com/docs/api).
///
/// Aporta datos de cuidado (riego, luz, suelo, cosecha) en ingles, que aqui se
/// traducen a español. Complementa a Trefle (taxonomia/descripcion).
///
/// Requiere una API key en la variable de entorno `PERENUAL_KEY`.
/// Plan gratuito: 100 peticiones/dia y especies 1-3000.
class PerenualService {
  PerenualService._();

  static const String _base = 'https://perenual.com/api/v2';
  static const Duration _timeout = Duration(seconds: 20);

  static String get _key => dotenv.env['PERENUAL_KEY']?.trim() ?? '';

  static bool get isConfigured => _key.isNotEmpty;

  /// Resuelve una planta por nombre. Devuelve [null] si no se pudo resolver.
  static Future<PlantModel?> resolve(String query) async {
    if (_key.isEmpty) return null;

    try {
      final id = await _searchId(query);
      if (id == null) return null;

      final detail = await _detail(id);
      if (detail == null) return null;

      return _mapToPlant(detail, query);
    } catch (_) {
      return null;
    }
  }

  static Future<int?> _searchId(String query) async {
    final uri = Uri.parse('$_base/species-list').replace(
      queryParameters: {'key': _key, 'q': query},
    );
    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'];
    if (data is! List || data.isEmpty) return null;

    final first = data.first;
    if (first is! Map<String, dynamic>) return null;
    final id = first['id'];
    return id is int ? id : int.tryParse('$id');
  }

  static Future<Map<String, dynamic>?> _detail(int id) async {
    final uri = Uri.parse('$_base/species/details/$id').replace(
      queryParameters: {'key': _key},
    );
    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return body;
  }

  static PlantModel _mapToPlant(Map<String, dynamic> d, String fallbackName) {
    final scientific = _firstOf(d['scientific_name']);
    final common = _text(d['common_name']);
    final name = common.isNotEmpty ? common : (scientific.isNotEmpty ? scientific : fallbackName);

    return PlantModel(
      name: name,
      scientificName: scientific.isEmpty ? 'No disponible' : scientific,
      description: _text(d['description']).isNotEmpty
          ? _text(d['description'])
          : 'Sin descripción disponible.',
      care: CareInfo(
        watering: _mapWatering(_text(d['watering'])),
        light: _mapSunlight(_firstOf(d['sunlight'])),
        temperature: 'No disponible',
        soil: _mapSoil(d['soil']),
      ),
      sowingSeason: 'Consultar guía local',
      harvestTime: _mapHarvest(d['harvest_season']),
      benefits: _benefits(d),
      curiousFacts: _curiousFacts(d),
    );
  }

  // ---- Helpers ----

  static String _text(dynamic v) => v == null ? '' : v.toString().trim();

  static String _firstOf(dynamic v) {
    if (v is List && v.isNotEmpty) return _text(v.first);
    return _text(v);
  }

  static String _mapWatering(String value) {
    switch (value.toLowerCase()) {
      case 'frequent':
        return 'Riego frecuente';
      case 'average':
        return 'Riego moderado';
      case 'minimum':
        return 'Riego escaso';
      case 'none':
        return 'Sin riego (tolera sequía)';
      default:
        return 'No disponible';
    }
  }

  static String _mapSunlight(String value) {
    switch (value.toLowerCase()) {
      case 'full_sun':
        return 'Pleno sol';
      case 'sun-part_shade':
        return 'Sol parcial';
      case 'part_shade':
        return 'Semisombra';
      case 'full_shade':
        return 'Sombra';
      default:
        return 'No disponible';
    }
  }

  static String _mapSoil(dynamic v) {
    if (v is! List || v.isEmpty) return 'No disponible';
    final terms = v
        .map((e) => _mapSoilTerm(_text(e)))
        .where((e) => e.isNotEmpty)
        .toList();
    if (terms.isEmpty) return 'No disponible';
    return terms.join(', ');
  }

  static String _mapSoilTerm(String value) {
    final s = value.toLowerCase();
    if (s.contains('drain')) return 'Bien drenado';
    if (s.contains('dry')) return 'Seco';
    if (s.contains('moist')) return 'Húmedo';
    if (s.contains('clay')) return 'Arcilloso';
    if (s.contains('loam')) return 'Franco';
    if (s.contains('sand')) return 'Arenoso';
    if (s.contains('rock')) return 'Rocoso';
    if (s.contains('fertile')) return 'Fértil';
    return value;
  }

  static String _mapHarvest(dynamic v) {
    final s = _text(v).toLowerCase();
    if (s.isEmpty) return 'No disponible';
    const seasons = {
      'spring': 'primavera',
      'summer': 'verano',
      'autumn': 'otoño',
      'fall': 'otoño',
      'winter': 'invierno',
    };
    final mapped = seasons[s];
    return mapped != null ? 'Cosecha en $mapped' : 'Cosecha en ${_text(v)}';
  }

  static String _benefits(Map<String, dynamic> d) {
    final parts = <String>[
      if (d['medicinal'] == true) 'Tiene usos medicinales',
      if (d['edible_fruit'] == true || d['cuisine'] == true) 'Especie comestible',
    ];
    if (parts.isEmpty) return 'Información no disponible';
    return '${parts.join('. ')}.';
  }

  static String _curiousFacts(Map<String, dynamic> d) {
    final family = _text(d['family']);
    final type = _text(d['type']);
    final origin = _firstOf(d['origin']);
    final parts = <String>[
      if (family.isNotEmpty) 'Familia: $family',
      if (type.isNotEmpty) 'Tipo: $type',
      if (origin.isNotEmpty) 'Origen: $origin',
    ];
    if (parts.isEmpty) return 'Datos no disponibles';
    return parts.join(' · ');
  }
}
