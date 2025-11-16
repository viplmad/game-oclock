import 'package:game_oclock/models/models.dart' show FormData, Login;
import 'package:reactive_forms/reactive_forms.dart';

class LoginFormData extends FormData<Login> {
  final FormControl<String> host;
  final FormControl<String> username;
  final FormControl<String> password;

  LoginFormData({
    required this.host,
    required this.username,
    required this.password,
  }) : super(
         formGroup: FormGroup({
           'host': host,
           'username': username,
           'password': password,
         }),
       );
}
