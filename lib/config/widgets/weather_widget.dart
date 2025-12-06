// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class WeatherWidget extends StatefulWidget {
//   const WeatherWidget({super.key});

//   @override
//   State<WeatherWidget> createState() => _WeatherWidgetState();
// }

// class _WeatherWidgetState extends State<WeatherWidget> {
//   Map<String, dynamic>? weatherData;
//   String error = '';
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _getWeather();
//   }

//   Future<void> _getWeather() async {
//     const String apiKey = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&units=metric&lang=es&appid=$apiKey'; // REEMPLAZA CON TU API KEY
//     // Coordenadas de Lima, Perú
//     const double lat = -12.0464;
//     const double lon = -77.0428;
    
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&units=metric&lang=es&appid=$apiKey')
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           weatherData = json.decode(response.body);
//           isLoading = false;
//           error = '';
//         });
//       } else {
//         setState(() {
//           error = 'Error ${response.statusCode}: ${response.body}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Error de conexión: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) return _buildLoading();
//     if (error.isNotEmpty) return _buildError();
//     return _buildWeatherCard();
//   }

//   Widget _buildLoading() {
//     return const Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Cargando clima...'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildError() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Icon(Icons.cloud_off, color: Colors.orange, size: 40),
//             const SizedBox(height: 8),
//             const Text('Clima no disponible', 
//                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Text('Lima, Perú', style: TextStyle(color: Colors.grey[600])),
//             const SizedBox(height: 8),
//             Text('25°C', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Text('Soleado', style: TextStyle(color: Colors.grey[600])),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeatherCard() {
//     final current = weatherData?['current'];
//     final daily = weatherData?['daily']?[0];
    
//     final temp = current?['temp']?.round() ?? '--';
//     final feelsLike = current?['feels_like']?.round() ?? '--';
//     final humidity = current?['humidity'] ?? '--';
//     final description = current?['weather']?[0]?['description'] ?? '--';
//     final tempMax = daily?['temp']?['max']?.round() ?? '--';
//     final tempMin = daily?['temp']?['min']?.round() ?? '--';
//     final windSpeed = current?['wind_speed'] ?? '--';

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.location_on, size: 16, color: Colors.green),
//                 const SizedBox(width: 4),
//                 Text('Lima, Perú', 
//                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[800])),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text('$temp°C', 
//                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Text(
//               _capitalizeDescription(description),
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildWeatherInfo(Icons.arrow_upward, 'Máx', '$tempMax°C'),
//                 _buildWeatherInfo(Icons.arrow_downward, 'Mín', '$tempMin°C'),
//                 _buildWeatherInfo(Icons.water_drop, 'Humedad', '$humidity%'),
//                 _buildWeatherInfo(Icons.air, 'Viento', '${windSpeed}m/s'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeatherInfo(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, size: 18, color: Colors.green),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//         Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   String _capitalizeDescription(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1);
//   }
// }