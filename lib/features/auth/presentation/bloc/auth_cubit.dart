import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  List<UserEntity> get availableUsers => demoUsers;

  void selectUser(UserEntity user) => emit(AuthState(currentUser: user));

  void logout() => emit(const AuthState());
}
