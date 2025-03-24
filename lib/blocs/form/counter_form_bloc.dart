import 'form.dart' show FormBloc;

class CounterFormBloc extends FormBloc {
  CounterFormBloc({required super.formGroup});

  @override
  Future<void> submitValues(final Map<String, dynamic> values) async {
    await Future.delayed(const Duration(seconds: 1));
    print(values);
    return;
  }
}
