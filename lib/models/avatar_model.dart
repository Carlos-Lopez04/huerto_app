// models/avatar_model.dart
import 'package:flutter/material.dart';

class AvatarModel {
  final Color skinColor;
  final Color hairColor;
  final Color eyeColor;
  final bool hasGlasses;
  final String? outfit;
  final String? expression;

  const AvatarModel({
    this.skinColor = const Color(0xFFFFDBAC),
    this.hairColor = Colors.black,
    this.eyeColor = Colors.brown,
    this.hasGlasses = false,
    this.outfit,
    this.expression,
  });

  AvatarModel copyWith({
    Color? skinColor,
    Color? hairColor,
    Color? eyeColor,
    bool? hasGlasses,
    String? outfit,
    String? expression,
  }) {
    return AvatarModel(
      skinColor: skinColor ?? this.skinColor,
      hairColor: hairColor ?? this.hairColor,
      eyeColor: eyeColor ?? this.eyeColor,
      hasGlasses: hasGlasses ?? this.hasGlasses,
      outfit: outfit ?? this.outfit,
      expression: expression ?? this.expression,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'skinColor': skinColor.value,
      'hairColor': hairColor.value,
      'eyeColor': eyeColor.value,
      'hasGlasses': hasGlasses,
      'outfit': outfit,
      'expression': expression,
    };
  }

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(
      skinColor: Color(map['skinColor'] ?? 0xFFFFDBAC),
      hairColor: Color(map['hairColor'] ?? Colors.black.value),
      eyeColor: Color(map['eyeColor'] ?? Colors.brown.value),
      hasGlasses: map['hasGlasses'] ?? false,
      outfit: map['outfit'],
      expression: map['expression'],
    );
  }

  @override
  String toString() {
    return 'AvatarModel(skinColor: $skinColor, hairColor: $hairColor, eyeColor: $eyeColor, hasGlasses: $hasGlasses)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarModel &&
          runtimeType == other.runtimeType &&
          skinColor == other.skinColor &&
          hairColor == other.hairColor &&
          eyeColor == other.eyeColor &&
          hasGlasses == other.hasGlasses;

  @override
  int get hashCode =>
      skinColor.hashCode ^
      hairColor.hashCode ^
      eyeColor.hashCode ^
      hasGlasses.hashCode;
}
