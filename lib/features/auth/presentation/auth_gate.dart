import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/widgets/state_views.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_state.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/login_screen.dart';
import 'package:swadesai_dhruvi/features/home/presentation/home_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return switch (state.status) {
          AuthStatus.unknown => const Scaffold(body: LoadingView()),
          AuthStatus.unauthenticated => const LoginScreen(),
          AuthStatus.authenticated => const HomeShell(),
        };
      },
    );
  }
}
