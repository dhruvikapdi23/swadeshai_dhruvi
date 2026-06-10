import 'package:equatable/equatable.dart';
import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';

class AuthState extends Equatable {
  const AuthState({this.currentUser});

  final UserEntity? currentUser;

  bool get isLoggedIn => currentUser != null;

  @override
  List<Object?> get props => [currentUser];
}
