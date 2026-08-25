import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';
import 'package:mindspace/features/auth/presentation/screens/login_screen.dart';

/// Minimal mock for widget tests.
class FakeAuthRepository implements AuthRepository {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  Future<User> signInWithEmail({required String email, required String password}) async {
    return User(id: 'test', email: email);
  }

  @override
  Future<User> signUpWithEmail({required String email, required String password, String? displayName}) async {
    return User(id: 'test', email: email);
  }

  @override
  Future<User> signInWithGoogle() async {
    return const User(id: 'google', email: 'user@gmail.com');
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {}
}

Widget buildTestApp({AuthRepository? repo}) {
  return ProviderScope(
    overrides: [
      if (repo != null) authRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const LoginScreen(),
    ),
  );
}

void main() {
  group('LoginScreen', () {
    testWidgets('renders welcome text', (tester) async {
      await tester.pumpWidget(buildTestApp(repo: FakeAuthRepository()));
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue studying'), findsOneWidget);
    });

    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(buildTestApp(repo: FakeAuthRepository()));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders Sign In button', (tester) async {
      await tester.pumpWidget(buildTestApp(repo: FakeAuthRepository()));
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('renders Google sign in button', (tester) async {
      await tester.pumpWidget(buildTestApp(repo: FakeAuthRepository()));
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('renders forgot password link', (tester) async {
      await tester.pumpWidget(buildTestApp(repo: FakeAuthRepository()));
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('renders sign up link', (tester) async {
      await tester.pumpWidget(buildTestApp(repo: FakeAuthRepository()));
      expect(find.textContaining("have an account"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('renders app icon', (tester) async {
      await tester.pumpWidget(buildTestApp(repo: FakeAuthRepository()));
      expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    });
  });
}
