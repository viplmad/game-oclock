import 'package:game_oclock/models/models.dart' show User, UserFormData;

import '../form.dart' show FormBloc;

class UserFormBloc extends FormBloc<UserFormData, User> {
  UserFormBloc({required super.formGroup});

  @override
  User fromData(final UserFormData values) {
    return User(
      id: 'kalmdkamsd', // TODO
      username: values.username.text,
      password: values.password.text,
      roles: values.admin.value == true ? ['ROLE_ADMIN'] : [],
    );
  }
}
