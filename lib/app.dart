import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/di/injection.dart';
import 'package:swadesai_dhruvi/core/theme/app_theme.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/auth_gate.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_cubit.dart';

class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        registerUseCase: Injection.registerUseCase,
        loginUseCase: Injection.loginUseCase,
        sessionService: Injection.sessionService,
        fcmService: Injection.fcmService,
      )..checkSession(),
      child: MaterialApp(
        title: 'QuickSlot',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}
