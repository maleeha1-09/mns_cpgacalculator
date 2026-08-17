class DatabaseService {
  static final Map<String, Map<String, dynamic>> _users = {};

  static Future<bool> signUp(
      String username,
      String name,
      String email,
      String password,
      ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.containsKey(email)) {
      return false;
    }
    _users[email] = {
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'semesters': [],
    };
    return true;
  }

  static Future<Map<String, dynamic>?> login(
      String emailOrUsername,
      String password,
      ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (var user in _users.values) {
      if ((user['email'] == emailOrUsername ||
          user['username'] == emailOrUsername) &&
          user['password'] == password) {
        return user;
      }
    }
    return null;
  }

  static Future<bool> saveSemester(
      String email,
      Map<String, dynamic> semesterData,
      ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_users.containsKey(email)) {
      List semesters = _users[email]!['semesters'] ?? [];
      semesters.add(semesterData);
      _users[email]!['semesters'] = semesters;
      return true;
    }
    return false;
  }

  static Future<List<Map<String, dynamic>>> getSemesters(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_users.containsKey(email)) {
      return List<Map<String, dynamic>>.from(_users[email]!['semesters'] ?? []);
    }
    return [];
  }
}