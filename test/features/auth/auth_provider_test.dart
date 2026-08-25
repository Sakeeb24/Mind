import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';

/// A mock implementation of AuthRepository for testing.
class MockAuthRepository implements AuthRepository {
  User? _currentUser;
  final List<User?> _authStateHistory = [];

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges async* {
    for (final user in _authStateHistory) {
      yield user;
    }
  }

  void setUser(User? user) {
    _currentUser = user;
    _authStateHistory.add(user);
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final user = User(
      id: 'test-id',
      email: email,
      displayName: displayName,
    );
    setUser(user);
    return user;
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (email == 'fail@test.com') {
      throw Exception('Invalid credentials');
    }
    final user = User(id: 'test-id', email: email);
    setUser(user);
    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final user = User(
      id: 'google-id',
      email: 'user@gmail.com',
      displayName: 'Google User',
    );
    setUser(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (email == 'fail@test.com') {
      throw Exception('User not found');
    }
  }

  @override
  Future<void> signOut() async {
    setUser(null);
  }
}

void main() {
  group('AuthState', () {
    test('initial state has correct defaults', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith preserves existing values', () {
      const original = AuthState(
        status: AuthStatus.authenticated,
        user: User(id: '1', email: 'test@test.com'),
      );
      final copied = original.copyWith(errorMessage: 'error');
      expect(copied.status, AuthStatus.authenticated);
      expect(copied.user?.id, '1');
      expect(copied.errorMessage, 'error');
    });

    test('copyWith with no args returns equal state', () {
      const original = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'test',
      );
      final copied = original.copyWith();
      expect(copied.status, original.status);
      expect(copied.errorMessage, isNull);
    });
  });

  group('MockAuthRepository', () {
    late MockAuthRepository repo;

    setUp(() {
      repo = MockAuthRepository();
    });

    test('starts with no current user', () {
      expect(repo.currentUser, isNull);
    });

    test('signUpWithEmail creates and returns user', () async {
      final user = await repo.signUpWithEmail(
        email: 'new@test.com',
        password: 'password123',
        displayName: 'New User',
      );
      expect(user.email, 'new@test.com');
      expect(user.displayName, 'New User');
      expect(repo.currentUser?.email, 'new@test.com');
    });

    test('signInWithEmail returns user on success', () async {
      final user = await repo.signInWithEmail(
        email: 'test@test.com',
        password: 'password123',
      );
      expect(user.email, 'test@test.com');
      expect(repo.currentUser?.email, 'test@test.com');
    });

    test('signInWithEmail throws on invalid credentials', () async {
      expect(
        () => repo.signInWithEmail(
          email: 'fail@test.com',
          password: 'wrong',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('signInWithGoogle returns Google user', () async {
      final user = await repo.signInWithGoogle();
      expect(user.email, 'user@gmail.com');
      expect(user.displayName, 'Google User');
    });

    test('signOut clears current user', () async {
      await repo.signInWithEmail(email: 'test@test.com', password: 'pass');
      expect(repo.currentUser, isNotNull);
      await repo.signOut();
      expect(repo.currentUser, isNull);
    });

    test('sendPasswordResetEmail succeeds for valid email', () async {
      await repo.sendPasswordResetEmail('test@test.com');
      // Should not throw
    });

    test('sendPasswordResetEmail throws for invalid email', () async {
      expect(
        () => repo.sendPasswordResetEmail('fail@test.com'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
