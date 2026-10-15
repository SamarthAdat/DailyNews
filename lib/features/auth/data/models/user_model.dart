import 'package:daily_news/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.email,
    required super.name,
    required super.signedInAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      signedInAt: DateTime.parse(map['signedInAt'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'signedInAt': signedInAt.toIso8601String(),
  };
}
