// Importaciones de paquetes necesarios
import 'package:flutter/material.dart'; // Widgets básicos de Flutter
import 'package:huerto_app/models/achievement_model.dart'; // Modelo de logro
import 'package:huerto_app/themes/app_theme.dart'; // Tema de la aplicación
import 'package:huerto_app/themes/app_font.dart'; // Fuentes predefinidas

/*
    Tarjeta que muestra un logro (achievement)
    Puede estar bloqueado, desbloqueado o equipado
*/
class AchievementCard extends StatelessWidget {
  // Propiedades del widget
  final Achievement achievement; // Datos del logro
  final bool isUnlocked; // Si el logro está desbloqueado
  final bool isEquipped; // Si el logro está equipado (usado como título)
  final VoidCallback? onTap; // Función al hacer tap (para ver detalles)
  final VoidCallback? onEquip; // Función para equipar el logro

  // Constructor del widget
  const AchievementCard({
    super.key, // Clave para identificar el widget
    required this.achievement, // Logro obligatorio
    this.isUnlocked = false, // Por defecto no desbloqueado
    this.isEquipped = false, // Por defecto no equipado
    this.onTap, // Función opcional
    this.onEquip, // Función opcional
  });

  // Método principal de construcción del widget
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context); // Tema actual (comentado)
    final color = _getColor(achievement.color); // Obtener color del logro

    return Card(
      // Tarjeta Material Design
      elevation: isEquipped ? 4 : 2, // Mayor elevación si está equipado
      shape: RoundedRectangleBorder(
        // Forma con bordes redondeados
        borderRadius: BorderRadius.circular(12), // Radio de borde
        side: BorderSide(
          // Borde lateral
          color: isEquipped
              ? color
              : Colors
                  .transparent, // Color si está equipado, transparente si no
          width: isEquipped ? 2 : 0, // Ancho del borde
        ),
      ),
      child: InkWell(
        // Para efecto de tap
        onTap:
            isUnlocked ? onTap : null, // Solo permite tap si está desbloqueado
        borderRadius:
            BorderRadius.circular(12), // Radio de borde para el efecto de tap
        child: Padding(
          // Relleno interno
          padding: const EdgeInsets.all(12), // 12px en todos lados
          child: Column(
            // Columna para organizar elementos
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinear a la izquierda
            children: [
              /*
                  Header con icono y título
                  Fila con icono, información y estado
              */
              Row(
                children: [
                  // Icono del logro
                  Container(
                    width: 40, // Ancho fijo
                    height: 40, // Alto fijo
                    decoration: BoxDecoration(
                      color: color.withOpacity(isUnlocked
                          ? 0.2
                          : 0.1), // Color con opacidad según estado
                      borderRadius: BorderRadius.circular(20), // Forma circular
                      border: Border.all(
                        // Borde
                        color: color.withOpacity(isUnlocked
                            ? 0.5
                            : 0.3), // Color del borde según estado
                      ),
                    ),
                    child: Center(
                      // Centrar el icono
                      child: Text(
                        achievement.icon, // Icono emoji o texto
                        style:
                            const TextStyle(fontSize: 20), // Tamaño de fuente
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Espaciador

                  // Título y descripción (expandido para ocupar espacio disponible)
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Alinear a la izquierda
                      children: [
                        // Título del logro
                        Text(
                          achievement.title, // Texto del título
                          style: AppFont.titleSmall.copyWith(
                            // Estilo de texto
                            color: isUnlocked
                                ? color
                                : Colors.grey[600], // Color según estado
                            fontWeight: FontWeight.bold, // Negrita
                          ),
                          maxLines: 1, // Máximo una línea
                          overflow: TextOverflow
                              .ellipsis, // Puntos suspensivos si es muy largo
                        ),
                        const SizedBox(height: 2), // Espaciador pequeño
                        // Descripción del logro
                        Text(
                          achievement.description, // Texto de descripción
                          style: AppFont.bodySmall.copyWith(
                            // Estilo de texto
                            color: isUnlocked
                                ? Colors
                                    .grey[700] // Gris oscuro si desbloqueado
                                : Colors.grey[500], // Gris medio si bloqueado
                          ),
                          maxLines: 2, // Máximo dos líneas
                          overflow: TextOverflow
                              .ellipsis, // Puntos suspensivos si es muy largo
                        ),
                      ],
                    ),
                  ),

                  // Estado (bloqueado/desbloqueado)
                  Icon(
                    isUnlocked
                        ? Icons.verified
                        : Icons.lock_outline, // Icono según estado
                    color: isUnlocked
                        ? color
                        : Colors.grey[400], // Color según estado
                    size: 20, // Tamaño del icono
                  ),
                ],
              ),

              const SizedBox(height: 12), // Espaciador

              /*
                  Progreso (solo si no está desbloqueado)
                  Muestra barra de progreso para logros en proceso
              */
              if (!isUnlocked &&
                  achievement.totalRequired >
                      1) // Condicional: solo si está bloqueado y requiere progreso
                Column(
                  children: [
                    // Barra de progreso lineal
                    LinearProgressIndicator(
                      value: achievement
                          .progressPercentage, // Porcentaje de progreso
                      backgroundColor: Colors.grey[200], // Color de fondo
                      color: color, // Color de la barra de progreso
                      minHeight: 6, // Altura mínima
                      borderRadius:
                          BorderRadius.circular(3), // Bordes redondeados
                    ),
                    const SizedBox(height: 4), // Espaciador pequeño
                    // Información numérica del progreso
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Espacio entre elementos
                      children: [
                        // Progreso actual vs total
                        Text(
                          '${achievement.currentProgress}/${achievement.totalRequired}', // Texto con progreso
                          style: AppFont.bodySmall.copyWith(
                            color: Colors.grey[600], // Color gris
                          ),
                        ),
                        // Porcentaje de progreso
                        Text(
                          '${(achievement.progressPercentage * 100).toStringAsFixed(0)}%', // Porcentaje sin decimales
                          style: AppFont.bodySmall.copyWith(
                            fontWeight: FontWeight.bold, // Negrita
                            color: color, // Color del logro
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              /*
                  Puntos y nivel
                  Fila con información de recompensa y nivel del logro
              */
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Espacio entre elementos
                children: [
                  // Puntos de recompensa
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4), // Relleno interno
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1), // Color con opacidad baja
                      borderRadius:
                          BorderRadius.circular(8), // Bordes redondeados
                      border: Border.all(
                          color: color.withOpacity(0.3)), // Borde sutil
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            size: 12,
                            color: goldenSun), // Icono de estrella pequeño
                        const SizedBox(width: 4), // Espaciador pequeño
                        Text(
                          '+${achievement.requiredPoints}', // Texto con puntos
                          style: AppFont.bodySmall.copyWith(
                            fontWeight: FontWeight.bold, // Negrita
                            color: color, // Color del logro
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nivel del logro (bronce, plata, oro, etc.)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4), // Relleno interno
                    decoration: BoxDecoration(
                      color: _getLevelColor(achievement.level)
                          .withOpacity(0.1), // Color según nivel
                      borderRadius:
                          BorderRadius.circular(8), // Bordes redondeados
                      border: Border.all(
                        // Borde
                        color: _getLevelColor(achievement.level)
                            .withOpacity(0.3), // Color del borde
                      ),
                    ),
                    child: Text(
                      _getLevelName(achievement.level), // Nombre del nivel
                      style: AppFont.bodySmall.copyWith(
                        fontWeight: FontWeight.bold, // Negrita
                        color: _getLevelColor(
                            achievement.level), // Color según nivel
                      ),
                    ),
                  ),
                ],
              ),

              /*
                  Botón para equipar (solo si está desbloqueado y no está equipado)
                  Permite usar el logro como título
              */
              if (isUnlocked &&
                  !isEquipped &&
                  onEquip != null) // Condicional múltiple
                Padding(
                  padding: const EdgeInsets.only(top: 8), // Relleno superior
                  child: SizedBox(
                    // SizedBox para ancho completo
                    width: double.infinity, // Ancho completo
                    child: ElevatedButton.icon(
                      // Botón con icono
                      onPressed: onEquip, // Función al presionar
                      style: ElevatedButton.styleFrom(
                        // Estilo personalizado
                        backgroundColor: color, // Color de fondo
                        foregroundColor: Colors.white, // Color del texto/icono
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // Relleno vertical
                        shape: RoundedRectangleBorder(
                          // Forma con bordes redondeados
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 16), // Icono de check
                      label: const Text('Usar como título'), // Texto del botón
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /*
      Obtener color real a partir del nombre del color
      Convierte nombres de colores del tema a objetos Color
  */
  Color _getColor(String colorName) {
    switch (colorName) {
      case 'freshMint':
        return freshMint; // Verde menta
      case 'clearBlue':
        return clearBlue; // Azul claro
      case 'sunflower':
        return sunflower; // Amarillo girasol
      case 'goldenSun':
        return goldenSun; // Dorado
      case 'berryPink':
        return berryPink; // Rosa
      case 'emeraldLeaf':
        return emeraldLeaf; // Verde esmeralda
      case 'forestDepth':
        return forestDepth; // Verde bosque oscuro
      default:
        return freshMint; // Valor por defecto
    }
  }

  /*
      Obtener color según el nivel del logro
      Asigna colores específicos para cada nivel
  */
  Color _getLevelColor(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return const Color(0xFFCD7F32); // Bronce
      case AchievementLevel.silver:
        return const Color(0xFFC0C0C0); // Plata
      case AchievementLevel.gold:
        return const Color(0xFFFFD700); // Oro
      case AchievementLevel.platinum:
        return const Color(0xFFE5E4E2); // Platino
      case AchievementLevel.diamond:
        return const Color(0xFFB9F2FF); // Diamante
    }
  }

  /*
      Obtener nombre en español según el nivel del logro
      Convierte el enum a texto legible
  */
  String _getLevelName(AchievementLevel level) {
    switch (level) {
      case AchievementLevel.bronze:
        return 'Bronce';
      case AchievementLevel.silver:
        return 'Plata';
      case AchievementLevel.gold:
        return 'Oro';
      case AchievementLevel.platinum:
        return 'Platino';
      case AchievementLevel.diamond:
        return 'Diamante';
    }
  }
}
