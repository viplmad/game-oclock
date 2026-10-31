import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'fields.dart';
import 'nav_destination.dart';

const roleAdmin = 'ROLE_ADMIN';
const roleUser = 'ROLE_USER';

final userRoleField = OptionDynamicField(
  value: 'role',
  type: FieldType.options,
  labelBuilder: (context) => context.localize().roleLabel,
);

final userRoleUser = OptionTextField(
  value: roleUser,
  labelBuilder: (context) => context.localize().roleUserLabel,
);

final userRoleAdmin = OptionTextField(
  value: roleAdmin,
  labelBuilder: (context) => context.localize().roleAdminLabel,
);

final List<OptionTextField<String>> userFieldOptions = List.unmodifiable(
  <OptionTextField<String>>[
    idField,
    nameField,
    userRoleField,
    addedDatetimeField,
    updatedDatetimeField,
  ],
);

final List<OptionTextField<String>> userRoleOptions = List.unmodifiable(
  <OptionTextField<String>>[userRoleUser, userRoleAdmin],
);

class NewUser extends NewUserDTO {
  NewUser({super.username, required this.password});

  final String password;
}

class UserChangePassword {
  final String currentPassword;
  final String newPassword;

  const UserChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}
