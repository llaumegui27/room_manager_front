class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  int? userId; // Utilisez int au lieu de String pour stocker l'ID

  UserManager._internal();
}
