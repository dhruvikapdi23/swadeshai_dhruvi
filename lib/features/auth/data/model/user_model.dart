import 'package:swadesai_dhruvi/features/auth/domain/entity/user_entity.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        'name': name,
        'email': email,
      };

  UserEntity toEntity() => UserEntity(id: id, name: name, email: email);
}
