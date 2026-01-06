// screens/avatar_customizer_screen.dart
import 'package:flutter/material.dart';
import 'package:huerto_app/models/avatar_model.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/config/widgets/avatar_widget.dart';

class AvatarCustomizerScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onAvatarUpdated;

  const AvatarCustomizerScreen({
    super.key,
    required this.user,
    required this.onAvatarUpdated,
  });

  @override
  State<AvatarCustomizerScreen> createState() => _AvatarCustomizerScreenState();
}

class _AvatarCustomizerScreenState extends State<AvatarCustomizerScreen> {
  late AvatarModel _currentAvatar;

  // Opciones de personalización
  final List<Map<String, dynamic>> _skinTones = [
    {
      'color': const Color(0xFFFFF3E0),
      'name': 'Muy Claro',
      'value': 0.8,
    },
    {
      'color': const Color(0xFFFFDBAC),
      'name': 'Claro',
      'value': 1.0,
    },
    {
      'color': const Color(0xFFD8A871),
      'name': 'Medio',
      'value': 1.2,
    },
    {
      'color': const Color(0xFFA1663C),
      'name': 'Oscuro',
      'value': 1.4,
    },
    {
      'color': const Color(0xFF8D5524),
      'name': 'Muy Oscuro',
      'value': 1.6,
    },
  ];

  final List<Map<String, dynamic>> _hairColors = [
    {
      'color': Colors.black,
      'name': 'Negro',
    },
    {
      'color': const Color(0xFF8B4513),
      'name': 'Castaño Oscuro',
    },
    {
      'color': const Color(0xFFA0522D),
      'name': 'Castaño',
    },
    {
      'color': const Color(0xFFD2691E),
      'name': 'Castaño Claro',
    },
    {
      'color': const Color(0xFFCD853F),
      'name': 'Rubio Oscuro',
    },
    {
      'color': const Color(0xFFDAA520),
      'name': 'Rubio',
    },
    {
      'color': const Color(0xFFB8860B),
      'name': 'Cobrizo',
    },
    {
      'color': Colors.blueGrey,
      'name': 'Gris',
    },
  ];

  final List<Map<String, dynamic>> _eyeColors = [
    {
      'color': Colors.brown,
      'name': 'Marrón',
    },
    {
      'color': Colors.blue,
      'name': 'Azul',
    },
    {
      'color': Colors.green,
      'name': 'Verde',
    },
    {
      'color': Colors.grey,
      'name': 'Gris',
    },
    {
      'color': const Color(0xFF8B4513),
      'name': 'Ámbar',
    },
    {
      'color': const Color(0xFF964B00),
      'name': 'Avellana',
    },
  ];

  final List<Map<String, dynamic>> _outfitOptions = [
    {
      'name': 'Semilla',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.eco,
    },
    {
      'name': 'Brote',
      'color': const Color(0xFF2E7D32),
      'icon': Icons.grass,
    },
    {
      'name': 'Árbol',
      'color': const Color(0xFF1B5E20),
      'icon': Icons.park,
    },
    {
      'name': 'Bosque',
      'color': const Color(0xFF004D40),
      'icon': Icons.forest,
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.user.avatar.copyWith(
      outfit: widget.user.rank, // Usar el rango del usuario como outfit inicial
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Personalizar Avatar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _saveAvatar,
            tooltip: 'Guardar cambios',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Vista previa del avatar
            _buildAvatarPreview(),
            const SizedBox(height: 24),

            // Selector de tono de piel
            _buildColorSelector(
              title: 'Tono de Piel',
              colors: _skinTones,
              currentColor: _currentAvatar.skinColor,
              onColorSelected: (color) {
                setState(() {
                  _currentAvatar = _currentAvatar.copyWith(skinColor: color);
                });
              },
            ),
            const SizedBox(height: 16),

            // Selector de color de cabello
            _buildColorSelector(
              title: 'Color de Cabello',
              colors: _hairColors,
              currentColor: _currentAvatar.hairColor,
              onColorSelected: (color) {
                setState(() {
                  _currentAvatar = _currentAvatar.copyWith(hairColor: color);
                });
              },
            ),
            const SizedBox(height: 16),

            // Selector de color de ojos
            _buildColorSelector(
              title: 'Color de Ojos',
              colors: _eyeColors,
              currentColor: _currentAvatar.eyeColor,
              onColorSelected: (color) {
                setState(() {
                  _currentAvatar = _currentAvatar.copyWith(eyeColor: color);
                });
              },
            ),
            const SizedBox(height: 16),

            // Selector de outfit (basado en rango)
            _buildOutfitSelector(),
            const SizedBox(height: 16),

            // Switch para lentes
            _buildGlassesSwitch(),
            const SizedBox(height: 24),

            // Botones de acción
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFF1F8E9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Vista Previa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4CAF50),
                width: 3,
              ),
            ),
            child: AvatarWidget(
              avatar: _currentAvatar,
              size: 150,
              borderColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.face,
                  size: 16,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Text(
                  'Tu avatar personalizado',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca las opciones para personalizar',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector({
    required String title,
    required List<Map<String, dynamic>> colors,
    required Color currentColor,
    required Function(Color) onColorSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((colorData) {
              final color = colorData['color'] as Color;
              final name = colorData['name'] as String;
              final isSelected = color == currentColor;

              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.grey[300]!,
                          width: isSelected ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? const Color(0xFF2E7D32)
                            : Colors.grey[600],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Outfit (Basado en tu rango)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _outfitOptions.map((outfit) {
              final name = outfit['name'] as String;
              final color = outfit['color'] as Color;
              final icon = outfit['icon'] as IconData;
              final isSelected = _currentAvatar.outfit == name;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentAvatar = _currentAvatar.copyWith(outfit: name);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.2) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? color : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu rango actual: ${widget.user.rank}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassesSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _currentAvatar.hasGlasses
                      ? const Color(0xFF2E7D32).withOpacity(0.2)
                      : Colors.grey[200]!,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove_red_eye,
                  color: _currentAvatar.hasGlasses
                      ? const Color(0xFF2E7D32)
                      : Colors.grey[500]!,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usar Lentes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    _currentAvatar.hasGlasses
                        ? 'Lentes activados'
                        : 'Sin lentes',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: _currentAvatar.hasGlasses,
              onChanged: (value) {
                setState(() {
                  _currentAvatar = _currentAvatar.copyWith(hasGlasses: value);
                });
              },
              activeThumbColor: const Color(0xFF2E7D32),
              inactiveTrackColor: Colors.grey[300],
              activeTrackColor: const Color(0xFF4CAF50).withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Botón de reset
        Expanded(
          child: OutlinedButton(
            onPressed: _resetAvatar,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2E7D32), width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restart_alt, size: 20),
                SizedBox(width: 8),
                Text(
                  'Restablecer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Botón de guardar
        Expanded(
          child: ElevatedButton(
            onPressed: _saveAvatar,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF2E7D32).withOpacity(0.3),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 20),
                SizedBox(width: 8),
                Text(
                  'Guardar Avatar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _resetAvatar() {
    setState(() {
      _currentAvatar = AvatarModel(
        skinColor: const Color(0xFFFFDBAC),
        hairColor: Colors.black,
        eyeColor: Colors.brown,
        hasGlasses: false,
        outfit: widget.user.rank,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF4CAF50),
        content: Text(
          'Avatar restablecido a valores por defecto',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveAvatar() {
    final updatedUser = widget.user.copyWith(avatar: _currentAvatar);
    widget.onAvatarUpdated(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2E7D32),
        content: const Row(
          children: [
            Icon(Icons.check, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Avatar guardado exitosamente',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    Navigator.pop(context);
  }
}
