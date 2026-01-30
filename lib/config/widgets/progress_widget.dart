// Importaciones de paquetes necesarios
import 'package:flutter/material.dart'; // Widgets básicos de Flutter
import 'package:huerto_app/themes/app_theme.dart'; // Tema de la aplicación
import 'package:huerto_app/themes/app_font.dart'; // Fuentes predefinidas

/*
    Widget que muestra una barra de progreso con información de nivel y puntos
    Ideal para mostrar progreso de usuario, experiencia, etc.
*/
class ProgressWidget extends StatelessWidget {
  // Propiedades del widget
  final int currentPoints; // Puntos actuales del usuario
  final int currentLevel; // Nivel actual del usuario
  final double progress; // Progreso actual (0.0 a 1.0)
  final String title; // Título del widget

  // Constructor del widget
  const ProgressWidget({
    super.key, // Clave para identificar el widget
    required this.currentPoints, // Puntos actuales obligatorios
    required this.currentLevel, // Nivel actual obligatorio
    required this.progress, // Progreso obligatorio
    required this.title, // Título obligatorio
  });

  // Método principal de construcción del widget
  @override
  Widget build(BuildContext context) {
    return Container(
      // Contenedor principal
      padding:
          const EdgeInsets.all(16), // Relleno interno de 16px en todos lados
      decoration: BoxDecoration(
        // Decoración con gradiente y sombra
        gradient: const LinearGradient(
          // Gradiente lineal
          colors: [freshMint, emeraldLeaf], // Colores del gradiente
          begin: Alignment.topLeft, // Inicio del gradiente
          end: Alignment.bottomRight, // Fin del gradiente
        ),
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        boxShadow: [
          // Sombra para efecto de elevación
          BoxShadow(
            color: forestDepth
                .withOpacity(0.2), // Color de sombra semitransparente
            blurRadius: 8, // Radio de desenfoque
            offset: const Offset(0, 4), // Desplazamiento hacia abajo
          ),
        ],
      ),
      child: Column(
        // Columna para organizar elementos verticalmente
        crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
        children: [
          // Fila para título y nivel
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espacio entre elementos
            children: [
              // Título del progreso
              Text(
                title, // Texto del título
                style: AppFont.titleMedium.copyWith(
                  // Estilo de texto
                  color: Colors.white, // Color blanco
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
              // Badge del nivel actual
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4), // Relleno interno
                decoration: BoxDecoration(
                  // Decoración del badge
                  color: Colors.white
                      .withOpacity(0.2), // Color blanco semitransparente
                  borderRadius:
                      BorderRadius.circular(20), // Bordes muy redondeados
                  border: Border.all(
                      color:
                          Colors.white.withOpacity(0.3)), // Borde blanco sutil
                ),
                child: Text(
                  'Nivel $currentLevel', // Texto con el nivel
                  style: AppFont.bodyMedium.copyWith(
                    // Estilo de texto
                    color: Colors.white, // Color blanco
                    fontWeight: FontWeight.bold, // Negrita
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Espaciador de 12px

          /*
              Barra de progreso
              Usa un Stack para superponer elementos
          */
          Stack(
            children: [
              // Fondo de la barra (parte no completada)
              Container(
                height: 20, // Altura fija de 20px
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.2), // Color blanco semitransparente
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),

              // Progreso actual (parte completada)
              AnimatedContainer(
                // Contenedor animado para transiciones suaves
                duration: const Duration(
                    milliseconds: 500), // Duración de la animación
                height: 20, // Altura fija de 20px
                width: MediaQuery.of(context).size.width *
                    progress, // Ancho proporcional al progreso
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    // Gradiente para la parte completada
                    colors: [goldenSun, sunflower], // Colores dorados
                  ),
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),

              // Texto de porcentaje superpuesto
              Positioned.fill(
                // Posicionar para llenar todo el espacio
                child: Center(
                  // Centrar el texto
                  child: Text(
                    '${(progress * 100).toStringAsFixed(0)}%', // Porcentaje sin decimales
                    style: const TextStyle(
                      // Estilo del texto
                      color: Colors.white, // Color blanco
                      fontWeight: FontWeight.bold, // Negrita
                      fontSize: 12, // Tamaño de fuente pequeño
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8), // Espaciador de 8px

          /*
              Información de puntos
              Fila con puntos actuales y puntos necesarios para siguiente nivel
          */
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espacio entre elementos
            children: [
              // Puntos actuales con icono
              Row(
                children: [
                  const Icon(Icons.star,
                      size: 16, color: Colors.white), // Icono de estrella
                  const SizedBox(width: 4), // Espaciador pequeño
                  Text(
                    '$currentPoints puntos', // Texto con puntos actuales
                    style: AppFont.bodySmall
                        .copyWith(color: Colors.white), // Estilo pequeño blanco
                  ),
                ],
              ),
              // Puntos necesarios para siguiente nivel
              Text(
                '${(currentLevel * 100) - currentPoints} para siguiente nivel', // Cálculo de puntos faltantes
                style: AppFont.bodySmall.copyWith(
                    color: Colors
                        .white70), // Estilo pequeño blanco semitransparente
              ),
            ],
          ),
        ],
      ),
    );
  }
}
