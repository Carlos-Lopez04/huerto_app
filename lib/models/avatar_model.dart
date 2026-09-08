// models/avatar_model.dart
import 'package:flutter/material.dart'; // Importar framework Flutter

// Enumeración para tipos de avatar base
enum AvatarBaseType {
  child, // Niña/niño
  teen, // Adolescente
  adult, // Adulto joven
  elder, // Adulto mayor
}

/*
    Modelo para representar un avatar personalizable
*/
class AvatarModel {
  final AvatarBaseType
      baseType; // Tipo de avatar base (niño, adolescente, etc.)
  final Color skinColor; // Color de piel
  final Color hairColor; // Color de cabello
  final Color eyeColor; // Color de ojos
  final bool hasGlasses; // Si usa lentes
  final String? outfit; // Vestimenta/outfit (opcional)
  final String? expression; // Expresión facial (opcional)
  final String? accessory; // Accesorio adicional (opcional)

  // Constructor de AvatarModel
  const AvatarModel({
    this.baseType =
        AvatarBaseType.teen, // Opcional: tipo base (adolescente por defecto)
    this.skinColor =
        const Color(0xFFFFDBAC), // Opcional: color piel (claro por defecto)
    this.hairColor =
        Colors.black, // Opcional: color cabello (negro por defecto)
    this.eyeColor = Colors.brown, // Opcional: color ojos (café por defecto)
    this.hasGlasses = false, // Opcional: lentes (false por defecto)
    this.outfit, // Opcional: vestimenta
    this.expression, // Opcional: expresión
    this.accessory, // Opcional: accesorio
  });

  /*
    Crea una copia del AvatarModel con algunos valores actualizados
  */
  AvatarModel copyWith({
    AvatarBaseType? baseType,
    Color? skinColor,
    Color? hairColor,
    Color? eyeColor,
    bool? hasGlasses,
    String? outfit,
    String? expression,
    String? accessory,
  }) {
    return AvatarModel(
      baseType: baseType ?? this.baseType, // Usa nuevo valor o el actual
      skinColor: skinColor ?? this.skinColor,
      hairColor: hairColor ?? this.hairColor,
      eyeColor: eyeColor ?? this.eyeColor,
      hasGlasses: hasGlasses ?? this.hasGlasses,
      outfit: outfit ?? this.outfit,
      expression: expression ?? this.expression,
      accessory: accessory ?? this.accessory,
    );
  }

  /*
    Convierte AvatarModel a mapa de datos
  */
  Map<String, dynamic> toMap() {
    return {
      'baseType': baseType.index, // Guarda el índice del enum
      'skinColor': skinColor.value, // Guarda valor hexadecimal del color
      'hairColor': hairColor.value, // Guarda valor hexadecimal del color
      'eyeColor': eyeColor.value, // Guarda valor hexadecimal del color
      'hasGlasses': hasGlasses, // Guarda booleano
      'outfit': outfit, // Guarda string o null
      'expression': expression, // Guarda string o null
      'accessory': accessory, // Guarda string o null
    };
  }

  /*
    Constructor factory para crear AvatarModel desde mapa de datos
  */
  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(
      baseType: AvatarBaseType.values[map['baseType'] ??
          1], // Obtiene enum desde índice (1 = teen por defecto)
      skinColor:
          Color(map['skinColor'] ?? 0xFFFFDBAC), // Crea Color desde valor hex
      hairColor: Color(
          map['hairColor'] ?? Colors.black.value), // Crea Color desde valor hex
      eyeColor: Color(
          map['eyeColor'] ?? Colors.brown.value), // Crea Color desde valor hex
      hasGlasses: map['hasGlasses'] ?? false, // Booleano o false por defecto
      outfit: map['outfit'], // String o null
      expression: map['expression'], // String o null
      accessory: map['accessory'], // String o null
    );
  }

  /*
    Obtiene la ruta de la imagen base según el tipo
  */
  String get baseImagePath {
    switch (baseType) {
      case AvatarBaseType.child:
        return 'assets/avatars/base/child_base.png'; // Ruta para niño/niña
      case AvatarBaseType.teen:
        return 'assets/avatars/base/teen_base.png'; // Ruta para adolescente
      case AvatarBaseType.adult:
        return 'assets/avatars/base/adult_base.png'; // Ruta para adulto joven
      case AvatarBaseType.elder:
        return 'assets/avatars/base/elder_base.png'; // Ruta para adulto mayor
    }
  }

  /*
    Obtiene la ruta de la imagen de cabello según el color
  */
  String get hairImagePath {
    // Nombres de archivos basados en color aproximado
    if (hairColor == Colors.black) {
      return 'assets/avatars/hair/black_hair.png'; // Cabello negro
    }
    if (hairColor == Colors.brown) {
      return 'assets/avatars/hair/brown_hair.png'; // Cabello café
    }
    if (hairColor == Colors.yellow[50]) {
      // Amarillo claro (rubio)
      return 'assets/avatars/hair/blonde_hair.png'; // Cabello rubio
    }
    if (hairColor == Colors.red) {
      return 'assets/avatars/hair/red_hair.png'; // Cabello rojo
    }
    if (hairColor == Colors.grey) {
      return 'assets/avatars/hair/grey_hair.png'; // Cabello gris
    }
    return 'assets/avatars/hair/default_hair.png'; // Cabello por defecto
  }

  /*
    Obtiene la ruta de la imagen de ojos según el color
  */
  String get eyeImagePath {
    if (eyeColor == Colors.brown) {
      return 'assets/avatars/eyes/brown_eyes.png'; // Ojos cafés
    }
    if (eyeColor == Colors.blue) {
      return 'assets/avatars/eyes/blue_eyes.png'; // Ojos azules
    }
    if (eyeColor == Colors.green) {
      return 'assets/avatars/eyes/green_eyes.png'; // Ojos verdes
    }
    if (eyeColor == Colors.grey) {
      return 'assets/avatars/eyes/grey_eyes.png'; // Ojos grises
    }
    return 'assets/avatars/eyes/default_eyes.png'; // Ojos por defecto
  }

  /*
    Representación en string del AvatarModel (para debugging)
  */
  @override
  String toString() {
    return 'AvatarModel(baseType: $baseType, skinColor: $skinColor, hairColor: $hairColor, eyeColor: $eyeColor)';
  }

  /*
    Compara si dos AvatarModel son iguales (operador ==)
  */
  @override
  bool operator ==(Object other) =>
      identical(this, other) || // Misma referencia
      other is AvatarModel && // Mismo tipo
          runtimeType == other.runtimeType && // Misma clase
          baseType == other.baseType && // Mismo tipo base
          skinColor == other.skinColor && // Mismo color de piel
          hairColor == other.hairColor && // Mismo color de cabello
          eyeColor == other.eyeColor && // Mismo color de ojos
          hasGlasses == other.hasGlasses; // Mismo valor de lentes

  /*
    Genera código hash para AvatarModel
  */
  @override
  int get hashCode =>
      baseType.hashCode ^ // Hash del tipo base
      skinColor.hashCode ^ // Hash del color de piel
      hairColor.hashCode ^ // Hash del color de cabello
      eyeColor.hashCode ^ // Hash del color de ojos
      hasGlasses.hashCode; // Hash del booleano de lentes
}
