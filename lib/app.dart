import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/theme/app_theme.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_cubit.dart';

class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: MaterialApp(
        title: 'QuickSlot',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _AppPlaceholder(),
      ),
    );
  }
}

class _AppPlaceholder extends StatelessWidget {
  const _AppPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('QuickSlot — feature structure ready, UI pending'),
      ),
    );
  }
}
