import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/features/auth/domain/entities/user.dart';
import 'package:mindspace/features/auth/domain/repositories/auth_repository.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';
import 'package:mindspace/app.dart';

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

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const MindSpaceApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
