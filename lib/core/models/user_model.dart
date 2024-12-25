class UserModel {
  final int id;
  final String username;
  final String password;
  UserModel({required this.id, required this.username, required this.password});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        password = map['password'];
}
