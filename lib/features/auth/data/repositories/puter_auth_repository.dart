import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mindspace/config/env.dart';
import 'package:mindspace/core/errors/app_exception.dart';
import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';

/// Puter authentication repository.
///
/// Uses Puter's REST API with a bearer token for authentication.
/// The token can be obtained from https://puter.com/dashboard → Create token.
class PuterAuthRepository implements AuthRepository {
  PuterAuthRepository({required String initialToken})
      : _token = initialToken {
    if (_token.isNotEmpty) {
      _loadUserFromToken();
    }
  }

  final Dio _dio = Dio(BaseOptions(
    baseUrl: Env.puterApiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static const _secureStorage = FlutterSecureStorage();
  final _controller = StreamController<User?>.broadcast();
  User? _currentUser;
  String _token;

  String get token => _token;

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  Future<void> _loadUserFromToken() async {
    try {
      final user = await _fetchUser();
      _currentUser = user;
      _controller.add(user);
    } catch (_) {
      _token = '';
      _currentUser = null;
      _controller.add(null);
    }
  }

  Future<User?> _fetchUser() async {
    if (_token.isEmpty) return null;

    try {
      final response = await _dio.get(
        '/whoami',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      final data = response.data;
      if (data == null) return null;

      final userData = data is Map ? data : jsonDecode(data.toString());
      if (userData is! Map) return null;

      return User(
        id: userData['uuid']?.toString() ?? userData['id']?.toString() ?? _token.hashCode.toString(),
        email: userData['username']?.toString() ?? '',
        displayName: userData['username']?.toString() ?? 'Puter User',
        avatarUrl: userData['avatar_url']?.toString(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    throw const AuthException(
      'Please sign in using your Puter account token. '
      'Get your token from https://puter.com/dashboard',
    );
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    throw const AuthException(
      'Please sign in using your Puter account token. '
      'Get your token from https://puter.com/dashboard',
    );
  }

  /// Sign in with a Puter auth token — the primary authentication method.
  Future<User> signInWithToken(String token) async {
    if (token.trim().isEmpty) {
      throw const AuthException('Please enter a valid Puter auth token.');
    }

    _token = token.trim();

    final user = await _fetchUser();
    if (user == null) {
      _token = '';
      throw const AuthException(
        'Invalid Puter auth token. Please check your token and try again.',
      );
    }

    await _secureStorage.write(key: 'puter_auth_token', value: _token);

    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    throw const AuthException(
      'Password reset is managed at https://puter.com',
    );
  }

  @override
  Future<void> signOut() async {
    _token = '';
    _currentUser = null;
    await _secureStorage.delete(key: 'puter_auth_token');
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
