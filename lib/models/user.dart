class User {
  final String? id;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final String? birth;
  final String? gender;
  final String? password;
  final bool? isGoogleUser;

  User({
    this.id,
    this.username,
    this.email,
    this.phoneNumber,
    this.birth,
    this.gender,
    this.password,
    this.isGoogleUser,
  });

  /// Convert User object ke Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'birth': birth,
      'gender': gender,
      'password': password,
      'isGoogleUser': isGoogleUser,
    };
  }

  /// Convert Map<String, dynamic> ke User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      birth: map['birth'],
      gender: map['gender'],
      password: map['password'],
      isGoogleUser: map['isGoogleUser'],
    );
  }
}
