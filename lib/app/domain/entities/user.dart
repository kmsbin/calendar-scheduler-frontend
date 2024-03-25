class User {
  final String name;
  final String password;
  final String email;

  const User({
    required this.name,
    required this.email,
    this.password = '',
  });

  factory User.fromJson(Map<String, dynamic> jsonMap) {
    return User(
      name: jsonMap['name'] as String,
      password: '',
      email: jsonMap['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}