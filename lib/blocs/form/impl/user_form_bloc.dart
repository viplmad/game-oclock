import 'package:game_oclock/models/models.dart'
    show NewUser, UserChangePassword, UserChangePasswordFormData, UserFormData;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class UserFormBloc extends FormBloc<UserFormData, NewUser, UserDTO> {
  UserFormBloc({required super.data});

  @override
  NewUser fromFormData(final UserFormData data) {
    return NewUser(
      username: data.username.value!,
      password: data.password.value!,
    );
  }

  @override
  void setFormValue(final UserFormData data, final UserDTO? value) {
    data.username.value = value?.username;
  }
}

class UserChangePasswordFormBloc
    extends
        FormBloc<
          UserChangePasswordFormData,
          UserChangePassword,
          UserChangePassword
        > {
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
