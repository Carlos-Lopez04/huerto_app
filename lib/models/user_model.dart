class UserModel {
  final String name;
  final String email;
  final String? imageUrl;
  final String title;
  final String rank;

  UserModel({
    required this.name,
    required this.email,
    this.imageUrl,
    this.title = 'Agricultor Novato',
    this.rank = 'Semilla',
  });

  // Método para actualizar datos
  UserModel copyWith({
    String? name,
    String? email,
    String? imageUrl,
    String? title,
    String? rank,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      rank: rank ?? this.rank,
    );
  }
}