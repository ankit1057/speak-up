import 'dart:async';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static final Map<String, dynamic> _storage = {};

  final _authStateController = StreamController<bool>.broadcast();

  final User _mockUser = const User(
    id: 'mock_user_id',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phoneNumber: null,
    photoUrl: null,
  );

  void _saveToStorage(String key, dynamic value) {
    _storage[key] = value;
  }

  dynamic _getFromStorage(String key) {
    return _storage[key];
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final isLoggedIn = _getFromStorage('isLoggedIn') ?? false;
    return isLoggedIn ? _mockUser : null;
  }

  @override
  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _saveToStorage('isLoggedIn', true);
    _authStateController.add(true);
    return _mockUser;
  }

  @override
  Future<User> signInWithPhone(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    _saveToStorage('isLoggedIn', true);
    _authStateController.add(true);
    return _mockUser.copyWith(phoneNumber: phoneNumber);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storage.clear();
    _authStateController.add(false);
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  void dispose() {
    _authStateController.close();
  }
}