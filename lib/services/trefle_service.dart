import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/plant_model.dart';

/// Cliente del API abierto de Trefle (https://trefle.io).
///
/// Permite identificar cualquier planta por nombre (comun o cientifico) y
/// recuperar datos botanicos verificables (nombre cientifico, familia,
/// genero, descripcion y, cuando estan disponibles, condiciones de cultivo).
///
/// Requiere un token gratuito en la variable de entorno `TREFLE_TOKEN`.
class TrefleService {
  TrefleService._();

  static const String _base = 'https://trefle.io/api/v1';
  static const Duration _timeout = Duration(seconds: 20);

  static String get _token => dotenv.env['TREFLE_TOKEN']?.trim() ?? '';

  /// Indica si el API esta configurado (hay token).
  static bool get isConfigured => _token.isNotEmpty;

  /// Resuelve una planta por nombre. Devuelve [null] si no se pudo resolver.
  static Future<PlantModel?> resolve(String query) async {
    if (_token.isEmpty) return null;

    try {
      final results = await _search(query);
      if (results == null || results.isEmpty) return null;

      final first = results.first;
      final slug = first['slug']?.toString();

      var data = first;
      if (slug != null && slug.isNotEmpty) {
        final detail = await _detail(slug);
        if (detail != null) data = detail;
      }

      return _mapToPlant(data, query);
    } catch (_) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> _search(String query) async {
    final uri = Uri.parse('$_base/species/search').replace(
      queryParameters: {'q': query, 'token': _token},
    );
    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'];
    if (data is! List) return null;

    return data
        .whereType<Map<String, dynamic>>()
        .cast<Map<String, dynamic>>()
        .toList();
  }

  static Future<Map<String, dynamic>?> _detail(String slug) async {
    final uri =
        Uri.parse('$_base/species/${Uri.encodeComponent(slug)}').replace(
      queryParameters: {'token': _token},
    );
    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'];
    if (data is! Map<String, dynamic>) return null;
    return data;
  }

  static PlantModel _mapToPlant(Map<String, dynamic> d, String fallbackName) {
    final growth = _asMap(d['growth']);

    final scientific = _text(d['scientific_name']);
    final common = _text(d['common_name']);
    final name = common.isNotEmpty
        ? common
        : (scientific.isNotEmpty ? scientific : fallbackName);

    return PlantModel(
      name: name,
      scientificName: scientific.isEmpty ? 'No disponible' : scientific,
      description: _description(d, growth),
      care: CareInfo(
        watering: _watering(growth['soil_humidity']),
        light: _light(growth['light']),
        temperature: _temperature(growth),
        soil: _soil(growth),
      ),
      sowingSeason: _sowing(growth),
      harvestTime: _harvest(growth),
      benefits: _benefits(d),
      curiousFacts: _curiousFacts(d),
    );
  }

  // ---- Helpers de mapeo ----

  static Map<String, dynamic> _asMap(dynamic v) =>
      v is Map<String, dynamic> ? v : const {};

  static String _text(dynamic v) {
    if (v == null) return '';
    return v.toString().trim();
  }

  static num? _toNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    return num.tryParse(v.toString());
  }

  static num? _nestedNum(dynamic m, String key) {
    if (m is! Map) return null;
    return _toNum(m[key]);
  }

  static String _description(
    Map<String, dynamic> d,
    Map<String, dynamic> growth,
  ) {
    final desc = _text(growth['description']);
    if (desc.isNotEmpty) return desc;
    final obs = _text(d['observations']);
    if (obs.isNotEmpty) return obs;
    return 'Sin descripción disponible.';
  }

  /// Interpreta `soil_humidity` (escala 0-10; mayor = mas humedad).
  static String _watering(dynamic v) {
    final n = _toNum(v);
    if (n == null) return 'No disponible';
    if (n >= 8) return 'Riego frecuente (suelo húmedo)';
    if (n >= 5) return 'Riego moderado';
    if (n >= 3) return 'Riego ocasional';
    return 'Riego escaso';
  }

  /// Interpreta `light` (escala 0-10; mayor = mas sol).
  static String _light(dynamic v) {
    final n = _toNum(v);
    if (n == null) return 'No disponible';
    if (n >= 8) return 'Pleno sol';
    if (n >= 6) return 'Sol parcial';
    if (n >= 4) return 'Semisombra';
    return 'Sombra';
  }

  static String _temperature(Map<String, dynamic> growth) {
    final min = _nestedNum(growth['minimum_temperature'], 'deg_c');
    final max = _nestedNum(growth['maximum_temperature'], 'deg_c');
    if (min == null && max == null) return 'No disponible';
    final minC = min?.round();
    final maxC = max?.round();
    if (minC != null && maxC != null) return '$minC °C a $maxC °C';
    if (minC != null) return 'Mínima $minC °C';
    return 'Máxima ${maxC!} °C';
  }

  /// Mapea `soil_texture` (enum de Trefle) a una etiqueta en español.
  static String _soil(Map<String, dynamic> growth) {
    final t = _toNum(growth['soil_texture']);
    if (t == null) return 'No disponible';
    switch (t.round()) {
      case 1:
        return 'Suelo arcilloso';
      case 2:
        return 'Suelo intermedio';
      case 3:
        return 'Suelo limoso';
      case 4:
        return 'Suelo arenoso fino';
      case 5:
        return 'Suelo arenoso grueso';
      case 6:
      case 7:
      case 8:
      case 9:
        return 'Suelo pedregoso';
      default:
        return 'No disponible';
    }
  }

  static String _sowing(Map<String, dynamic> growth) {
    final s = _text(growth['sowing']);
    return s.isNotEmpty ? s : 'No disponible';
  }

  static String _harvest(Map<String, dynamic> growth) {
    final days = _toNum(growth['days_to_harvest']);
    if (days == null) return 'No disponible';
    return '${days.round()} días (aprox.)';
  }

  static String _benefits(Map<String, dynamic> d) {
    if (d['edible'] == true || d['vegetable'] == true) {
      return 'Especie comestible.';
    }
    return 'Información no disponible';
  }

  static String _curiousFacts(Map<String, dynamic> d) {
    final family = _text(d['family']);
    final genus = _text(d['genus']);
    final cycle = _duration(d['duration']);
    final parts = <String>[
      if (family.isNotEmpty) 'Familia: $family',
      if (genus.isNotEmpty) 'Género: $genus',
      if (cycle.isNotEmpty) 'Ciclo: $cycle',
    ];
    if (parts.isEmpty) return 'Datos taxonómicos no disponibles';
    return parts.join(' · ');
  }

  static String _duration(dynamic v) {
    final String raw;
    if (v is List && v.isNotEmpty) {
      raw = v.first.toString();
    } else {
      raw = _text(v);
    }
    final s = raw.toLowerCase();
    if (s.contains('annual')) return 'Anual';
    if (s.contains('biennial')) return 'Bienal';
    if (s.contains('perennial')) return 'Perenne';
    return '';
  }
}
