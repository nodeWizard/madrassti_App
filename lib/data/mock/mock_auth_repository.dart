import '../models/models.dart';
import '../repositories/repositories.dart';

/// Dummy accounts, parsed from `assets/mock_data/users.json`.
///
/// Sign-in is a plain list lookup — no hashing, no backend. Good enough for a
/// demo login, not for anything real.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository.fromJson(Map<String, dynamic> json)
    : users = (json['users'] as List)
          .cast<Map<String, dynamic>>()
          .map(_user)
          .toList();

  @override
  final List<UserAccount> users;

  @override
  UserAccount? signIn({required String phone, required String password}) {
    for (final u in users) {
      if (u.phone == phone && u.password == password) return u;
    }
    return null;
  }

  static UserAccount _user(Map<String, dynamic> j) => UserAccount(
    id: j['id'] as String,
    role: j['role'] as String,
    firstName: j['firstName'] as String,
    lastName: j['lastName'] as String,
    phone: j['phone'] as String,
    password: j['password'] as String,
  );
}
