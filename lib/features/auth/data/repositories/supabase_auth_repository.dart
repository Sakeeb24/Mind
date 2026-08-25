import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final supabase.SupabaseClient _client;

  supabase.User? get _supabaseUser => _client.auth.currentUser;

  @override
  User? get currentUser => _mapUser(_supabaseUser);

  @override
  Stream<User?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      return _mapUser(event.session?.user);
    });
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );
    if (response.user == null) {
      throw Exception('Sign up failed');
    }
    return _mapUser(response.user)!;
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Sign in failed');
    }
    return _mapUser(response.user)!;
  }

  @override
  Future<User> signInWithGoogle() async {
    final response = await _client.auth.signInWithOAuth(
      supabase.OAuthProvider.google,
      redirectTo: 'io.supabase.mindspace://login-callback/',
    );
    if (!response) {
      throw Exception('Google sign in failed');
    }
    // After OAuth redirect, the auth state change stream will emit the user.
    final user = _supabaseUser;
    if (user == null) {
      throw Exception('Google sign in completed but no user found');
    }
    return _mapUser(user)!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? _mapUser(supabase.User? user) {
    if (user == null) return null;
    return User(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }
}
