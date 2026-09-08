import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class PlantApiService {
  // Reemplaza con la URL real de la API
  static const String baseUrl = 'https://api.openai.com/v1'; // Ejemplo
  final String apiKey;
  
  PlantApiService({required this.apiKey});
  
  // Método para obtener información de plantas
  Future<Map<String, dynamic>> getPlantInfo(String plantName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'Eres un experto en jardinería y plantas.'
            },
            {
              'role': 'user',
              'content': '''
                Proporciona información detallada sobre la planta: $plantName.
                
                Incluye:
                1. Nombre común y científico
                2. Descripción general
                3. Cuidados necesarios (riego, luz, temperatura)
                4. Época de siembra
                5. Tiempo de cosecha
                6. Beneficios
                7. Datos curiosos
                
                Formato: JSON estructurado
              '''
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parsePlantData(data, plantName);
      } else {
        throw Exception('Error en API: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener información: $e');
      }
      return _getFallbackData(plantName);
    }
  }
  
  // Parsear respuesta de la API
  Map<String, dynamic> _parsePlantData(dynamic data, String plantName) {
    try {
      final content = data['choices'][0]['message']['content'];
      // Intenta parsear como JSON
      try {
        return jsonDecode(content);
      } catch (e) {
        // Si no es JSON, devuelve estructura con texto plano
        return {
          'name': plantName,
          'description': content,
          'care': 'Información obtenida de la API',
          'sowing_season': 'Consultar especialista',
          'harvest_time': 'Variable según condiciones',
          'benefits': 'Información disponible',
          'curious_facts': 'Consultar más fuentes',
        };
      }
    } catch (e) {
      return _getFallbackData(plantName);
    }
  }
  
  // Datos de respaldo en caso de error
  Map<String, dynamic> _getFallbackData(String plantName) {
    return {
      'name': plantName,
      'scientific_name': 'Información no disponible',
      'description': 'No se pudo obtener información de la API. Verifica tu conexión a internet y la clave API.',
      'care': {
        'watering': 'Consultar guía de cultivo',
        'light': 'Requiere investigación',
        'temperature': 'Varía según especie',
        'soil': 'Tierra fértil recomendada',
      },
      'sowing_season': 'Consultar calendario de siembra local',
      'harvest_time': 'Variable según condiciones',
      'benefits': 'Información en proceso de carga',
      'curious_facts': 'Datos disponibles próximamente',
      'error': true,
    };
  }
  
  // Método para buscar plantas por nombre (simulado)
  Future<List<String>> searchPlants(String query) async {
    // Simula búsqueda de plantas
    await Future.delayed(const Duration(milliseconds: 500));
    
    final List<String> commonPlants = [
      'Tomate', 'Lechuga', 'Zanahoria', 'Albahaca', 'Cilantro',
      'Perejil', 'Romero', 'Menta', 'Fresa', 'Espinaca',
      'Brócoli', 'Coliflor', 'Pimiento', 'Cebolla', 'Ajo'
    ];
    
    return commonPlants
        .where((plant) => plant.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}