import 'package:mindspace/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Returns the currently authenticated user, or null if not signed in.
  User? get currentUser;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges;

  /// Sign up with email and password.
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with email and password.
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google OAuth.
  Future<User> signInWithGoogle();

  /// Send a password reset email.
  Future<void> sendPasswordResetEmail(String email);

  /// Sign out.
  Future<void> signOut();
}
