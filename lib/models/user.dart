import 'package:equatable/equatable.dart';

const roleAdmin = 'ROLE_ADMIN';

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  final List<String> roles;

  bool get isAdmin => roles.contains(roleAdmin);

  const User({
    required this.id,
    required this.username,
    this.password = '',
    this.roles = const [],
  });

  @override
  List<Object?> get props => [id, username];
}

class UserChangePassword {
  final String currentPassword;
  final String newPassword;

  const UserChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}
