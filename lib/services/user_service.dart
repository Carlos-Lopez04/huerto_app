import 'package:huerto_app/models/user_model.dart';

class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  UserModel _currentUser = UserModel(
    name: 'Ana García',
    email: 'ana.garcia@huerto.com',
    title: 'Agricultor Novato',
    rank: 'Semilla',
  );

  UserModel get currentUser => _currentUser;

  void updateUser(UserModel newUser) {
    _currentUser = newUser;
    // Notificar a todos los listeners
    _notifyListeners();
  }

  // Sistema de notificación para actualizaciones en tiempo real
  final List<Function(UserModel)> _listeners = [];

  void addListener(Function(UserModel) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(UserModel) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_currentUser);
    }
  }
}