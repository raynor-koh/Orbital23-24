import 'dart:convert';
import 'dart:developer';

class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final String password; // May not need to store the password

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user']['_id'] ?? '',
      name: map['user']['name'] ?? '',
      email: map['user']['email'] ?? '',
      token: map['token'] ?? '',
      password: map['user']['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
