import 'package:game_oclock/models/models.dart'
    show FormData, User, UserChangePassword;
import 'package:reactive_forms/reactive_forms.dart';

class UserFormData extends FormData<User> {
  final FormControl<String> username;
  final FormControl<String> password;
  final FormControl<String> passwordConfirmation;
  final FormControl<String> role;

  UserFormData({
    required this.username,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
  }) : super(
         formGroup: FormGroup(
           {
             'username': username,
             'password': password,
             'passwordConfirmation': passwordConfirmation,
             'role': role,
           },
           validators: [
             const MustMatchValidator('password', 'passwordConfirmation', true),
           ],
         ),
       );
}

class UserChangePasswordFormData extends FormData<UserChangePassword> {
  final FormControl<String> currentPassword;
  final FormControl<String> newPassword;
  final FormControl<String> newPasswordConfirmation;

  UserChangePasswordFormData({
    required this.newPassword,
    required this.currentPassword,
    required this.newPasswordConfirmation,
  }) : super(
         formGroup: FormGroup(
           {
             'currentPassword': currentPassword,
             'newPassword': newPassword,
             'newPasswordConfirmation': newPasswordConfirmation,
           },
           validators: [
             const MustMatchValidator(
               'newPassword',
               'newPasswordConfirmation',
               true,
             ),
           ],
         ),
       );
}
