import 'dart:async';

import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  User? _currentUser;
  final _controller = StreamController<User?>.broadcast();

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _currentUser = User(
      id: 'mock-id',
      email: email,
      displayName: displayName,
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _currentUser = User(
      id: 'mock-id',
      email: email,
      displayName: 'Test User',
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<User> signInWithGoogle() async {
    _currentUser = const User(
      id: 'mock-google-id',
      email: 'test@google.com',
      displayName: 'Google User',
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
