import 'package:game_oclock/models/models.dart' show Login, LoginFormData;

import '../form.dart' show FormBloc;

class LoginFormBloc extends FormBloc<LoginFormData, Login> {
  LoginFormBloc({required super.formGroup});

  @override
  Login fromData(final LoginFormData values) {
    return Login(
      host: values.host.value.text,
      username: values.username.value.text,
      password: values.password.value.text,
    );
  }
}
