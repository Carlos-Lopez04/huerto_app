import 'package:huerto_app/models/plant_model.dart';
import 'package:huerto_app/services/perenual_service.dart';
import 'package:huerto_app/services/trefle_service.dart';

/// Repositorio de plantas para la experiencia de realidad aumentada.
///
/// Resuelve la información de una planta en este orden:
/// 1. Catalogo local (plantas comunes, en español, sin internet).
/// 2. Trefle (identificación amplia y verificable de cualquier planta).
/// 3. Perenual (datos de cuidado cuando Trefle no los trae).
/// 4. Datos de respaldo.
class PlantRepository {
  PlantRepository._();

  /// Catálogo local de plantas indexado por "slug".
  static const Map<String, Map<String, dynamic>> _catalog = {
    'tomate': {
      'name': 'Tomate',
      'scientific_name': 'Solanum lycopersicum',
      'description':
          'Hortaliza de fruto originaria de América. Necesita mucho sol y un '
          'riego constante para producir frutos jugosos.',
      'care': {
        'watering': 'Riego frecuente (2-3 veces por semana)',
        'light': 'Sol directo, 6-8 horas al día',
        'temperature': '18 °C a 27 °C',
        'soil': 'Tierra fértil, suelta y con buen drenaje',
      },
      'sowing_season': 'Primavera',
      'harvest_time': '60 a 85 días',
      'benefits': 'Rico en vitamina C, potasio y licopeno (antioxidante).',
      'curious_facts':
          'Botánicamente es una fruta, pero se consume como verdura.',
    },
    'albahaca': {
      'name': 'Albahaca',
      'scientific_name': 'Ocimum basilicum',
      'description':
          'Hierba aromática muy usada en la cocina. Crece rápido y atrae '
          'polinizadores benéficos al huerto.',
      'care': {
        'watering': 'Riego moderado, mantener tierra húmeda',
        'light': 'Sol directo o semisombra',
        'temperature': '20 °C a 28 °C',
        'soil': 'Suelo ligero y bien drenado',
      },
      'sowing_season': 'Primavera',
      'harvest_time': '45 a 60 días',
      'benefits': 'Aporta antioxidantes y propiedades antiinflamatorias.',
      'curious_facts':
          'Sus hojas se pueden cosechar varias veces en la misma planta.',
    },
    'aloe': {
      'name': 'Aloe Vera',
      'scientific_name': 'Aloe barbadensis miller',
      'description':
          'Planta suculenta conocida por el gel de sus hojas, usado para '
          'cuidar la piel. Requiere muy poco riego.',
      'care': {
        'watering': 'Riego escaso (cada 10-15 días)',
        'light': 'Sol directo o mucha luz indirecta',
        'temperature': '15 °C a 30 °C',
        'soil': 'Sustrato arenoso con excelente drenaje',
      },
      'sowing_season': 'Todo el año (clima cálido)',
      'harvest_time': '8 a 12 meses',
      'benefits': 'El gel hidrata y calma la piel; es cicatrizante natural.',
      'curious_facts':
          'Almacena agua en sus hojas, por eso sobrevive a la sequía.',
    },
    'lechuga': {
      'name': 'Lechuga',
      'scientific_name': 'Lactuca sativa',
      'description':
          'Hortaliza de hoja rápida de cultivar, ideal para huertos urbanos '
          'y macetas poco profundas.',
      'care': {
        'watering': 'Riego diario ligero',
        'light': 'Sol suave o semisombra',
        'temperature': '12 °C a 22 °C',
        'soil': 'Tierra suelta y rica en materia orgánica',
      },
      'sowing_season': 'Otoño a primavera',
      'harvest_time': '30 a 60 días',
      'benefits': 'Baja en calorías, rica en fibra, vitamina A y K.',
      'curious_facts':
          'Existen variedades de hoja suelta, romana y tipo iceberg.',
    },
    'zanahoria': {
      'name': 'Zanahoria',
      'scientific_name': 'Daucus carota',
      'description':
          'Raíz comestible de color naranja. Necesita suelo profundo y suelto '
          'para desarrollarse bien.',
      'care': {
        'watering': 'Riego regular y uniforme',
        'light': 'Sol directo',
        'temperature': '15 °C a 24 °C',
        'soil': 'Suelo profundo, suelto y sin piedras',
      },
      'sowing_season': 'Otoño e invierno',
      'harvest_time': '70 a 90 días',
      'benefits': 'Gran fuente de betacaroteno (vitamina A) y fibra.',
      'curious_facts':
          'Originalmente existían zanahorias moradas y amarillas.',
    },
    'menta': {
      'name': 'Menta',
      'scientific_name': 'Mentha spicata',
      'description':
          'Hierba aromática invasiva y muy resistente. Se puede cultivar en '
          'maceta para controlar su crecimiento.',
      'care': {
        'watering': 'Riego frecuente, suelo húmedo',
        'light': 'Semisombra o sol suave',
        'temperature': '15 °C a 25 °C',
        'soil': 'Suelo fresco y rico en nutrientes',
      },
      'sowing_season': 'Primavera',
      'harvest_time': '60 a 90 días',
      'benefits': 'Su aroma ayuda a la digestión y refresca el aliento.',
      'curious_facts':
          'Se propaga por estolones y puede ocupar todo el espacio.',
    },
    'cilantro': {
      'name': 'Cilantro',
      'scientific_name': 'Coriandrum sativum',
      'description':
          'Hierba de crecimiento rápido muy usada en la cocina mexicana. '
          'Se puede sembrar durante todo el año.',
      'care': {
        'watering': 'Riego ligero y constante',
        'light': 'Semisombra',
        'temperature': '15 °C a 25 °C',
        'soil': 'Suelo suelto y húmedo',
      },
      'sowing_season': 'Todo el año',
      'harvest_time': '40 a 55 días',
      'benefits': 'Aporta vitamina K y propiedades digestivas.',
      'curious_facts': 'Sus semillas se usan como especia (coriandro).',
    },
    'fresa': {
      'name': 'Fresa',
      'scientific_name': 'Fragaria x ananassa',
      'description':
          'Planta rastrera que produce frutos rojos aromáticos. Funciona bien '
          'en macetas colgantes o huertos verticales.',
      'care': {
        'watering': 'Riego frecuente sin encharcar',
        'light': 'Sol directo',
        'temperature': '15 °C a 25 °C',
        'soil': 'Tierra rica en materia orgánica y bien drenada',
      },
      'sowing_season': 'Otoño a primavera',
      'harvest_time': '90 a 120 días',
      'benefits': 'Rica en vitamina C y antioxidantes.',
      'curious_facts': 'Los "puntos" de la fresa en realidad son sus frutos.',
    },
    'espinaca': {
      'name': 'Espinaca',
      'scientific_name': 'Spinacia oleracea',
      'description':
          'Hortaliza de hoja verde muy nutritiva. Prefiere climas frescos.',
      'care': {
        'watering': 'Riego constante, sin encharcar',
        'light': 'Sol suave o semisombra',
        'temperature': '10 °C a 20 °C',
        'soil': 'Suelo fértil y bien drenado',
      },
      'sowing_season': 'Otoño e invierno',
      'harvest_time': '40 a 50 días',
      'benefits': 'Alta en hierro, calcio y vitamina A.',
      'curious_facts': 'Contiene más hierro que muchas carnes por porción.',
    },
    'pepino': {
      'name': 'Pepino',
      'scientific_name': 'Cucumis sativus',
      'description':
          'Planta trepadora de fruto refrescante. Se puede guiar con tutores '
          'para ahorrar espacio.',
      'care': {
        'watering': 'Riego frecuente y abundante',
        'light': 'Sol directo',
        'temperature': '20 °C a 30 °C',
        'soil': 'Suelo suelto rico en materia orgánica',
      },
      'sowing_season': 'Primavera y verano',
      'harvest_time': '50 a 70 días',
      'benefits': 'Muy hidratante (95% agua) y bajo en calorías.',
      'curious_facts': 'Sus flores son comestibles y la planta es trepadora.',
    },
    'pimiento': {
      'name': 'Pimiento',
      'scientific_name': 'Capsicum annuum',
      'description':
          'Hortaliza de fruto con alto contenido de vitamina C. Existen '
          'variedades dulces y picantes.',
      'care': {
        'watering': 'Riego moderado y regular',
        'light': 'Sol directo',
        'temperature': '20 °C a 28 °C',
        'soil': 'Tierra fértil y bien drenada',
      },
      'sowing_season': 'Primavera',
      'harvest_time': '70 a 90 días',
      'benefits': 'Contiene más vitamina C que la naranja.',
      'curious_facts': 'El picor proviene de la capsaicina, no del sabor.',
    },
    'romero': {
      'name': 'Romero',
      'scientific_name': 'Salvia rosmarinus',
      'description':
          'Hierba aromática perenne resistente a la sequía, ideal para '
          'principiantes.',
      'care': {
        'watering': 'Riego escaso',
        'light': 'Sol directo',
        'temperature': '10 °C a 30 °C',
        'soil': 'Suelo seco y bien drenado',
      },
      'sowing_season': 'Primavera',
      'harvest_time': 'Perenne (cosecha continua)',
      'benefits': 'Aromatizante natural y con propiedades antioxidantes.',
      'curious_facts': 'Puede vivir muchos años como arbusto aromático.',
    },
    'perejil': {
      'name': 'Perejil',
      'scientific_name': 'Petroselinum crispum',
      'description':
          'Hierba bienal de hoja muy usada para condimentar alimentos.',
      'care': {
        'watering': 'Riego frecuente',
        'light': 'Semisombra',
        'temperature': '15 °C a 25 °C',
        'soil': 'Suelo húmedo y fértil',
      },
      'sowing_season': 'Primavera',
      'harvest_time': '70 a 90 días',
      'benefits': 'Rico en vitamina C, hierro y antioxidantes.',
      'curious_facts':
          'Es una de las hierbas más usadas en la gastronomía mundial.',
    },
  };

  /// Alias (nombres en ingles o variantes) que apuntan a un slug del catalogo.
  static const Map<String, String> _aliases = {
    'tomato': 'tomate',
    'basil': 'albahaca',
    'basilico': 'albahaca',
    'aloe_vera': 'aloe',
    'aloe-vera': 'aloe',
    'lettuce': 'lechuga',
    'carrot': 'zanahoria',
    'mint': 'menta',
    'coriander': 'cilantro',
    'strawberry': 'fresa',
    'spinach': 'espinaca',
    'pepper': 'pimiento',
    'chile': 'pimiento',
    'cucumber': 'pepino',
    'pepino': 'pepino',
    'rosemary': 'romero',
    'parsley': 'perejil',
  };

  /// Devuelve la lista de slugs disponibles en el catalogo local.
  static List<String> get availableSlugs => _catalog.keys.toList();

  /// Traduce el contenido de un codigo QR a un slug de planta.
  /// Devuelve [null] si el codigo no parece identificar una planta.
  static String? slugFromCode(String raw) {
    final code = raw.trim();
    if (code.isEmpty) return null;

    // Formato de enlace: huerto://planta/tomate
    final uri = Uri.tryParse(code);
    if (uri != null && uri.scheme == 'huerto') {
      final segments = <String>[
        if (uri.host.isNotEmpty && uri.host != 'planta') uri.host,
        ...uri.pathSegments,
      ];
      for (final segment in segments) {
        final slug = _normalize(segment);
        if (slug.isNotEmpty) return slug;
      }
    }

    final upper = code.toUpperCase();
    for (final prefix in const ['PLANT-', 'PLANTA-']) {
      if (upper.startsWith(prefix)) {
        var token = code.substring(prefix.length).trim();
        token = token.replaceFirst(RegExp(r'[-_ ]?\d+$'), '');
        final slug = _normalize(token);
        if (slug.isNotEmpty) return slug;
      }
    }

    return null;
  }

  /// Devuelve la informacion local de una planta o [null] si no existe.
  static PlantModel? localInfo(String slug) {
    final entry = _catalog[slug];
    if (entry == null) return null;
    return PlantModel.fromJson(entry, entry['name'] as String? ?? slug);
  }

  /// Resuelve la informacion de una planta: catalogo local, luego los APIs de
  /// Trefle y Perenual (cualquier planta) y finalmente datos de respaldo.
  /// Siempre devuelve un [PlantModel].
  static Future<PlantModel> resolve(String code) async {
    final slug = slugFromCode(code);
    if (slug != null) {
      final local = localInfo(slug);
      if (local != null) return local;
    }

    final query = _searchQuery(code, slug);

    final treflePlant = await TrefleService.resolve(query);
    final perenualPlant = await PerenualService.resolve(query);

    final merged = _merge(treflePlant, perenualPlant);
    if (merged != null) return merged;

    return PlantModel.fallback(_prettyName(query));
  }

  /// Combina dos resultados: Trefle aporta taxonomia/descripcion y Perenual
  /// los datos de cuidado que falten.
  static PlantModel? _merge(PlantModel? a, PlantModel? b) {
    if (a == null && b == null) return null;
    final trefle = a;
    final perenual = b;

    return PlantModel(
      name: _pick(trefle?.name, perenual?.name, 'Planta'),
      scientificName:
          _pick(trefle?.scientificName, perenual?.scientificName, 'No disponible'),
      description: _pick(
        trefle?.description,
        perenual?.description,
        'Sin descripción disponible.',
      ),
      care: CareInfo(
        watering: _pick(
          trefle?.care.watering,
          perenual?.care.watering,
          'No disponible',
        ),
        light: _pick(trefle?.care.light, perenual?.care.light, 'No disponible'),
        temperature: _pick(
          trefle?.care.temperature,
          perenual?.care.temperature,
          'No disponible',
        ),
        soil: _pick(trefle?.care.soil, perenual?.care.soil, 'No disponible'),
      ),
      sowingSeason: _pick(
        trefle?.sowingSeason,
        perenual?.sowingSeason,
        'No disponible',
      ),
      harvestTime: _pick(
        trefle?.harvestTime,
        perenual?.harvestTime,
        'No disponible',
      ),
      benefits: _pick(
        trefle?.benefits,
        perenual?.benefits,
        'Información no disponible',
      ),
      curiousFacts: _pick(
        trefle?.curiousFacts,
        perenual?.curiousFacts,
        'Datos no disponibles',
      ),
    );
  }

  static const Set<String> _missingMarkers = {
    '',
    'No disponible',
    'Sin descripción disponible.',
    'Información no disponible',
    'Sin datos curiosos',
    'Datos no disponibles',
    'Datos taxonómicos no disponibles',
    'Consultar especialista',
    'Consultar guía local',
    'Variable según condiciones',
  };

  static String _pick(String? primary, String? secondary, String fallback) {
    final p = primary?.trim() ?? '';
    final s = secondary?.trim() ?? '';
    if (!_missingMarkers.contains(p)) return p;
    if (!_missingMarkers.contains(s)) return s;
    return fallback;
  }

  /// Construye un texto de busqueda legible a partir del codigo QR.
  static String _searchQuery(String code, String? slug) {
    if (slug != null && slug.isNotEmpty) {
      return slug.replaceAll('_', ' ').replaceAll('-', ' ').trim();
    }
    return code.trim();
  }

  static String _normalize(String value) {
    var text = value.trim().toLowerCase();
    text = text.replaceAll(RegExp(r'[áàäâ]'), 'a');
    text = text.replaceAll(RegExp(r'[éèëê]'), 'e');
    text = text.replaceAll(RegExp(r'[íìïî]'), 'i');
    text = text.replaceAll(RegExp(r'[óòöô]'), 'o');
    text = text.replaceAll(RegExp(r'[úùüû]'), 'u');
    text = text.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    text = text.replaceAll(RegExp(r'^_+|_+$'), '');
    return _aliases[text] ?? text;
  }

  static String _prettyName(String slug) {
    if (slug.isEmpty) return 'Planta';
    final words = slug.split(RegExp(r'[_\-\s]+')).where((w) => w.isNotEmpty);
    return words
        .map((w) => w.length == 1
            ? w.toUpperCase()
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
