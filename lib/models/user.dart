import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  final List<String> roles;

  const User({
    required this.id,
    required this.username,
    this.password = '',
    this.roles = const [],
  });

  @override
  List<Object?> get props => [id, username];
}
