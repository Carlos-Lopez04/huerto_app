class ApiConfig {
  // No hardcodees la key aquí en producción
  // Esta es una práctica insegura
  static const String apiKey = 'tu_api_key_aqui';
  
  // Para producción, usa:
  // static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
}