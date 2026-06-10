import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    String? deviceToken,
  });

  Future<UserEntity> login({
    required String email,
    required String password,
    String? deviceToken,
  });
}
