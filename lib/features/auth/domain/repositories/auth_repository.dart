import '../entities/user.dart';

abstract class AuthRepository {
  /// Get the current authenticated user
  Future<User?> getCurrentUser();

  /// Sign in with Google
  Future<User> signInWithGoogle();

  /// Sign in with phone number
  Future<User> signInWithPhone(String phoneNumber);

  /// Sign out the current user
  Future<void> signOut();

  /// Stream of authentication state changes
  Stream<bool> get authStateChanges;
}