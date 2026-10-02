class LoginModel {
  final String email;
  final String password;
  final bool rememberMe;
  
  LoginModel({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  
  // Validar email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  // Validar contraseña (mínimo 6 caracteres)
  bool get isValidPassword => password.length >= 6;
  
  // Validar formulario completo
  bool get isValid => isValidEmail && isValidPassword;
  
  // Convertir a JSON (para enviar a API)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}