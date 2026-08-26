import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';
import 'package:mindspace/features/auth/presentation/screens/login_screen.dart';

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
  testWidgets('LoginScreen renders app icon', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle(); // Wait for animations
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
  });

  testWidgets('LoginScreen renders email and password fields', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('LoginScreen renders Sign In button', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('LoginScreen renders forgot password link', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();
    expect(find.text('Forgot password\u2026'), findsOneWidget);
  });

  testWidgets('LoginScreen renders Sign Up link', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
