// models/user_model.dart
import 'package:huerto_app/models/avatar_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String title; // Logro seleccionado
  final String rank;
  final String? imageUrl;
  final List<String> unlockedAchievements; // Lista de logros desbloqueados
  final DateTime createdAt;
  final DateTime updatedAt;
  final AvatarModel avatar; // NUEVO: Modelo de avatar

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.title,
    required this.rank,
    this.imageUrl,
    required this.unlockedAchievements,
    required this.createdAt,
    required this.updatedAt,
    required this.avatar, // NUEVO
  });

  // Constructor desde Map (para JSON o Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      title: map['title'] ?? 'Novato Verde',
      rank: map['rank'] ?? 'Semilla',
      imageUrl: map['imageUrl'],
      unlockedAchievements:
          List<String>.from(map['unlockedAchievements'] ?? ['beginner']),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'].toString())
          : DateTime.now(),
      avatar: map['avatar'] != null
          ? AvatarModel.fromMap(Map<String, dynamic>.from(map['avatar']))
          : const AvatarModel(), // NUEVO
    );
  }

  // Constructor para crear usuario por defecto
  factory UserModel.defaultUser({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? 'default_user_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Usuario',
      email: email ?? 'usuario@ejemplo.com',
      title: 'Novato Verde',
      rank: 'Semilla',
      imageUrl: null,
      unlockedAchievements: ['beginner'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      avatar: const AvatarModel(), // NUEVO
    );
  }

  // Convertir a mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'title': title,
      'rank': rank,
      'imageUrl': imageUrl,
      'unlockedAchievements': unlockedAchievements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'avatar': avatar.toMap(), // NUEVO
    };
  }

  // Método copyWith para actualizar campos
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? title,
    String? rank,
    String? imageUrl,
    List<String>? unlockedAchievements,
    DateTime? createdAt,
    DateTime? updatedAt,
    AvatarModel? avatar, // NUEVO
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      title: title ?? this.title,
      rank: rank ?? this.rank,
      imageUrl: imageUrl ?? this.imageUrl,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      avatar: avatar ?? this.avatar, // NUEVO
    );
  }

  // Método para actualizar el avatar
  UserModel updateAvatar(AvatarModel newAvatar) {
    return copyWith(avatar: newAvatar);
  }

  // Método para añadir logro desbloqueado
  UserModel addAchievement(String achievementId) {
    List<String> newAchievements = List.from(unlockedAchievements);
    if (!newAchievements.contains(achievementId)) {
      newAchievements.add(achievementId);
    }
    return copyWith(unlockedAchievements: newAchievements);
  }

  // Método para verificar si un logro está desbloqueado
  bool hasAchievement(String achievementId) {
    return unlockedAchievements.contains(achievementId);
  }

  // Método para quitar logro (si es necesario)
  UserModel removeAchievement(String achievementId) {
    List<String> newAchievements = List.from(unlockedAchievements);
    newAchievements.remove(achievementId);
    return copyWith(unlockedAchievements: newAchievements);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, title: $title, rank: $rank, unlockedAchievements: $unlockedAchievements, avatar: $avatar)';
  }
}
