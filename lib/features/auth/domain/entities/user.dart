import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.email,
    required this.name,
    required this.signedInAt,
  });

  final String email;
  final String name;
  final DateTime signedInAt;

  String get initials {
    final parts = name.split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return email[0].toUpperCase();
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  List<Object?> get props => [email, name, signedInAt];
}
