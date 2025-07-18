class User {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String favoriteFood;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.favoriteFood,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'favoriteFood': favoriteFood,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      favoriteFood: map['favoriteFood'],
    );
  }
}