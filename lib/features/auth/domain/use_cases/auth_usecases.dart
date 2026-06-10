import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';
import 'package:swadesai_dhruvi/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
    String? deviceToken,
  }) =>
      _repository.register(
        name: name,
        email: email,
        password: password,
        deviceToken: deviceToken,
      );
}

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String email,
    required String password,
    String? deviceToken,
  }) =>
      _repository.login(
        email: email,
        password: password,
        deviceToken: deviceToken,
      );
}
