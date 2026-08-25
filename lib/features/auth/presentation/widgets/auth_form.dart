import 'package:flutter/material.dart';
import 'package:mindspace/core/utils/validators.dart';
import 'package:mindspace/core/widgets/app_text_field.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.onSubmit,
    this.showNameField = false,
    this.submitLabel = 'Sign In',
  });

  final void Function(String email, String password, String? name) onSubmit;
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
  void dispose() {
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
            ),
            const SizedBox(height: 16),
          ],
          AppTextField(
            controller: _emailController,
            label: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
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
          ),
        ],
      ),
    );
  }
}
