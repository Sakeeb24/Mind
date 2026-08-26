import 'package:flutter/material.dart';
import 'package:mindspace/core/utils/validators.dart';
import 'package:mindspace/core/widgets/app_text_field.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.onSubmit,
    this.onChanged,
    this.showNameField = false,
    this.submitLabel = 'Sign In',
  });

  final void Function(String email, String password, String? name) onSubmit;
  final void Function(String email, String password, String? name)? onChanged;
  final bool showNameField;
  final String submitLabel;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_notifyChanged);
    _passwordController.addListener(_notifyChanged);
    _nameController.addListener(_notifyChanged);
  }

  void _notifyChanged() {
    widget.onChanged?.call(
      _emailController.text,
      _passwordController.text,
      _nameController.text.isEmpty ? null : _nameController.text,
    );
  }

  @override
  void dispose() {
    _emailController.removeListener(_notifyChanged);
    _passwordController.removeListener(_notifyChanged);
    _nameController.removeListener(_notifyChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (widget.showNameField) ...[
            AppTextField(
              controller: _nameController,
              label: 'Full Name',
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) => Validators.required(v, 'Name'),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
          ],
          AppTextField(
            controller: _emailController,
            label: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            prefixIcon: const Icon(Icons.lock_outlined),
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: Validators.password,
            onFieldSubmitted: (_) => _submit(),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      );
    }
  }
}
