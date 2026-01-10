// models/avatar_model.dart
import 'package:flutter/material.dart';

// Enumeración para tipos de avatar base
enum AvatarBaseType {
  child, // Niña/niño
  teen, // Adolescente
  adult, // Adulto joven
  elder, // Adulto mayor
}

class AvatarModel {
  final AvatarBaseType baseType; // Tipo de avatar base
  final Color skinColor;
  final Color hairColor;
  final Color eyeColor;
  final bool hasGlasses;
  final String? outfit;
  final String? expression;
  final String? accessory; // Accesorio adicional (opcional)

  const AvatarModel({
    this.baseType = AvatarBaseType.teen, // Valor por defecto
    this.skinColor = const Color(0xFFFFDBAC),
    this.hairColor = Colors.black,
    this.eyeColor = Colors.brown,
    this.hasGlasses = false,
    this.outfit,
    this.expression,
    this.accessory,
  });

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
      baseType: baseType ?? this.baseType,
      skinColor: skinColor ?? this.skinColor,
      hairColor: hairColor ?? this.hairColor,
      eyeColor: eyeColor ?? this.eyeColor,
      hasGlasses: hasGlasses ?? this.hasGlasses,
      outfit: outfit ?? this.outfit,
      expression: expression ?? this.expression,
      accessory: accessory ?? this.accessory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baseType': baseType.index,
      'skinColor': skinColor.value,
      'hairColor': hairColor.value,
      'eyeColor': eyeColor.value,
      'hasGlasses': hasGlasses,
      'outfit': outfit,
      'expression': expression,
      'accessory': accessory,
    };
  }

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(
      baseType: AvatarBaseType.values[map['baseType'] ?? 1],
      skinColor: Color(map['skinColor'] ?? 0xFFFFDBAC),
      hairColor: Color(map['hairColor'] ?? Colors.black.value),
      eyeColor: Color(map['eyeColor'] ?? Colors.brown.value),
      hasGlasses: map['hasGlasses'] ?? false,
      outfit: map['outfit'],
      expression: map['expression'],
      accessory: map['accessory'],
    );
  }

  // Obtener la imagen base según el tipo
  String get baseImagePath {
    switch (baseType) {
      case AvatarBaseType.child:
        return 'assets/avatars/base/child_base.png';
      case AvatarBaseType.teen:
        return 'assets/avatars/base/teen_base.png';
      case AvatarBaseType.adult:
        return 'assets/avatars/base/adult_base.png';
      case AvatarBaseType.elder:
        return 'assets/avatars/base/elder_base.png';
    }
  }

  // Obtener la imagen de cabello según el color
  String get hairImagePath {
    // Nombres de archivos basados en color aproximado
    if (hairColor == Colors.black) return 'assets/avatars/hair/black_hair.png';
    if (hairColor == Colors.brown) return 'assets/avatars/hair/brown_hair.png';
    if (hairColor == Colors.yellow[50]) {
      return 'assets/avatars/hair/blonde_hair.png';
    }
    if (hairColor == Colors.red) return 'assets/avatars/hair/red_hair.png';
    if (hairColor == Colors.grey) return 'assets/avatars/hair/grey_hair.png';
    return 'assets/avatars/hair/default_hair.png';
  }

  // Obtener la imagen de ojos según el color
  String get eyeImagePath {
    if (eyeColor == Colors.brown) return 'assets/avatars/eyes/brown_eyes.png';
    if (eyeColor == Colors.blue) return 'assets/avatars/eyes/blue_eyes.png';
    if (eyeColor == Colors.green) return 'assets/avatars/eyes/green_eyes.png';
    if (eyeColor == Colors.grey) return 'assets/avatars/eyes/grey_eyes.png';
    return 'assets/avatars/eyes/default_eyes.png';
  }

  @override
  String toString() {
    return 'AvatarModel(baseType: $baseType, skinColor: $skinColor, hairColor: $hairColor, eyeColor: $eyeColor)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarModel &&
          runtimeType == other.runtimeType &&
          baseType == other.baseType &&
          skinColor == other.skinColor &&
          hairColor == other.hairColor &&
          eyeColor == other.eyeColor &&
          hasGlasses == other.hasGlasses;

  @override
  int get hashCode =>
      baseType.hashCode ^
      skinColor.hashCode ^
      hairColor.hashCode ^
      eyeColor.hashCode ^
      hasGlasses.hashCode;
}
