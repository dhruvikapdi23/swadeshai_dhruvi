import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/di/injection.dart';
import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/core/services/fcm_service.dart';
import 'package:swadesai_dhruvi/core/services/session_service.dart';
import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';
import 'package:swadesai_dhruvi/features/auth/domain/use_cases/auth_usecases.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required SessionService sessionService,
    required FcmService fcmService,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _sessionService = sessionService,
        _fcmService = fcmService,
        super(const AuthState());

  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final SessionService _sessionService;
  final FcmService _fcmService;

  Future<void> checkSession() async {
    final saved = await _sessionService.loadUser();
    if (saved == null) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }
    emit(AuthState(
      status: AuthStatus.authenticated,
      currentUser: UserEntity(
        id: saved['id']!,
        name: saved['name']!,
        email: saved['email']!,
      ),
    ));
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final token = await _fcmService.getDeviceToken();
      final user = await _registerUseCase(
        name: name,
        email: email,
        password: password,
        deviceToken: token,
      );
      await _persistUser(user);
      return true;
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: mapApiError(error, Injection.apiClient.baseUrl),
      ));
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final token = await _fcmService.getDeviceToken();
      final user = await _loginUseCase(
        email: email,
        password: password,
        deviceToken: token,
      );
      await _persistUser(user);
      return true;
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: mapApiError(error, Injection.apiClient.baseUrl),
      ));
      return false;
    }
  }

  Future<void> _persistUser(UserEntity user) async {
    await _sessionService.saveUser(
      id: user.id,
      name: user.name,
      email: user.email,
    );
    emit(AuthState(status: AuthStatus.authenticated, currentUser: user));
  }

  Future<void> logout() async {
    await _sessionService.clear();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
