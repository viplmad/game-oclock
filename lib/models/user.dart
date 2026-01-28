import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/nav_destination.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

const roleAdmin = 'ROLE_ADMIN';
const roleUser = 'ROLE_USER';

final userRoleUser = OptionTextField(
  value: roleUser,
  labelBuilder: (final context) => context.localize().roleUserLabel,
);

final userRoleAdmin = OptionTextField(
  value: roleAdmin,
  labelBuilder: (final context) => context.localize().roleAdminLabel,
);

final List<OptionTextField<String>> userRoleOptions= List.unmodifiable(
  <OptionTextField<String>>[userRoleUser, userRoleAdmin],
);

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  final String role;

  bool get isAdmin => roleAdmin == role;

  const User({
    required this.id,
    required this.username,
    this.password = '',
    this.role = roleUser,
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
