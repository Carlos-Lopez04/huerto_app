class PlantModel {
  final String name;
  final String scientificName;
  final String description;
  final CareInfo care;
  final String sowingSeason;
  final String harvestTime;
  final String benefits;
  final String curiousFacts;
  final bool hasError;
  
  PlantModel({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.care,
    required this.sowingSeason,
    required this.harvestTime,
    required this.benefits,
    required this.curiousFacts,
    this.hasError = false,
  });
  
  factory PlantModel.fromJson(Map<String, dynamic> json, String plantName) {
    return PlantModel(
      name: json['name'] ?? plantName,
      scientificName: json['scientific_name'] ?? 'No disponible',
      description: json['description'] ?? 'Sin descripción disponible',
      care: CareInfo.fromJson(json['care'] ?? {}),
      sowingSeason: json['sowing_season'] ?? 'Consultar especialista',
      harvestTime: json['harvest_time'] ?? 'Variable según condiciones',
      benefits: json['benefits'] ?? 'Información no disponible',
      curiousFacts: json['curious_facts'] ?? 'Sin datos curiosos',
      hasError: json['error'] ?? false,
    );
  }
  
  factory PlantModel.fallback(String plantName) {
    return PlantModel(
      name: plantName,
      scientificName: 'Información no disponible',
      description: 'No se pudo cargar la información. Verifica tu conexión a internet.',
      care: CareInfo.fallback(),
      sowingSeason: 'Consultar guía local',
      harvestTime: 'Variable',
      benefits: 'Información pendiente',
      curiousFacts: 'Datos no disponibles',
      hasError: true,
    );
  }
}

class CareInfo {
  final String watering;
  final String light;
  final String temperature;
  final String soil;
  
  CareInfo({
    required this.watering,
    required this.light,
    required this.temperature,
    required this.soil,
  });
  
  factory CareInfo.fromJson(Map<String, dynamic> json) {
    return CareInfo(
      watering: json['watering'] ?? 'Riego moderado',
      light: json['light'] ?? 'Luz solar indirecta',
      temperature: json['temperature'] ?? 'Temperatura ambiente',
      soil: json['soil'] ?? 'Tierra fértil con buen drenaje',
    );
  }
  
  factory CareInfo.fallback() {
    return CareInfo(
      watering: 'Consultar guía de cultivo',
      light: 'Requiere investigación',
      temperature: 'Varía según especie',
      soil: 'Tierra fértil recomendada',
    );
  }
}