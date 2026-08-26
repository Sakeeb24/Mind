import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';
import 'package:mindspace/providers/cloud_providers.dart';

/// Auth state enum.
enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

/// Auth state class.
class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

/// Auth notifier managing sign-in, sign-up, and sign-out.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final repo = ref.watch(authRepositoryProvider);
    final user = repo.currentUser;
    if (user != null) {
      return AuthState(status: AuthStatus.authenticated, user: user);
    }

    repo.authStateChanges.listen((user) {
      state = AuthState(
        status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        user: user,
      );
    });

    return const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Sign in with email (Puter uses token-based auth — this throws).
  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signInWithEmail(email: email, password: password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign up with email (Puter uses token-based auth — this throws).
  Future<void> signUpWithEmail(String email, String password, {String? displayName}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign in with a Puter auth token — the primary authentication method.
  Future<void> signInWithToken(String token) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final dynamic dynRepo = repo;
      final Future<User> userFuture = dynRepo.signInWithToken(token);
      final user = await userFuture;
      state = AuthState(status: AuthStatus.authenticated, user: user);

      // Trigger cloud sync after successful login
      _triggerCloudSync(token);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Background cloud sync after login — non-blocking, best-effort.
  void _triggerCloudSync(String token) {
    try {
      final syncService = ref.read(cloudSyncServiceProvider);
      syncService.fullSync(token); // Fire-and-forget
    } catch (_) {
      // Sync failure is non-fatal
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendPasswordResetEmail(email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

/// Provider for the auth repository (overridden at startup with PuterAuthRepository).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('Override authRepositoryProvider with real implementation');
});

/// Provider for the auth notifier.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
