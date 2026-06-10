class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;
}

const demoUsers = <UserEntity>[
  UserEntity(id: 'user-1', name: 'Alex Kumar', email: 'alex@quickslot.demo'),
  UserEntity(id: 'user-2', name: 'Priya Sharma', email: 'priya@quickslot.demo'),
  UserEntity(id: 'user-3', name: 'Rahul Mehta', email: 'rahul@quickslot.demo'),
];
