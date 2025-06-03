import 'package:game_oclock/blocs/blocs.dart';

class LoginFormBloc extends FormBloc<LoginFormData, Login> {
  LoginFormBloc({required super.formGroup});

  @override
  Login fromDynamicMap(final LoginFormData values) {
    return Login(
      host: values.host.value.text,
      username: values.username.value.text,
      password: values.password.value.text,
    );
  }
}
