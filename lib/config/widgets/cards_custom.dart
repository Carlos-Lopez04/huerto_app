// Importaciones de paquetes necesarios
import 'package:flutter/material.dart'; // Widgets básicos de Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Tema de la aplicación
import 'package:huerto_app/themes/app_font.dart'; // Fuentes predefinidas

/*
    Clase de utilidad para crear tarjetas personalizadas unificadas
    Proporciona métodos estáticos para diferentes tipos de tarjetas
*/
class CustomCards {
  /*
      Configuración unificada para todas las cards
      Constantes que definen el estilo consistente
  */
  static const Color _cardColor = verdeGelido; // Color de fondo de las tarjetas
  static const double _elevation = 3; // Elevación (sombra) de las tarjetas
  static const double _borderRadius = 12; // Radio de borde redondeado
  static const Color _iconColor = verdeBosque; // Color para iconos principales
  static const Color _trailingIconColor =
      verdeBosque; // Color para icono de flecha

  /*
      Card para "Plantas del Huerto"
      Método estático que devuelve una tarjeta preconfigurada
  */
  static Card plantasHuerto(BuildContext context) {
    return _buildCard(
      // Llamar al método de construcción genérico
      context: context, // Contexto de construcción
      icon: Icons.eco, // Icono de planta/ecología
      title: 'Plantas del Huerto', // Título de la tarjeta
      subtitle: null, // Sin subtítulo
    );
  }

  /*
      Card para "Calendario de Siembra"
      Método estático que devuelve una tarjeta preconfigurada
  */
  static Card calendarioSiembra(BuildContext context) {
    return _buildCard(
      // Llamar al método de construcción genérico
      context: context, // Contexto de construcción
      icon: Icons.calendar_today, // Icono de calendario
      title: 'Calendario de Siembra', // Título de la tarjeta
      subtitle: 'Actividades Diarias', // Subtítulo de la tarjeta
    );
  }

  /*
      Método privado para construir cards unificadas
      Centraliza la lógica de construcción de todas las tarjetas
  */
  static Card _buildCard({
    required BuildContext context, // Contexto de construcción (obligatorio)
    required IconData icon, // Icono a mostrar (obligatorio)
    required String title, // Título de la tarjeta (obligatorio)
    String? subtitle, // Subtítulo opcional
    VoidCallback? onTap, // Función opcional al hacer tap
  }) {
    return Card(
      // Widget Card de Material Design
      color: _cardColor, // Color de fondo definido en constantes
      elevation: _elevation, // Elevación (sombra) definida en constantes
      shape: RoundedRectangleBorder(
        // Forma con bordes redondeados
        borderRadius: BorderRadius.circular(_borderRadius), // Radio de borde
      ),
      child: ListTile(
        // ListTile dentro de la Card
        leading:
            Icon(icon, color: _iconColor), // Icono principal a la izquierda
        title: Text(title,
            style: AppFont.cardTitle), // Título con estilo de AppFont
        subtitle: subtitle != null // Subtítulo condicional
            ? Text(subtitle,
                style: AppFont.cardSubtitle) // Subtítulo con estilo
            : null, // Sin subtítulo si es null
        trailing: const Icon(Icons.chevron_right,
            color: _trailingIconColor), // Icono de flecha
        onTap: onTap, // Función al hacer tap (si se proporciona)
      ),
    );
  }
}
