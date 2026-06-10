import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/constants/api_constants.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_state.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    // AuthGate auto-navigates to HomeShell when authenticated.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Text('QuickSlot',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                    const SizedBox(height: 8),
                    Text('Book sports slots in seconds',
                        style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 4),
                    Text(
                      'API: ${ApiConstants.baseUrl}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) =>
                          v == null || !v.contains('@') ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (v) =>
                          v == null || v.length < 6 ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
                      ),
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
