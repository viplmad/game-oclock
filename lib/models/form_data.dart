import 'package:reactive_forms/reactive_forms.dart';

abstract class FormData<T> {
  final FormGroup formGroup;

  const FormData({required this.formGroup});
}
