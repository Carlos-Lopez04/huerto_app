import 'package:flutter_test/flutter_test.dart';
import 'package:huerto_app/services/plant_repository.dart';

void main() {
  group('PlantRepository.slugFromCode', () {
    test('reconoce codigos PLANT- con id numerico', () {
      expect(PlantRepository.slugFromCode('PLANT-TOMATO-001'), 'tomate');
      expect(PlantRepository.slugFromCode('PLANT-BASIL-002'), 'albahaca');
      expect(PlantRepository.slugFromCode('PLANT-ALOE-003'), 'aloe');
    });

    test('reconoce nombres en espanol y sin id', () {
      expect(PlantRepository.slugFromCode('PLANT-LECHUGA'), 'lechuga');
      expect(PlantRepository.slugFromCode('PLANTA-ZANAHORIA-12'), 'zanahoria');
    });

    test('reconoce el formato de enlace huerto://', () {
      expect(PlantRepository.slugFromCode('huerto://planta/tomate'), 'tomate');
    });

    test('devuelve null para codigos que no son de plantas', () {
      expect(PlantRepository.slugFromCode('https://www.fca.uabc.mx'), isNull);
      expect(PlantRepository.slugFromCode('REWARD-100-POINTS'), isNull);
      expect(PlantRepository.slugFromCode('HUERTO-LOGIN-3'), isNull);
      expect(PlantRepository.slugFromCode('ACT-WATER-001'), isNull);
    });
  });

  group('PlantRepository.localInfo', () {
    test('devuelve informacion clave de la planta', () {
      final tomate = PlantRepository.localInfo('tomate');
      expect(tomate, isNotNull);
      expect(tomate!.name, 'Tomate');
      expect(tomate.care.watering, isNotEmpty);
      expect(tomate.sowingSeason, isNotEmpty);
      expect(tomate.harvestTime, isNotEmpty);
      expect(tomate.hasError, isFalse);
    });

    test('devuelve null para plantas desconocidas', () {
      expect(PlantRepository.localInfo('planta-inexistente'), isNull);
    });
  });

  test('todas las plantas del catalogo resuelven sin error', () {
    for (final slug in PlantRepository.availableSlugs) {
      final plant = PlantRepository.localInfo(slug);
      expect(plant, isNotNull, reason: 'Falta informacion para $slug');
      expect(plant!.name, isNotEmpty);
    }
  });
}
