// screens/avatar_customizer_screen.dart
import 'package:flutter/material.dart';
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
  late UserModel _currentUser;

  // Opciones de personalización mejoradas
  final List<Map<String, dynamic>> _skinTones = [
    {
      'color': const Color(0xFFFFF3E0),
      'name': 'Muy Claro',
      'description': 'Tono de piel muy claro',
      'default': false,
    },
    {
      'color': const Color(0xFFFFDBAC),
      'name': 'Claro',
      'description': 'Tono de piel claro',
      'default': false,
    },
    {
      'color': UserModel.defaultSkinColor, // Valor por defecto
      'name': 'Natural',
      'description': 'Tono de piel natural',
      'default': true,
    },
    {
      'color': const Color(0xFFD8A871),
      'name': 'Medio',
      'description': 'Tono de piel medio',
      'default': false,
    },
    {
      'color': const Color(0xFFA1663C),
      'name': 'Oscuro',
      'description': 'Tono de piel oscuro',
      'default': false,
    },
    {
      'color': const Color(0xFF8D5524),
      'name': 'Muy Oscuro',
      'description': 'Tono de piel muy oscuro',
      'default': false,
    },
  ];

  final List<Map<String, dynamic>> _hairColors = [
    {
      'color': Colors.black,
      'name': 'Negro',
      'description': 'Cabello negro',
      'default': false,
    },
    {
      'color': UserModel.defaultHairColor, // Valor por defecto
      'name': 'Castaño Oscuro',
      'description': 'Cabello castaño oscuro',
      'default': true,
    },
    {
      'color': const Color(0xFF8B4513),
      'name': 'Castaño',
      'description': 'Cabello castaño',
      'default': false,
    },
    {
      'color': const Color(0xFFD2691E),
      'name': 'Castaño Claro',
      'description': 'Cabello castaño claro',
      'default': false,
    },
    {
      'color': const Color(0xFFCD853F),
      'name': 'Rubio Oscuro',
      'description': 'Cabello rubio oscuro',
      'default': false,
    },
    {
      'color': const Color(0xFFDAA520),
      'name': 'Rubio',
      'description': 'Cabello rubio',
      'default': false,
    },
    {
      'color': const Color(0xFFB8860B),
      'name': 'Cobrizo',
      'description': 'Cabello cobrizo',
      'default': false,
    },
    {
      'color': Colors.blueGrey,
      'name': 'Gris',
      'description': 'Cabello gris',
      'default': false,
    },
  ];

  final List<Map<String, dynamic>> _eyeColors = [
    {
      'color': Colors.brown,
      'name': 'Marrón',
      'description': 'Ojos marrones',
      'default': false,
    },
    {
      'color': UserModel.defaultEyeColor, // Valor por defecto
      'name': 'Verde',
      'description': 'Ojos verdes',
      'default': true,
    },
    {
      'color': Colors.blue,
      'name': 'Azul',
      'description': 'Ojos azules',
      'default': false,
    },
    {
      'color': Colors.grey,
      'name': 'Gris',
      'description': 'Ojos grises',
      'default': false,
    },
    {
      'color': const Color(0xFF8B4513),
      'name': 'Ámbar',
      'description': 'Ojos ámbar',
      'default': false,
    },
    {
      'color': const Color(0xFF964B00),
      'name': 'Avellana',
      'description': 'Ojos color avellana',
      'default': false,
    },
  ];

  // Estilos de lentes
  final List<Map<String, dynamic>> _glassesStyles = [
    {
      'name': 'Sin lentes',
      'hasGlasses': UserModel.defaultHasGlasses,
      'icon': Icons.visibility,
      'color': Colors.grey,
      'description': 'No usar lentes',
      'default': true,
    },
    {
      'name': 'Con lentes',
      'hasGlasses': true,
      'icon': Icons.visibility_off,
      'color': Colors.blueGrey,
      'description': 'Usar lentes',
      'default': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Crear tu Avatar',
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
            tooltip: 'Guardar avatar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vista previa del avatar
            _buildAvatarPreview(),
            const SizedBox(height: 24),

            // Instrucciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Personaliza cada aspecto de tu avatar:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selector de género
            _buildSectionTitle('1. Selecciona tu género'),
            _buildGenderSelector(),
            const SizedBox(height: 20),

            // Selector de tono de piel
            _buildSectionTitle('2. Elige tu tono de piel'),
            _buildColorSelector(
              title: 'Tono de Piel',
              colors: _skinTones,
              currentColor: _currentUser.skinColor,
              onColorSelected: (color) {
                setState(() {
                  _currentUser = _currentUser.copyWith(skinColor: color);
                });
              },
            ),
            const SizedBox(height: 20),

            // Selector de color de cabello
            _buildSectionTitle('3. Elige color de cabello'),
            _buildColorSelector(
              title: 'Color de Cabello',
              colors: _hairColors,
              currentColor: _currentUser.hairColor,
              onColorSelected: (color) {
                setState(() {
                  _currentUser = _currentUser.copyWith(hairColor: color);
                });
              },
            ),
            const SizedBox(height: 20),

            // Selector de color de ojos
            _buildSectionTitle('4. Elige color de ojos'),
            _buildColorSelector(
              title: 'Color de Ojos',
              colors: _eyeColors,
              currentColor: _currentUser.eyeColor,
              onColorSelected: (color) {
                setState(() {
                  _currentUser = _currentUser.copyWith(eyeColor: color);
                });
              },
            ),
            const SizedBox(height: 20),

            // Selector de lentes
            _buildSectionTitle('5. ¿Usas lentes?'),
            _buildGlassesSelector(),
            const SizedBox(height: 30),

            // Botones de acción
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            'Tu Avatar Personalizado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // Avatar con efectos
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4CAF50),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AvatarWidget(
              user: _currentUser,
              size: 150,
              borderColor: Colors.transparent,
              showBorder: false,
              showEffects: true,
            ),
          ),

          const SizedBox(height: 16),

          // Detalles del avatar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                _buildAvatarDetail(
                    'Género',
                    _currentUser.gender == UserGender.femenino
                        ? 'Femenino'
                        : 'Masculino'),

                if (_currentUser.hasCustomSkinColor)
                  _buildAvatarDetail('Tono de piel',
                      _getColorName(_currentUser.skinColor, _skinTones)),

                if (_currentUser.hasCustomHairColor)
                  _buildAvatarDetail('Color de cabello',
                      _getColorName(_currentUser.hairColor, _hairColors)),

                if (_currentUser.hasCustomEyeColor)
                  _buildAvatarDetail('Color de ojos',
                      _getColorName(_currentUser.eyeColor, _eyeColors)),

                if (_currentUser.hasGlasses) _buildAvatarDetail('Lentes', 'Sí'),

                // Resumen de personalización
                if (_currentUser.isAvatarCustomized)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Avatar personalizado',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildGenderOption(
            UserGender.femenino,
            'Femenino',
            Icons.female,
            const Color(0xFFEC407A),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          _buildGenderOption(
            UserGender.masculino,
            'Masculino',
            Icons.male,
            const Color(0xFF42A5F5),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    UserGender gender,
    String label,
    IconData icon,
    Color activeColor,
  ) {
    final isSelected = _currentUser.gender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentUser = _currentUser.copyWith(gender: gender);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? activeColor : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? activeColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForColorType(title),
                color: const Color(0xFF1B5E20),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
              final isDefault = colorData['default'] as bool;
              final isSelected = currentColor.value == color.value;

              return _buildColorOption(
                color: color,
                name: name,
                isDefault: isDefault,
                isSelected: isSelected,
                onTap: () => onColorSelected(color),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption({
    required Color color,
    required String name,
    required bool isDefault,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Círculo de color
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            if (isDefault)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Por defecto',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassesSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.visibility,
                color: Color(0xFF1B5E20),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Lentes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _glassesStyles.map((style) {
              final hasGlasses = style['hasGlasses'] as bool;
              final name = style['name'] as String;
              final description = style['description'] as String;
              final icon = style['icon'] as IconData;
              final color = style['color'] as Color;
              final isDefault = style['default'] as bool;
              final isSelected = _currentUser.hasGlasses == hasGlasses;

              return _buildGlassesOption(
                hasGlasses: hasGlasses,
                name: name,
                description: description,
                icon: icon,
                color: color,
                isDefault: isDefault,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _currentUser =
                        _currentUser.copyWith(hasGlasses: hasGlasses);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassesOption({
    required bool hasGlasses,
    required String name,
    required String description,
    required IconData icon,
    required Color color,
    required bool isDefault,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFF4CAF50) : color,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (isDefault)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Por defecto',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botón de guardar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveAvatar,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF1B5E20).withOpacity(0.5),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 24),
                SizedBox(width: 12),
                Text(
                  'Guardar Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Botón de restablecer
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _resetAvatar,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFD32F2F),
              side: const BorderSide(
                color: Color(0xFFD32F2F),
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 24),
                SizedBox(width: 12),
                Text(
                  'Restablecer a Predeterminado',
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

  void _saveAvatar() {
    // Determinar si hay personalizaciones
    final hasCustomSkin = _currentUser.skinColor != UserModel.defaultSkinColor;
    final hasCustomHair = _currentUser.hairColor != UserModel.defaultHairColor;
    final hasCustomEye = _currentUser.eyeColor != UserModel.defaultEyeColor;
    final hasCustomGlass =
        _currentUser.hasGlasses != UserModel.defaultHasGlasses;

    // Verificar si hay alguna personalización
    final hasAnyCustomization =
        hasCustomSkin || hasCustomHair || hasCustomEye || hasCustomGlass;

    // Crear usuario actualizado
    final updatedUser = _currentUser.copyWith(
      // Mantener todos los cambios que ya están en _currentUser
      avatarStyle: hasAnyCustomization ? 'custom' : 'simple',
    );

    // Pasar el usuario actualizado al callback
    widget.onAvatarUpdated(updatedUser);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Avatar ${_currentUser.gender == UserGender.femenino ? 'femenino' : 'masculino'} ${hasAnyCustomization ? 'personalizado' : 'actualizado'}!',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Regresar a la pantalla anterior con el usuario actualizado
    Navigator.pop(context, updatedUser);
  }

  void _resetAvatar() {
    setState(() {
      _currentUser = widget.user.resetAvatar();
    });

    // Mostrar mensaje de restablecimiento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Avatar restablecido a valores predeterminados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Métodos auxiliares
  String _getColorName(Color color, List<Map<String, dynamic>> colorList) {
    final colorData = colorList.firstWhere(
      (item) => (item['color'] as Color).value == color.value,
      orElse: () => {'name': 'Personalizado'},
    );
    return colorData['name'] as String;
  }

  IconData _getIconForColorType(String title) {
    switch (title) {
      case 'Tono de Piel':
        return Icons.face;
      case 'Color de Cabello':
        return Icons.face_retouching_natural;
      case 'Color de Ojos':
        return Icons.remove_red_eye;
      default:
        return Icons.palette;
    }
  }
}
