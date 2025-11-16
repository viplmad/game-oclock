import 'package:game_oclock/models/models.dart'
    show User, UserChangePassword, UserChangePasswordFormData, UserFormData;

import '../form.dart' show FormBloc;

class UserFormBloc extends FormBloc<UserFormData, User> {
  UserFormBloc({required super.data});

  @override
  User fromFormData(final UserFormData data) {
    return User(
      id: '', // TODO
      username: data.username.value!,
      password: data.password.value!,
      roles: data.admin.value == true ? ['ROLE_ADMIN'] : [], // TODO
    );
  }

  @override
  void setFormValue(final UserFormData data, final User? value) {
    data.username.value = value?.username;
    data.password.value = value?.password;
    data.admin.value = value?.roles.contains('ROLE_ADMIN'); // TODO
  }
}

class UserChangePasswordFormBloc
    extends FormBloc<UserChangePasswordFormData, UserChangePassword> {
  UserChangePasswordFormBloc({required super.data});

  @override
  UserChangePassword fromFormData(final UserChangePasswordFormData data) {
    return UserChangePassword(
      currentPassword: data.currentPassword.value!,
      newPassword: data.newPassword.value!,
    );
  }

  @override
  void setFormValue(
    final UserChangePasswordFormData data,
    final UserChangePassword? value,
  ) {
    // Edit not allowed
  }
}
