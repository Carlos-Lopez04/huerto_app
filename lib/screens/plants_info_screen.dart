import 'package:flutter/material.dart';
import 'package:huerto_app/services/plant_api_service.dart';
import 'package:huerto_app/models/plant_model.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlantInfoScreen extends StatefulWidget {
  const PlantInfoScreen({super.key});

  @override
  State<PlantInfoScreen> createState() => _PlantInfoScreenState();
}

class _PlantInfoScreenState extends State<PlantInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PlantApiService _apiService = PlantApiService(
    apiKey: dotenv.env['API_KEY'] ?? '', // Cargar desde .env
  );
  
  bool _isLoading = false;
  PlantModel? _plantInfo;
  String? _errorMessage;
  List<String> _searchSuggestions = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPlant() async {
    final plantName = _searchController.text.trim();
    if (plantName.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _plantInfo = null;
    });
    
    try {
      final data = await _apiService.getPlantInfo(plantName);
      setState(() {
        _plantInfo = PlantModel.fromJson(data, plantName);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al buscar la planta: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.length >= 2) {
      final suggestions = await _apiService.searchPlants(query);
      setState(() {
        _searchSuggestions = suggestions;
      });
    } else {
      setState(() {
        _searchSuggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Plantas'),
        backgroundColor: forestDepth,
        foregroundColor: blancoHueso,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          _buildSearchBar(),
          
          // Contenido principal
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: forestDepth,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onSubmitted: (_) => _searchPlant(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar planta (ej: Tomate, Lechuga...)',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchSuggestions = [];
                                _plantInfo = null;
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _searchPlant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldenSun,
                  foregroundColor: forestDepth,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Buscar'),
              ),
            ],
          ),
          // Sugerencias de búsqueda
          if (_searchSuggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _searchSuggestions.map((suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      _searchController.text = suggestion;
                      _searchSuggestions = [];
                      _searchPlant();
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Consultando información...'),
          ],
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _searchPlant,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_plantInfo != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            _buildHeader(),
            const SizedBox(height: 24),
            
            // Descripción
            _buildSection(
              title: '📝 Descripción',
              icon: Icons.description,
              content: _plantInfo!.description,
            ),
            const SizedBox(height: 20),
            
            // Cuidados
            _buildCareSection(),
            const SizedBox(height: 20),
            
            // Información adicional
            _buildInfoGrid(),
            const SizedBox(height: 20),
            
            // Beneficios y datos curiosos
            _buildBenefitsSection(),
            const SizedBox(height: 20),
            
            if (_plantInfo!.hasError)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nota: Se están mostrando datos de respaldo. Verifica tu conexión a internet.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.grass, size: 80, color: forestDepth.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'Busca una planta para obtener información',
            style: AppFont.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ejemplos: Tomate, Lechuga, Albahaca, Zanahoria',
            style: AppFont.bodySmall.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [forestDepth, emeraldLeaf],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _plantInfo!.name,
            style: AppFont.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _plantInfo!.scientificName,
            style: AppFont.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: forestDepth),
            const SizedBox(width: 8),
            Text(title, style: AppFont.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: verdeGelido,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(content, style: AppFont.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildCareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.spa, size: 24, color: forestDepth),
            SizedBox(width: 8),
            Text('🌱 Cuidados', style: AppFont.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: verdeGelido,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildCareRow(Icons.water_drop, 'Riego', _plantInfo!.care.watering),
              const Divider(),
              _buildCareRow(Icons.wb_sunny, 'Luz', _plantInfo!.care.light),
              const Divider(),
              _buildCareRow(Icons.thermostat, 'Temperatura', _plantInfo!.care.temperature),
              const Divider(),
              _buildCareRow(Icons.landscape, 'Suelo', _plantInfo!.care.soil),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCareRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: forestDepth),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppFont.bodySmall.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: AppFont.bodySmall)),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.info, size: 24, color: forestDepth),
            SizedBox(width: 8),
            Text('📋 Información Adicional', style: AppFont.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
          children: [
            _buildInfoCard(
              '🌱 Siembra',
              _plantInfo!.sowingSeason,
              Icons.calendar_today,
            ),
            _buildInfoCard(
              '⏰ Cosecha',
              _plantInfo!.harvestTime,
              Icons.timer,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: verdeGelido,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: forestDepth),
              const SizedBox(width: 4),
              Text(title, style: AppFont.bodySmall.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: AppFont.bodySmall),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: '✨ Beneficios',
          icon: Icons.emoji_events,
          content: _plantInfo!.benefits,
        ),
        const SizedBox(height: 16),
        _buildSection(
          title: '📚 Datos Curiosos',
          icon: Icons.lightbulb,
          content: _plantInfo!.curiousFacts,
        ),
      ],
    );
  }
}