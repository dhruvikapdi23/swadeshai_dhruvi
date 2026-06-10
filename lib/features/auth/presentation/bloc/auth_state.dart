import 'package:equatable/equatable.dart';
import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserEntity? currentUser;
  final bool isLoading;
  final String? errorMessage;

  bool get isLoggedIn => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? currentUser,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, currentUser, isLoading, errorMessage];
}
