import 'package:formz/formz.dart';

/// Email validation using formz.
class EmailValidator extends FormzInput<String, EmailValidationError> {
  const EmailValidator.pure() : super.pure('');
  const EmailValidator.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegex.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}

enum EmailValidationError { empty, invalid }

/// Password validation using formz.
class PasswordValidator extends FormzInput<String, PasswordValidationError> {
  const PasswordValidator.pure() : super.pure('');
  const PasswordValidator.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 8) return PasswordValidationError.tooShort;
    return null;
  }
}

enum PasswordValidationError { empty, tooShort }

/// Required field validation using formz.
class RequiredValidator extends FormzInput<String, RequiredValidationError> {
  const RequiredValidator.pure({this.fieldName = 'This field'}) : super.pure('');
  const RequiredValidator.dirty({required String value, this.fieldName = 'This field'})
      : super.dirty(value);

  final String fieldName;

  @override
  RequiredValidationError? validator(String value) {
    if (value.trim().isEmpty) return RequiredValidationError.empty;
    return null;
  }
}

enum RequiredValidationError { empty }

/// Legacy Validators class for backward compatibility.
/// Uses formz validators internally while maintaining the same API.
class Validators {
  const Validators._();

  static String? email(String? value) {
    final input = EmailValidator.dirty(value ?? '');
    if (input.error == null) return null;
    return switch (input.error!) {
      EmailValidationError.empty => 'Email is required',
      EmailValidationError.invalid => 'Enter a valid email address',
    };
  }

  static String? password(String? value) {
    final input = PasswordValidator.dirty(value ?? '');
    if (input.error == null) return null;
    return switch (input.error!) {
      PasswordValidationError.empty => 'Password is required',
      PasswordValidationError.tooShort => 'Password must be at least 8 characters',
    };
  }

  static String? confirmPassword(String? value, String password) {
    if (value?.isEmpty ?? true) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? required(String? value, [String fieldName = 'This field']) {
    final input = RequiredValidator.dirty(value: value ?? '', fieldName: fieldName);
    if (input.error == null) return null;
    return switch (input.error!) {
      RequiredValidationError.empty => '$fieldName is required',
    };
  }
}
