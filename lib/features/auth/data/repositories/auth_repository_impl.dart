import 'package:swadesai_dhruvi/features/auth/data/data_source/users_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';
import 'package:swadesai_dhruvi/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final UsersRemoteDataSource _dataSource;

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    String? deviceToken,
  }) async {
    final model = await _dataSource.register(
      name: name,
      email: email,
      password: password,
      deviceToken: deviceToken,
    );
    return model.toEntity();
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
    String? deviceToken,
  }) async {
    final model = await _dataSource.login(
      email: email,
      password: password,
      deviceToken: deviceToken,
    );
    return model.toEntity();
  }
}
