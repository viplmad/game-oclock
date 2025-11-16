import 'package:game_oclock/models/models.dart' show Login, LoginFormData;

import '../form.dart' show FormBloc;

class LoginFormBloc extends FormBloc<LoginFormData, Login> {
  LoginFormBloc({required super.data});

  @override
  Login fromFormData(final LoginFormData data) {
    return Login(
      host: data.host.value!,
      username: data.username.value!,
      password: data.password.value!,
    );
  }

  @override
  void setFormValue(final LoginFormData data, final Login? value) {
    data.host.value = value?.host;
    data.username.value = value?.username;
    data.password.value = value?.password;
  }
}
