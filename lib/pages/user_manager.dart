class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  int? userId;
  bool? isAdmin;

  UserManager._internal();
}
