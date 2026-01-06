import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

class CustomCards {
  // Configuración unificada para todas las cards
  static const Color _cardColor = verdeGelido;
  static const double _elevation = 3;
  static const double _borderRadius = 12;
  static const Color _iconColor = verdeBosque;
  static const Color _trailingIconColor = verdeBosque;

  // Card para "Plantas del Huerto"
  static Card plantasHuerto(BuildContext context) {
    return _buildCard(
      context: context,
      icon: Icons.eco,
      title: 'Plantas del Huerto',
      subtitle: null,
    );
  }

  // Card para "Calendario de Siembra"
  static Card calendarioSiembra(BuildContext context) {
    return _buildCard(
      context: context,
      icon: Icons.calendar_today,
      title: 'Calendario de Siembra',
      subtitle: 'Actividades Diarias',
    );
  }

  // Método privado para construir cards unificadas
  static Card _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      color: _cardColor,
      elevation: _elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: ListTile(
        leading: Icon(icon, color: _iconColor),
        title: Text(title, style: AppFont.cardTitle), // USANDO APP_FONT
        subtitle: subtitle != null
            ? Text(subtitle, style: AppFont.cardSubtitle) // USANDO APP_FONT
            : null,
        trailing: const Icon(Icons.chevron_right, color: _trailingIconColor),
        onTap: onTap,
      ),
    );
  }
}
