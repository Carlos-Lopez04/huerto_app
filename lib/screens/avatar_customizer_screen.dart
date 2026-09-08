// screens/avatar_customizer_screen.dart
import 'package:flutter/material.dart'; // Importa el framework de Flutter
import 'package:huerto_app/models/user_model.dart'; // Importa el modelo de usuario
import 'package:huerto_app/config/widgets/avatar_widget.dart'; // Importa widget de avatar

/*
    PANTALLA PERSONALIZADOR DE AVATAR - ESTADO MUTABLE
*/
class AvatarCustomizerScreen extends StatefulWidget {
  final UserModel user; // Usuario actual para personalizar
  final Function(UserModel)
      onAvatarUpdated; // Callback cuando se actualiza el avatar

  const AvatarCustomizerScreen({
    super.key, // Llave opcional para el widget
    required this.user, // Usuario requerido
    required this.onAvatarUpdated, // Callback requerido
  });

  @override
  State<AvatarCustomizerScreen> createState() => _AvatarCustomizerScreenState();
}

/*
    ESTADO DE LA PANTALLA PERSONALIZADOR DE AVATAR
*/
class _AvatarCustomizerScreenState extends State<AvatarCustomizerScreen> {
  late UserModel
      _currentUser; // Usuario actual en edición (se inicializa después)

  /*
      OPCIONES DE TONOS DE PIEL MEJORADOS
  */
  final List<Map<String, dynamic>> _skinTones = [
    {
      'color': const Color(0xFFFFF3E0), // Color muy claro
      'name': 'Muy Claro', // Nombre descriptivo
      'description': 'Tono de piel muy claro', // Descripción
      'default': false, // No es opción por defecto
    },
    {
      'color': const Color(0xFFFFDBAC), // Color claro
      'name': 'Claro',
      'description': 'Tono de piel claro',
      'default': false,
    },
    {
      'color': UserModel.defaultSkinColor, // Usa valor por defecto del modelo
      'name': 'Natural',
      'description': 'Tono de piel natural',
      'default': true, // Esta es la opción por defecto
    },
    {
      'color': const Color(0xFFD8A871), // Color medio
      'name': 'Medio',
      'description': 'Tono de piel medio',
      'default': false,
    },
    {
      'color': const Color(0xFFA1663C), // Color oscuro
      'name': 'Oscuro',
      'description': 'Tono de piel oscuro',
      'default': false,
    },
    {
      'color': const Color(0xFF8D5524), // Color muy oscuro
      'name': 'Muy Oscuro',
      'description': 'Tono de piel muy oscuro',
      'default': false,
    },
  ];

  /*
      OPCIONES DE COLORES DE CABELLO
  */
  final List<Map<String, dynamic>> _hairColors = [
    {
      'color': Colors.black, // Color negro
      'name': 'Negro',
      'description': 'Cabello negro',
      'default': false,
    },
    {
      'color': UserModel.defaultHairColor, // Usa valor por defecto
      'name': 'Castaño Oscuro',
      'description': 'Cabello castaño oscuro',
      'default': true, // Opción por defecto
    },
    {
      'color': const Color(0xFF8B4513), // Color castaño
      'name': 'Castaño',
      'description': 'Cabello castaño',
      'default': false,
    },
    {
      'color': const Color(0xFFD2691E), // Color castaño claro
      'name': 'Castaño Claro',
      'description': 'Cabello castaño claro',
      'default': false,
    },
    {
      'color': const Color(0xFFCD853F), // Color rubio oscuro
      'name': 'Rubio Oscuro',
      'description': 'Cabello rubio oscuro',
      'default': false,
    },
    {
      'color': const Color(0xFFDAA520), // Color rubio
      'name': 'Rubio',
      'description': 'Cabello rubio',
      'default': false,
    },
    {
      'color': const Color(0xFFB8860B), // Color cobrizo
      'name': 'Cobrizo',
      'description': 'Cabello cobrizo',
      'default': false,
    },
    {
      'color': Colors.blueGrey, // Color gris
      'name': 'Gris',
      'description': 'Cabello gris',
      'default': false,
    },
  ];

  /*
      OPCIONES DE COLORES DE OJOS
  */
  final List<Map<String, dynamic>> _eyeColors = [
    {
      'color': Colors.brown, // Color marrón
      'name': 'Marrón',
      'description': 'Ojos marrones',
      'default': false,
    },
    {
      'color': UserModel.defaultEyeColor, // Usa valor por defecto
      'name': 'Verde',
      'description': 'Ojos verdes',
      'default': true, // Opción por defecto
    },
    {
      'color': Colors.blue, // Color azul
      'name': 'Azul',
      'description': 'Ojos azules',
      'default': false,
    },
    {
      'color': Colors.grey, // Color gris
      'name': 'Gris',
      'description': 'Ojos grises',
      'default': false,
    },
    {
      'color': const Color(0xFF8B4513), // Color ámbar
      'name': 'Ámbar',
      'description': 'Ojos ámbar',
      'default': false,
    },
    {
      'color': const Color(0xFF964B00), // Color avellana
      'name': 'Avellana',
      'description': 'Ojos color avellana',
      'default': false,
    },
  ];

  /*
      ESTILOS DE LENTES
  */
  final List<Map<String, dynamic>> _glassesStyles = [
    {
      'name': 'Sin lentes', // Opción sin lentes
      'hasGlasses': UserModel.defaultHasGlasses, // Valor por defecto
      'icon': Icons.visibility, // Icono de visibilidad
      'color': Colors.grey, // Color gris
      'description': 'No usar lentes', // Descripción
      'default': true, // Opción por defecto
    },
    {
      'name': 'Con lentes', // Opción con lentes
      'hasGlasses': true, // Usar lentes
      'icon': Icons.visibility_off, // Icono de visibilidad apagada
      'color': Colors.blueGrey, // Color azul grisáceo
      'description': 'Usar lentes', // Descripción
      'default': false,
    },
  ];

  @override
  void initState() {
    super.initState(); // Llamar al initState del padre
    _currentUser = widget.user; // Inicializar usuario actual con el recibido
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para la pantalla
      appBar: AppBar(
        title: const Text(
          'Crear tu Avatar', // Título de la AppBar
          style: TextStyle(
            color: Colors.white, // Texto blanco
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        backgroundColor: const Color(0xFF1B5E20), // Color verde oscuro
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Icono de regresar
          onPressed: () => Navigator.pop(context), // Regresar al presionar
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check,
                color: Colors.white), // Icono de guardar
            onPressed: _saveAvatar, // Guardar avatar al presionar
            tooltip: 'Guardar avatar', // Texto de ayuda
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Padding en todos los lados
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinear al inicio horizontal
          children: [
            // Vista previa del avatar
            _buildAvatarPreview(), // Widget personalizado para previsualización
            const SizedBox(height: 24), // Espaciador vertical

            // Instrucciones
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8), // Padding horizontal
              child: Text(
                'Personaliza cada aspecto de tu avatar:', // Texto de instrucciones
                style: TextStyle(
                  fontSize: 16, // Tamaño de fuente
                  fontWeight: FontWeight.w500, // Peso de fuente medio
                  color: Colors.grey[700], // Color gris oscuro
                ),
              ),
            ),
            const SizedBox(height: 16), // Espaciador vertical

            // Selector de género
            _buildSectionTitle('1. Selecciona tu género'), // Título de sección
            _buildGenderSelector(), // Widget selector de género
            const SizedBox(height: 20), // Espaciador vertical

            // Selector de tono de piel
            _buildSectionTitle('2. Elige tu tono de piel'), // Título de sección
            _buildColorSelector(
              title: 'Tono de Piel', // Título del selector
              colors: _skinTones, // Lista de colores disponibles
              currentColor: _currentUser.skinColor, // Color actual del usuario
              onColorSelected: (color) {
                // Callback cuando se selecciona color
                setState(() {
                  // Actualizar estado
                  _currentUser = _currentUser.copyWith(
                      skinColor: color); // Actualizar color de piel
                });
              },
            ),
            const SizedBox(height: 20), // Espaciador vertical

            // Selector de color de cabello
            _buildSectionTitle(
                '3. Elige color de cabello'), // Título de sección
            _buildColorSelector(
              title: 'Color de Cabello', // Título del selector
              colors: _hairColors, // Lista de colores disponibles
              currentColor: _currentUser.hairColor, // Color actual del usuario
              onColorSelected: (color) {
                // Callback cuando se selecciona color
                setState(() {
                  // Actualizar estado
                  _currentUser = _currentUser.copyWith(
                      hairColor: color); // Actualizar color de cabello
                });
              },
            ),
            const SizedBox(height: 20), // Espaciador vertical

            // Selector de color de ojos
            _buildSectionTitle('4. Elige color de ojos'), // Título de sección
            _buildColorSelector(
              title: 'Color de Ojos', // Título del selector
              colors: _eyeColors, // Lista de colores disponibles
              currentColor: _currentUser.eyeColor, // Color actual del usuario
              onColorSelected: (color) {
                // Callback cuando se selecciona color
                setState(() {
                  // Actualizar estado
                  _currentUser = _currentUser.copyWith(
                      eyeColor: color); // Actualizar color de ojos
                });
              },
            ),
            const SizedBox(height: 20), // Espaciador vertical

            // Selector de lentes
            _buildSectionTitle('5. ¿Usas lentes?'), // Título de sección
            _buildGlassesSelector(), // Widget selector de lentes
            const SizedBox(height: 30), // Espaciador vertical

            // Botones de acción
            _buildActionButtons(), // Widget de botones de acción
            const SizedBox(height: 40), // Espaciador vertical
          ],
        ),
      ),
    );
  }

  /*
      CONSTRUIR TÍTULO DE SECCIÓN
  */
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4), // Padding específico
      child: Text(
        title, // Texto del título
        style: const TextStyle(
          fontSize: 16, // Tamaño de fuente
          fontWeight: FontWeight.bold, // Negrita
          color: Color(0xFF1B5E20), // Color verde oscuro
        ),
      ),
    );
  }

  /*
      CONSTRUIR VISTA PREVIA DEL AVATAR
  */
  Widget _buildAvatarPreview() {
    return Container(
      padding: const EdgeInsets.all(20), // Padding interno
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          // Gradiente de fondo
          colors: [
            Color(0xFFE8F5E9), // Verde muy claro
            Color(0xFFF1F8E9), // Verde claro
          ],
          begin: Alignment.topLeft, // Inicio en esquina superior izquierda
          end: Alignment.bottomRight, // Fin en esquina inferior derecha
        ),
        borderRadius: BorderRadius.circular(20), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Color de sombra
            blurRadius: 12, // Desenfoque de sombra
            offset: const Offset(0, 4), // Desplazamiento de sombra
          ),
        ],
        border: Border.all(
          // Borde del contenedor
          color: const Color(0xFF2E7D32)
              .withOpacity(0.3), // Color de borde semitransparente
          width: 2, // Grosor del borde
        ),
      ),
      child: Column(
        children: [
          Text(
            'Tu Avatar Personalizado', // Título de la previsualización
            style: TextStyle(
              fontSize: 20, // Tamaño de fuente grande
              fontWeight: FontWeight.bold, // Negrita
              color: Colors.grey[800], // Color gris muy oscuro
            ),
          ),
          const SizedBox(height: 16), // Espaciador vertical

          // Avatar con efectos
          Container(
            padding: const EdgeInsets.all(8), // Padding interno
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Forma circular
              border: Border.all(
                // Borde circular
                color: const Color(0xFF4CAF50), // Color verde
                width: 3, // Grosor del borde
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.1), // Sombra negra semitransparente
                  blurRadius: 8, // Desenfoque
                  offset: const Offset(0, 4), // Desplazamiento hacia abajo
                ),
              ],
            ),
            child: AvatarWidget(
              // Widget de avatar personalizado
              user: _currentUser, // Usuario actual
              size: 150, // Tamaño grande del avatar
              borderColor: Colors.transparent, // Sin borde adicional
              showBorder: false, // No mostrar borde
              showEffects: true, // Mostrar efectos visuales
            ),
          ),

          const SizedBox(height: 16), // Espaciador vertical

          // Detalles del avatar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12), // Padding específico
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50)
                  .withOpacity(0.1), // Fondo verde semitransparente
              borderRadius: BorderRadius.circular(12), // Bordes redondeados
              border: Border.all(
                // Borde del contenedor
                color: const Color(0xFF4CAF50)
                    .withOpacity(0.3), // Borde verde semitransparente
              ),
            ),
            child: Column(
              children: [
                _buildAvatarDetail(
                    // Detalle de género
                    'Género',
                    _currentUser.gender ==
                            UserGender.femenino // Verificar género
                        ? 'Femenino' // Texto para femenino
                        : 'Masculino'), // Texto para masculino

                if (_currentUser
                    .hasCustomSkinColor) // Solo mostrar si hay personalización
                  _buildAvatarDetail(
                      'Tono de piel', // Detalle de tono de piel
                      _getColorName(_currentUser.skinColor,
                          _skinTones)), // Obtener nombre del color

                if (_currentUser
                    .hasCustomHairColor) // Solo mostrar si hay personalización
                  _buildAvatarDetail(
                      'Color de cabello', // Detalle de color de cabello
                      _getColorName(_currentUser.hairColor,
                          _hairColors)), // Obtener nombre del color

                if (_currentUser
                    .hasCustomEyeColor) // Solo mostrar si hay personalización
                  _buildAvatarDetail(
                      'Color de ojos', // Detalle de color de ojos
                      _getColorName(_currentUser.eyeColor,
                          _eyeColors)), // Obtener nombre del color

                if (_currentUser.hasGlasses)
                  _buildAvatarDetail('Lentes', 'Sí'), // Detalle de lentes

                // Resumen de personalización
                if (_currentUser
                    .isAvatarCustomized) // Solo mostrar si el avatar está personalizado
                  Padding(
                    padding: const EdgeInsets.only(top: 8), // Padding superior
                    child: Container(
                      padding: const EdgeInsets.all(8), // Padding interno
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50)
                            .withOpacity(0.2), // Fondo verde más intenso
                        borderRadius:
                            BorderRadius.circular(8), // Bordes redondeados
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centrar horizontalmente
                        children: [
                          const Icon(
                            Icons.check_circle, // Icono de verificación
                            size: 16, // Tamaño pequeño
                            color: Colors.green, // Color verde
                          ),
                          const SizedBox(width: 8), // Espaciador horizontal
                          Text(
                            'Avatar personalizado', // Texto de confirmación
                            style: TextStyle(
                              fontSize: 14, // Tamaño de fuente
                              fontWeight: FontWeight.w500, // Peso medio
                              color: Colors.green[800], // Color verde oscuro
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

  /*
      CONSTRUIR DETALLE INDIVIDUAL DEL AVATAR
  */
  Widget _buildAvatarDetail(String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4), // Padding vertical pequeño
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Espaciar entre elementos
        children: [
          Text(
            label, // Etiqueta del detalle
            style: const TextStyle(
              fontSize: 14, // Tamaño de fuente
              fontWeight: FontWeight.w500, // Peso medio
              color: Colors.grey, // Color gris
            ),
          ),
          Text(
            value, // Valor del detalle
            style: const TextStyle(
              fontSize: 14, // Tamaño de fuente
              fontWeight: FontWeight.bold, // Negrita
              color: Color(0xFF1B5E20), // Color verde oscuro
            ),
          ),
        ],
      ),
    );
  }

  /*
      CONSTRUIR SELECTOR DE GÉNERO
  */
  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), // Padding interno
      decoration: BoxDecoration(
        color: Colors.grey[50], // Fondo gris muy claro
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        border: Border.all(
          // Borde del contenedor
          color: Colors.grey[300]!, // Color gris claro
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Espaciar opciones uniformemente
        children: [
          _buildGenderOption(
            // Opción femenino
            UserGender.femenino, // Género femenino
            'Femenino', // Texto de la opción
            Icons.female, // Icono femenino
            const Color(0xFFEC407A), // Color rosa
          ),
          Container(
            // Divisor vertical
            width: 1, // Ancho de 1 píxel
            height: 40, // Altura de 40 píxeles
            color: Colors.grey[300], // Color gris claro
          ),
          _buildGenderOption(
            // Opción masculino
            UserGender.masculino, // Género masculino
            'Masculino', // Texto de la opción
            Icons.male, // Icono masculino
            const Color(0xFF42A5F5), // Color azul
          ),
        ],
      ),
    );
  }

  /*
      CONSTRUIR OPCIÓN INDIVIDUAL DE GÉNERO
  */
  Widget _buildGenderOption(
    UserGender gender, // Género de la opción
    String label, // Texto de la opción
    IconData icon, // Icono de la opción
    Color activeColor, // Color cuando está activa
  ) {
    final isSelected =
        _currentUser.gender == gender; // Verificar si está seleccionada

    return Expanded(
      // Ocupar todo el espacio disponible
      child: GestureDetector(
        onTap: () {
          // Acción al tocar
          setState(() {
            // Actualizar estado
            _currentUser =
                _currentUser.copyWith(gender: gender); // Actualizar género
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 8), // Padding interno
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withOpacity(0.1)
                : Colors.transparent, // Fondo si está seleccionada
            borderRadius: BorderRadius.circular(8), // Bordes redondeados
            border: Border.all(
              // Borde si está seleccionada
              color: isSelected
                  ? activeColor
                  : Colors.transparent, // Color del borde
              width: 2, // Grosor del borde
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon, // Icono de género
                size: 32, // Tamaño grande
                color: isSelected
                    ? activeColor
                    : Colors.grey, // Color según selección
              ),
              const SizedBox(height: 8), // Espaciador vertical
              Text(
                label, // Texto de la opción
                style: TextStyle(
                  fontSize: 14, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Negrita
                  color: isSelected
                      ? activeColor
                      : Colors.grey, // Color según selección
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
      CONSTRUIR SELECTOR DE COLOR
  */
  Widget _buildColorSelector({
    required String title, // Título del selector
    required List<Map<String, dynamic>> colors, // Lista de colores disponibles
    required Color currentColor, // Color actualmente seleccionado
    required Function(Color) onColorSelected, // Callback al seleccionar color
  }) {
    return Container(
      padding: const EdgeInsets.all(16), // Padding interno
      decoration: BoxDecoration(
        color: Colors.grey[50], // Fondo gris muy claro
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        border: Border.all(
          // Borde del contenedor
          color: Colors.grey[300]!, // Color gris claro
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinear al inicio horizontal
        children: [
          Row(
            children: [
              Icon(
                _getIconForColorType(title), // Icono según tipo de color
                color: const Color(0xFF1B5E20), // Color verde oscuro
                size: 20, // Tamaño del icono
              ),
              const SizedBox(width: 8), // Espaciador horizontal
              Text(
                title, // Título del selector
                style: const TextStyle(
                  fontSize: 16, // Tamaño de fuente
                  fontWeight: FontWeight.w500, // Peso medio
                  color: Color(0xFF1B5E20), // Color verde oscuro
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Espaciador vertical
          Wrap(
            // Diseño de elementos en múltiples líneas
            spacing: 12, // Espacio horizontal entre elementos
            runSpacing: 12, // Espacio vertical entre líneas
            children: colors.map((colorData) {
              // Mapear cada color a un widget
              final color = colorData['color'] as Color; // Obtener color
              final name = colorData['name'] as String; // Obtener nombre
              final isDefault =
                  colorData['default'] as bool; // Verificar si es por defecto
              final isSelected = currentColor.value ==
                  color.value; // Verificar si está seleccionado

              return _buildColorOption(
                // Widget de opción de color
                color: color, // Color de la opción
                name: name, // Nombre de la opción
                isDefault: isDefault, // Si es opción por defecto
                isSelected: isSelected, // Si está seleccionada
                onTap: () => onColorSelected(color), // Acción al tocar
              );
            }).toList(), // Convertir a lista
          ),
        ],
      ),
    );
  }

  /*
      CONSTRUIR OPCIÓN INDIVIDUAL DE COLOR
  */
  Widget _buildColorOption({
    required Color color, // Color de la opción
    required String name, // Nombre de la opción
    required bool isDefault, // Si es opción por defecto
    required bool isSelected, // Si está seleccionada
    required VoidCallback onTap, // Acción al tocar
  }) {
    return GestureDetector(
      onTap: onTap, // Ejecutar callback al tocar
      child: Container(
        width: 80, // Ancho fijo
        padding: const EdgeInsets.all(8), // Padding interno
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco
          borderRadius: BorderRadius.circular(8), // Bordes redondeados
          border: Border.all(
            // Borde del contenedor
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[300]!, // Color según selección
            width: isSelected ? 3 : 1, // Grosor según selección
          ),
          boxShadow: isSelected // Sombra solo si está seleccionada
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50)
                        .withOpacity(0.3), // Sombra verde semitransparente
                    blurRadius: 6, // Desenfoque
                    offset: const Offset(0, 2), // Desplazamiento hacia abajo
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Círculo de color
            Container(
              width: 40, // Ancho del círculo
              height: 40, // Altura del círculo
              decoration: BoxDecoration(
                color: color, // Color del círculo
                shape: BoxShape.circle, // Forma circular
                border: Border.all(
                  // Borde del círculo
                  color: Colors.grey[300]!, // Color gris claro
                ),
              ),
              child:
                  isSelected // Mostrar icono de verificación si está seleccionada
                      ? const Icon(
                          Icons.check, // Icono de verificación
                          size: 20, // Tamaño del icono
                          color: Colors.white, // Color blanco
                        )
                      : null,
            ),
            const SizedBox(height: 8), // Espaciador vertical
            Text(
              name, // Nombre del color
              style: TextStyle(
                fontSize: 12, // Tamaño de fuente pequeño
                fontWeight: FontWeight.w500, // Peso medio
                color: Colors.grey[800], // Color gris oscuro
              ),
              textAlign: TextAlign.center, // Centrar texto
              maxLines: 2, // Máximo 2 líneas
            ),
            if (isDefault) // Mostrar etiqueta si es opción por defecto
              Container(
                margin: const EdgeInsets.only(top: 4), // Margen superior
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 2), // Padding interno pequeño
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50)
                      .withOpacity(0.1), // Fondo verde semitransparente
                  borderRadius:
                      BorderRadius.circular(4), // Bordes redondeados pequeños
                ),
                child: const Text(
                  'Por defecto', // Texto de etiqueta
                  style: TextStyle(
                    fontSize: 10, // Tamaño de fuente muy pequeño
                    color: Color(0xFF4CAF50), // Color verde
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /*
      CONSTRUIR SELECTOR DE LENTES
  */
  Widget _buildGlassesSelector() {
    return Container(
      padding: const EdgeInsets.all(16), // Padding interno
      decoration: BoxDecoration(
        color: Colors.grey[50], // Fondo gris muy claro
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        border: Border.all(
          // Borde del contenedor
          color: Colors.grey[300]!, // Color gris claro
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinear al inicio horizontal
        children: [
          const Row(
            children: [
              Icon(
                Icons.visibility, // Icono de visibilidad
                color: Color(0xFF1B5E20), // Color verde oscuro
                size: 20, // Tamaño del icono
              ),
              SizedBox(width: 8), // Espaciador horizontal
              Text(
                'Lentes', // Título del selector
                style: TextStyle(
                  fontSize: 16, // Tamaño de fuente
                  fontWeight: FontWeight.w500, // Peso medio
                  color: Color(0xFF1B5E20), // Color verde oscuro
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Espaciador vertical
          Wrap(
            // Diseño de elementos en múltiples líneas
            spacing: 12, // Espacio horizontal entre elementos
            runSpacing: 12, // Espacio vertical entre líneas
            children: _glassesStyles.map((style) {
              // Mapear cada estilo a un widget
              final hasGlasses = style['hasGlasses'] as bool; // Si usa lentes
              final name = style['name'] as String; // Nombre del estilo
              final description = style['description'] as String; // Descripción
              final icon = style['icon'] as IconData; // Icono
              final color = style['color'] as Color; // Color
              final isDefault =
                  style['default'] as bool; // Si es opción por defecto
              final isSelected = _currentUser.hasGlasses ==
                  hasGlasses; // Verificar si está seleccionada

              return _buildGlassesOption(
                // Widget de opción de lentes
                hasGlasses: hasGlasses, // Si usa lentes
                name: name, // Nombre de la opción
                description: description, // Descripción
                icon: icon, // Icono
                color: color, // Color
                isDefault: isDefault, // Si es opción por defecto
                isSelected: isSelected, // Si está seleccionada
                onTap: () {
                  // Acción al tocar
                  setState(() {
                    // Actualizar estado
                    _currentUser = _currentUser.copyWith(
                        hasGlasses: hasGlasses); // Actualizar uso de lentes
                  });
                },
              );
            }).toList(), // Convertir a lista
          ),
        ],
      ),
    );
  }

  /*
      CONSTRUIR OPCIÓN INDIVIDUAL DE LENTES
  */
  Widget _buildGlassesOption({
    required bool hasGlasses, // Si la opción incluye lentes
    required String name, // Nombre de la opción
    required String description, // Descripción
    required IconData icon, // Icono
    required Color color, // Color
    required bool isDefault, // Si es opción por defecto
    required bool isSelected, // Si está seleccionada
    required VoidCallback onTap, // Acción al tocar
  }) {
    return GestureDetector(
      onTap: onTap, // Ejecutar callback al tocar
      child: Container(
        width: 120, // Ancho fijo
        padding: const EdgeInsets.all(12), // Padding interno
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco
          borderRadius: BorderRadius.circular(8), // Bordes redondeados
          border: Border.all(
            // Borde del contenedor
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[300]!, // Color según selección
            width: isSelected ? 3 : 1, // Grosor según selección
          ),
          boxShadow: isSelected // Sombra solo si está seleccionada
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50)
                        .withOpacity(0.3), // Sombra verde semitransparente
                    blurRadius: 6, // Desenfoque
                    offset: const Offset(0, 2), // Desplazamiento hacia abajo
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon, // Icono de la opción
              size: 32, // Tamaño grande
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : color, // Color según selección
            ),
            const SizedBox(height: 8), // Espaciador vertical
            Text(
              name, // Nombre de la opción
              style: TextStyle(
                fontSize: 14, // Tamaño de fuente
                fontWeight: FontWeight.bold, // Negrita
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : Colors.grey[800], // Color según selección
              ),
              textAlign: TextAlign.center, // Centrar texto
            ),
            const SizedBox(height: 4), // Espaciador vertical pequeño
            Text(
              description, // Descripción de la opción
              style: TextStyle(
                fontSize: 11, // Tamaño de fuente muy pequeño
                color: Colors.grey[600], // Color gris medio
              ),
              textAlign: TextAlign.center, // Centrar texto
            ),
            if (isDefault) // Mostrar etiqueta si es opción por defecto
              Container(
                margin: const EdgeInsets.only(top: 4), // Margen superior
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 2), // Padding interno pequeño
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50)
                      .withOpacity(0.1), // Fondo verde semitransparente
                  borderRadius:
                      BorderRadius.circular(4), // Bordes redondeados pequeños
                ),
                child: const Text(
                  'Por defecto', // Texto de etiqueta
                  style: TextStyle(
                    fontSize: 10, // Tamaño de fuente muy pequeño
                    color: Color(0xFF4CAF50), // Color verde
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /*
      CONSTRUIR BOTONES DE ACCIÓN
  */
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botón de guardar
        SizedBox(
          width: double.infinity, // Ancho completo
          child: ElevatedButton(
            onPressed: _saveAvatar, // Acción al presionar
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20), // Fondo verde oscuro
              foregroundColor: Colors.white, // Texto blanco
              padding: const EdgeInsets.symmetric(
                  vertical: 16), // Padding vertical grande
              shape: RoundedRectangleBorder(
                // Forma rectangular redondeada
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
              ),
              elevation: 4, // Elevación para sombra
              shadowColor:
                  const Color(0xFF1B5E20).withOpacity(0.5), // Color de sombra
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centrar contenido
              children: [
                Icon(Icons.check_circle, size: 24), // Icono de verificación
                SizedBox(width: 12), // Espaciador horizontal
                Text(
                  'Guardar Avatar', // Texto del botón
                  style: TextStyle(
                    fontSize: 18, // Tamaño de fuente grande
                    fontWeight: FontWeight.bold, // Negrita
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12), // Espaciador vertical

        // Botón de restablecer
        SizedBox(
          width: double.infinity, // Ancho completo
          child: OutlinedButton(
            onPressed: _resetAvatar, // Acción al presionar
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFD32F2F), // Texto rojo
              side: const BorderSide(
                // Borde del botón
                color: Color(0xFFD32F2F), // Color rojo
                width: 2, // Grosor del borde
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 16), // Padding vertical grande
              shape: RoundedRectangleBorder(
                // Forma rectangular redondeada
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centrar contenido
              children: [
                Icon(Icons.refresh, size: 24), // Icono de actualizar
                SizedBox(width: 12), // Espaciador horizontal
                Text(
                  'Restablecer a Predeterminado', // Texto del botón
                  style: TextStyle(
                    fontSize: 16, // Tamaño de fuente
                    fontWeight: FontWeight.bold, // Negrita
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /*
      MÉTODO PARA GUARDAR AVATAR
  */
  void _saveAvatar() {
    // Determinar si hay personalizaciones
    final hasCustomSkin = _currentUser.skinColor !=
        UserModel.defaultSkinColor; // Verificar piel personalizada
    final hasCustomHair = _currentUser.hairColor !=
        UserModel.defaultHairColor; // Verificar cabello personalizado
    final hasCustomEye = _currentUser.eyeColor !=
        UserModel.defaultEyeColor; // Verificar ojos personalizados
    final hasCustomGlass = _currentUser.hasGlasses !=
        UserModel.defaultHasGlasses; // Verificar lentes personalizados

    // Verificar si hay alguna personalización
    final hasAnyCustomization = hasCustomSkin ||
        hasCustomHair ||
        hasCustomEye ||
        hasCustomGlass; // Verificar cualquier personalización

    // Crear usuario actualizado
    final updatedUser = _currentUser.copyWith(
      // Crear copia con cambios
      // Mantener todos los cambios que ya están en _currentUser
      avatarStyle: hasAnyCustomization
          ? 'custom'
          : 'simple', // Establecer estilo según personalización
    );

    // Pasar el usuario actualizado al callback
    widget.onAvatarUpdated(updatedUser); // Notificar al componente padre

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Avatar ${_currentUser.gender == UserGender.femenino ? 'femenino' : 'masculino'} ${hasAnyCustomization ? 'personalizado' : 'actualizado'}!', // Mensaje personalizado
          style:
              const TextStyle(fontWeight: FontWeight.bold), // Texto en negrita
        ),
        backgroundColor: const Color(0xFF4CAF50), // Fondo verde
        behavior: SnackBarBehavior.floating, // Comportamiento flotante
        shape: RoundedRectangleBorder(
          // Forma rectangular redondeada
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
      ),
    );

    // Regresar a la pantalla anterior con el usuario actualizado
    Navigator.pop(context, updatedUser); // Cerrar pantalla y devolver usuario
  }

  /*
      MÉTODO PARA RESTABLECER AVATAR
  */
  void _resetAvatar() {
    setState(() {
      // Actualizar estado
      _currentUser = widget.user
          .resetAvatar(); // Restablecer avatar a valores predeterminados
    });

    // Mostrar mensaje de restablecimiento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Avatar restablecido a valores predeterminados', // Mensaje de confirmación
          style: TextStyle(fontWeight: FontWeight.bold), // Texto en negrita
        ),
        backgroundColor: Color(0xFF2196F3), // Fondo azul
        behavior: SnackBarBehavior.floating, // Comportamiento flotante
      ),
    );
  }

  /*
      MÉTODO AUXILIAR: OBTENER NOMBRE DE COLOR
  */
  String _getColorName(Color color, List<Map<String, dynamic>> colorList) {
    final colorData = colorList.firstWhere(
      // Buscar color en la lista
      (item) =>
          (item['color'] as Color).value ==
          color.value, // Comparar valores de color
      orElse: () =>
          {'name': 'Personalizado'}, // Valor por defecto si no se encuentra
    );
    return colorData['name'] as String; // Devolver nombre del color
  }

  /*
      MÉTODO AUXILIAR: OBTENER ICONO SEGÚN TIPO DE COLOR
  */
  IconData _getIconForColorType(String title) {
    switch (title) {
      case 'Tono de Piel': // Para tono de piel
        return Icons.face; // Icono de cara
      case 'Color de Cabello': // Para color de cabello
        return Icons.face_retouching_natural; // Icono de cara natural
      case 'Color de Ojos': // Para color de ojos
        return Icons.remove_red_eye; // Icono de ojo
      default: // Para cualquier otro caso
        return Icons.palette; // Icono de paleta
    }
  }
}
