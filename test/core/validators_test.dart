import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('user.name@domain.co'), isNull);
    });

    test('returns error for empty email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for invalid email format', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('@domain.com'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
    });

    test('returns correct error message for empty', () {
      expect(Validators.email(''), 'Email is required');
    });
  });

  group('Validators.password', () {
    test('returns null for valid password (8+ chars)', () {
      expect(Validators.password('Password1'), isNull);
      expect(Validators.password('abcdefgh'), isNull);
      expect(Validators.password('12345678'), isNull);
    });

    test('returns error for empty password', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('returns error for short password', () {
      expect(Validators.password('Ab1'), isNotNull);
      expect(Validators.password('1234567'), isNotNull);
    });

    test('returns correct error messages', () {
      expect(Validators.password(''), 'Password is required');
      expect(Validators.password('short'), 'Password must be at least 8 characters');
    });
  });

  group('Validators.confirmPassword', () {
    test('returns null when passwords match', () {
      expect(Validators.confirmPassword('password', 'password'), isNull);
    });

    test('returns error for empty value', () {
      expect(Validators.confirmPassword('', 'password'), isNotNull);
      expect(Validators.confirmPassword(null, 'password'), isNotNull);
    });

    test('returns error when passwords do not match', () {
      expect(Validators.confirmPassword('different', 'password'), isNotNull);
    });
  });

  group('Validators.required', () {
    test('returns null for non-empty value', () {
      expect(Validators.required('hello', 'Field'), isNull);
    });

    test('returns error for empty value', () {
      expect(Validators.required('', 'Field'), isNotNull);
      expect(Validators.required(null, 'Field'), isNotNull);
    });

    test('returns error for whitespace-only value', () {
      expect(Validators.required('   ', 'Field'), isNotNull);
    });

    test('includes field name in error message', () {
      final error = Validators.required('', 'Email');
      expect(error, contains('Email'));
    });
  });
}
