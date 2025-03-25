final class FormGroup {
  final Map<String, FormControl<dynamic>> forms;

  FormGroup({required this.forms});

  Map<String, dynamic> getValues() {
    return forms.map((final key, final val) => MapEntry(key, val.getValue()));
  }

  FormControl<T> getControl<T>(final String name) {
    final control = forms[name];
    if (control == null) {
      throw Error(); // Should be caught while testing
    }
    return control
        as FormControl<T>; // Casting errors should be caught while testing
  }
}

final class FormControl<T> {
  T? _value;

  FormControl();

  void onSave(final T? value) {
    this._value = value;
  }

  T? getValue() {
    return this._value;
  }
}
